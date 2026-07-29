# Use a stable, lightweight Linux image suitable for running cron and logrotate
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=non-interactive

# Install logrotate, cron, and curl for health checks
RUN apt-get update && \
    apt-get install -y --no-install-recommends logrotate cron curl && \
    rm -rf /var/lib/apt/lists/*

# Create a dummy log directory and a target log file to simulate an app
RUN mkdir -p /var/log/myapp

# Copy our custom logrotate configuration into the system's logrotate directory
COPY config/logrotate.conf /etc/logrotate.d/myapp

# Ensure correct permissions on the logrotate config (logrotate fails if permissions are too open)
RUN chmod 644 /etc/logrotate.d/myapp

# Copy entrypoint script to manage services and run validation
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose nothing, this is a background worker container
ENTRYPOINT ["/entrypoint.sh"]