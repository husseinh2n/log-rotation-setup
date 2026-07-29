#!/usr/bin/env bash
# Exit immediately if any command fails
set -e

echo "Running logrotate validation..."

# Path to the configuration file being tested
CONFIG_FILE="config/logrotate.conf"

# Ensure the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE" >&2
    exit 1
fi

# Dry-run logrotate (-d) with verbose output (-v) to catch syntax errors and logic issues
# We use a temporary state file so it doesn't interfere with system logrotate states
logrotate -d -v -s /tmp/logrotate.status "$CONFIG_FILE"

echo "Logrotate configuration syntax is valid!"