#!/bin/bash
set -euo pipefail
exec python3 "$(dirname -- "${BASH_SOURCE[0]}")/backup.py" export "$@"
