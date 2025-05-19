#!/bin/bash
# This script builds Hetzner Cloud images for Talos using Packer.

set -euo pipefail



command -v hwcli >/dev/null 2>&1 || {
    echo >&2 "Error: packer is not installed."
    echo >&2 "Install it via https://www.packer.io/downloads or 'brew install packer' on macOS."
    exit 1
}