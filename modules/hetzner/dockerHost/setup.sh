#!/bin/bash
# This script builds Hetzner Cloud images for Talos using Packer.

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
# Pipelines return the exit status of the last command to exit non-zero.
set -euo pipefail

# Check if packer is installed
command -v hwcli >/dev/null 2>&1 || {
    echo >&2 "Error: packer is not installed."
    echo >&2 "Install it via https://www.packer.io/downloads or 'brew install packer' on macOS."
    exit 1
}