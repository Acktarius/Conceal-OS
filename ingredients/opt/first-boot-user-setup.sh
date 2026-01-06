#!/bin/bash
# First-boot script to optionally delete default "conceal" user and create new user
# This script runs once on first boot

FIRST_BOOT_FLAG="/var/lib/first-boot-user-setup-done"

# Only run once
if [ -f "$FIRST_BOOT_FLAG" ]; then
    exit 0
fi

# Create flag file immediately to prevent multiple runs
touch "$FIRST_BOOT_FLAG"

# For now, we keep the "conceal" user as default
# Users can manually delete it and create their own if desired
# Or uncomment below to automatically delete and prompt for new user

# Uncomment to enable automatic user deletion and creation:
# if id -u conceal >/dev/null 2>&1; then
#     # Delete conceal user and home directory
#     userdel -r conceal 2>/dev/null || true
#     groupdel conceal 2>/dev/null || true
# fi
# 
# # Prompt for new user creation (requires console access)
# # This would need to be run interactively
# # For automated systems, keep the default user

exit 0

