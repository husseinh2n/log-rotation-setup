#!/usr/bin/env bash
# Exit immediately on error
set -e

echo "Starting log-rotation-setup container..."

# Run the validation script on startup to ensure configuration is correct
./scripts/validate.sh || echo "Validation warning encountered, proceeding..."

# Start the cron service in the foreground so the container stays alive
# Cron reads /etc/cron.daily/logrotate automatically to execute rotations
echo "Starting cron daemon for scheduled log rotation..."
exec cron -f