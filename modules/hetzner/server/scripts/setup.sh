#!/bin/bash
set -euo pipefail

command -v hcloud >/dev/null 2>&1 || {
    echo >&2 "Error: hcloud is not installed."
    echo >&2 "Install it via https://github.com/hetznercloud/cli or 'brew install hcloud' on macOS."
    exit 1
}

REQUIRED_ENV_VARS=("HCLOUD_TOKEN" "AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY")

for var_name in "${REQUIRED_ENV_VARS[@]}"; do
    # Get the value of the variable using indirect expansion
    if [[ -z "${!var_name:-}" ]]; then
        echo "$var_name is not set."
        exit 1
    fi
done
