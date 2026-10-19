"""Regression tests using disposable homes and fake key material only."""

import io
import os
import socket
import stat
import subprocess
import tarfile
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import backup

SCRIPTS = Path(__file__).resolve().parent


class BackupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.home = self.root / "source home"
        self.home.mkdir()
        self.destination = self.root / "restored home"
        self.destination.mkdir()
        self.output = self.root / "backup files"

    def run_script(self, script, *args, home=None, succeeds=True):
        result = subprocess.run(
            ["bash", str(SCRIPTS / script), *map(str, args)],
            env={**os.environ, "HOME": str(home or self.home)},
            text=True,
            capture_output=True,
            check=False,
        )
        if succeeds:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def fixture(self):
        for directory in (".ssh", ".gnupg/private-keys-v1.d"):
            (self.home / directory).mkdir(parents=True, mode=0o700)
        for name, mode in (
            (".ssh/id_ed25519", 0o600),
            (".ssh/id_ed25519.pub", 0o644),
            (".gnupg/private-keys-v1.d/example.key", 0o600),
            (".bash_history", 0o600),
            (".zsh_history", 0o600),
        ):
            path = self.home / name
            path.write_text(f"fake contents: {name}\n")
            path.chmod(mode)
            os.utime(path, (1700000000, 1700000000))

    def export(self):
        self.run_script("export.sh", self.output)
        return next(self.output.glob("*.tar.gz"))

    def test_round_trip_permissions_exclusions_and_saved_originals(self):
        self.fixture()
        for name in (".gnupg/pubring.kbx.lock", ".gnupg/.#lk123", ".gnupg/file.tmp"):
            (self.home / name).write_text("transient")
        with socket.socket(socket.AF_UNIX) as agent:
            agent.bind(str(self.home / ".gnupg/S.gpg-agent"))
            archive = self.export()
        self.assertEqual(stat.S_IMODE(archive.stat().st_mode), 0o600)
        (self.destination / ".ssh").mkdir()
        (self.destination / ".ssh/old-key").write_text("old fake key")
        (self.destination / "unrelated").write_text("keep")
        self.run_script("import.sh", archive, home=self.destination)
        for name in (
            ".ssh/id_ed25519",
            ".ssh/id_ed25519.pub",
            ".gnupg/private-keys-v1.d/example.key",
            ".bash_history",
            ".zsh_history",
        ):
            original, restored = self.home / name, self.destination / name
            self.assertEqual(restored.read_bytes(), original.read_bytes())
            self.assertEqual(
                stat.S_IMODE(restored.stat().st_mode),
                stat.S_IMODE(original.stat().st_mode),
            )
            self.assertEqual(restored.stat().st_mtime, original.stat().st_mtime)
        self.assertEqual(
            stat.S_IMODE((self.destination / ".ssh").stat().st_mode), 0o700
        )
        self.assertFalse((self.destination / ".gnupg/S.gpg-agent").exists())
        self.assertFalse((self.destination / ".gnupg/file.tmp").exists())
        self.assertEqual((self.destination / "unrelated").read_text(), "keep")
        saved = next(self.destination.glob(".dotfiles-before-restore-*"))
        self.assertEqual((saved / ".ssh/old-key").read_text(), "old fake key")
        with tarfile.open(archive) as contents:
            self.assertFalse(
                any(
                    ".#lk" in name or name.endswith(".lock")
                    for name in contents.getnames()
                )
            )

    def test_missing_inputs_and_history_only_backup(self):
        self.run_script("export.sh", self.output, succeeds=False)
        self.assertFalse(self.output.exists())
        (self.home / ".zsh_history").write_text("fake command\n")
        archive = self.export()
        self.run_script("import.sh", archive, home=self.destination)
        self.assertEqual(
            (self.destination / ".zsh_history").read_text(), "fake command\n"
        )
        self.assertFalse(list(self.destination.glob(".dotfiles-before-restore-*")))

    def test_export_rejects_symlinks_and_recursive_output(self):
        self.fixture()
        (self.home / ".ssh/link").symlink_to("id_ed25519")
        self.run_script("export.sh", self.output, succeeds=False)
        self.assertFalse(self.output.exists())
        (self.home / ".ssh/link").unlink()
        self.run_script("export.sh", self.home / ".ssh/backups", succeeds=False)

    def test_unsafe_archives_leave_existing_data_untouched(self):
        (self.destination / ".zsh_history").write_text("original")
        bad_entries = [
            [("../escaped", tarfile.REGTYPE)],
            [("/tmp/escaped", tarfile.REGTYPE)],
            [(".config/other", tarfile.REGTYPE)],
            [(".ssh/link", tarfile.SYMTYPE)],
            [(".ssh/link", tarfile.LNKTYPE)],
            [(".ssh/fifo", tarfile.FIFOTYPE)],
            [(".zsh_history/child", tarfile.REGTYPE)],
            [(".zsh_history", tarfile.REGTYPE), (".zsh_history", tarfile.REGTYPE)],
            [(".ssh/file", tarfile.REGTYPE), (".ssh/file/child", tarfile.REGTYPE)],
        ]
        for entries in bad_entries:
            with self.subTest(entries=entries):
                archive = self.root / "bad.tar.gz"
                with tarfile.open(archive, "w:gz") as contents:
                    for name, kind in entries:
                        info = tarfile.TarInfo(name)
                        info.type = kind
                        info.linkname = (
                            "../../escaped"
                            if kind in (tarfile.SYMTYPE, tarfile.LNKTYPE)
                            else ""
                        )
                        info.size = 1 if kind == tarfile.REGTYPE else 0
                        contents.addfile(
                            info, io.BytesIO(b"x") if info.isfile() else None
                        )
                self.run_script(
                    "import.sh", archive, home=self.destination, succeeds=False
                )
                self.assertEqual(
                    (self.destination / ".zsh_history").read_text(), "original"
                )
                self.assertEqual(
                    sorted(p.name for p in self.destination.iterdir()), [".zsh_history"]
                )

    def test_restore_rolls_back_after_a_failed_move(self):
        self.fixture()
        archive = self.export()
        for name in (".ssh", ".gnupg"):
            (self.destination / name).mkdir()
            (self.destination / name / "old").write_text(name)
        rename = Path.rename

        def fail_install(path, target):
            if (
                path.parent.name.startswith(".dotfiles-restore-")
                and path.name == ".ssh"
            ):
                raise OSError("simulated failed move")
            return rename(path, target)

        with (
            patch.object(Path, "rename", fail_install),
            self.assertRaisesRegex(OSError, "simulated"),
        ):
            backup.import_backup(self.destination, archive)
        for name in (".ssh", ".gnupg"):
            self.assertEqual((self.destination / name / "old").read_text(), name)
        self.assertFalse((self.destination / ".bash_history").exists())
        self.assertFalse(list(self.destination.glob(".dotfiles-*")))


if __name__ == "__main__":
    unittest.main()
