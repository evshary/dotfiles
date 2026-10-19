"""Back up and restore SSH/GPG directories and shell history without encryption."""

import argparse
import fnmatch
import os
import shutil
import stat
import sys
import tarfile
import tempfile
from datetime import datetime
from pathlib import Path, PurePosixPath

DIRECTORIES = {".ssh", ".gnupg"}
HISTORIES = {".bash_history", ".zsh_history"}
TARGETS = sorted(DIRECTORIES | HISTORIES)


def collect(path, name):
    mode = path.lstat().st_mode
    if stat.S_ISSOCK(mode):
        return []
    if name.parts[0] == ".gnupg" and any(
        fnmatch.fnmatch(path.name, pattern)
        for pattern in ("S.gpg-agent*", ".#lk*", "*.lock", "*.tmp")
    ):
        return []
    if not (stat.S_ISREG(mode) or stat.S_ISDIR(mode)):
        raise ValueError(f"Unsupported file type (including symlinks): {path}")
    entries = [(path, name.as_posix())]
    if stat.S_ISDIR(mode):
        for child in sorted(path.iterdir()):
            entries.extend(collect(child, name / child.name))
    return entries


def export_backup(home, directory):
    entries = []
    for name in TARGETS:
        path = home / name
        if not os.path.lexists(path):
            continue
        if path.is_symlink() or (name in DIRECTORIES) != path.is_dir():
            raise ValueError(f"Unexpected file type: {path}")
        entries.extend(collect(path, PurePosixPath(name)))
    if not entries:
        raise ValueError("No SSH/GPG directories or shell history files found.")
    directory = directory.resolve()
    # Keeping the output outside the source directories avoids recursive backups.
    for name in DIRECTORIES:
        if directory == home / name or home / name in directory.parents:
            raise ValueError("The backup directory must be outside .ssh and .gnupg.")
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    output = directory / f"dotfiles-backup-{timestamp}.tar.gz"
    stream = output.open("xb")
    try:
        with stream:
            os.chmod(output, 0o600)
            with tarfile.open(fileobj=stream, mode="w:gz", dereference=True) as archive:
                for path, name in entries:
                    archive.add(path, arcname=name, recursive=False)
    except BaseException:
        output.unlink(missing_ok=True)
        raise
    print(f"Created backup: {output}")


def validate(archive):
    members = archive.getmembers()
    seen = set()
    for member in members:
        path = PurePosixPath(member.name)
        if (
            not path.parts
            or path.is_absolute()
            or ".." in path.parts
            or member.name.rstrip("/") != path.as_posix()
            or path.parts[0] not in TARGETS
            or path in seen
        ):
            raise ValueError(f"Invalid or duplicate archive path: {member.name!r}")
        root = path.parts[0]
        if root in HISTORIES and (len(path.parts) != 1 or not member.isfile()):
            raise ValueError(f"Invalid history entry: {member.name!r}")
        if root in DIRECTORIES and len(path.parts) == 1 and not member.isdir():
            raise ValueError(f"Expected a directory: {member.name!r}")
        if not (member.isdir() or member.isfile()):
            raise ValueError(f"Unsupported archive entry: {member.name!r}")
        seen.add(path)
    if not members:
        raise ValueError("The backup archive is empty.")
    files = {PurePosixPath(m.name) for m in members if m.isfile()}
    for path in seen:
        if any(parent in files for parent in path.parents):
            raise ValueError(f"Archive file used as a directory: {path}")
    return members


def import_backup(home, filename):
    # Validate everything and stage the contents before touching existing data.
    with tarfile.open(filename, mode="r:gz") as archive:
        members = validate(archive)
        roots = sorted({PurePosixPath(m.name).parts[0] for m in members})
        with tempfile.TemporaryDirectory(prefix=".dotfiles-restore-", dir=home) as temp:
            staging = Path(temp)
            for member in members:
                path = staging / member.name
                if member.isdir():
                    path.mkdir(parents=True, exist_ok=True)
                else:
                    path.parent.mkdir(parents=True, exist_ok=True)
                    with (
                        archive.extractfile(member) as source,
                        path.open("xb") as target,
                    ):
                        shutil.copyfileobj(source, target)
                    os.chmod(path, member.mode & 0o777)
                    os.utime(path, (member.mtime, member.mtime))
            for member in sorted(
                members, key=lambda m: len(PurePosixPath(m.name).parts), reverse=True
            ):
                if member.isdir():
                    path = staging / member.name
                    os.chmod(path, member.mode & 0o777)
                    os.utime(path, (member.mtime, member.mtime))
            for name in roots:
                os.chmod(staging / name, 0o700 if name in DIRECTORIES else 0o600)
            existing = [name for name in roots if os.path.lexists(home / name)]
            previous = (
                Path(tempfile.mkdtemp(prefix=".dotfiles-before-restore-", dir=home))
                if existing
                else None
            )
            saved, installed = [], []
            try:
                for name in existing:
                    (home / name).rename(previous / name)
                    saved.append(name)
                for name in roots:
                    (staging / name).rename(home / name)
                    installed.append(name)
            except BaseException:
                for name in reversed(installed):
                    (home / name).rename(staging / name)
                for name in reversed(saved):
                    (previous / name).rename(home / name)
                if previous is not None:
                    previous.rmdir()
                raise
            print(f"Restored: {', '.join(roots)}")
            if previous is not None:
                print(f"Previous files saved in: {previous}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    export = commands.add_parser("export", help="Create a private tar.gz archive.")
    export.add_argument(
        "directory",
        nargs="?",
        type=Path,
        default=Path(__file__).resolve().parent.parent / "backup",
    )
    restore = commands.add_parser(
        "import", help="Restore an archive, saving existing data first."
    )
    restore.add_argument("archive", type=Path)
    args = parser.parse_args()
    # New archives, staging directories, and saved originals are private.
    os.umask(0o077)
    try:
        home = Path.home().resolve()
        if args.command == "export":
            export_backup(home, args.directory)
        else:
            import_backup(home, args.archive)
    except (OSError, ValueError, EOFError, tarfile.TarError) as error:
        print(f"Backup error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
