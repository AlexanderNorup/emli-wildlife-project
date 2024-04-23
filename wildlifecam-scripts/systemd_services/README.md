# Systemd services

**How to?**:

1. Copy the `.service` files to `/etc/systemd/system`
2. Reload the systemd daemon: `sudo systemctl daemon-reload`
3. Start each service using `sudo systemctl start <name>`.
4. (Optional) Check status of each service using `sudo systemctl status <name>`
5. When good, you can enable the services to run on startup using `sudo systemctl enable <name>`
