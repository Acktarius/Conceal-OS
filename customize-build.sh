#!/bin/bash
# Script to customize Conceal OS build with user credentials

echo "This will create your customized ISO from scratch"
echo ""

# Prompt for build type
echo "Select build type:"
echo "1) Conceal-OS-Miner (Miner configuration)"
echo "2) Conceal-OS-xfce (XFCE desktop configuration)"
echo "3) Conceal-Pi-OS (Raspberry Pi configuration)"
echo "4) Conceal-OS (Full configuration Ubuntu)"
read -p "Enter choice [1-4]: " build_choice

case $build_choice in
    1)
        template_file="Conceal-OS-Miner.json.template"
        output_file="Conceal-OS-Miner.json"
        http_dir="http-1"
        needs_credentials=true
        ;;
    2)
        template_file="Conceal-OS-xfce.json.template"
        output_file="Conceal-OS-xfce.json"
        http_dir="http-2"
        needs_credentials=true
        ;;
    3)
        template_file="Conceal-Pi-OS.json.template"
        output_file="Conceal-Pi-OS.json"
        http_dir="http-3"
        needs_credentials=false
        ;;
    4)
        template_file="Conceal-OS.json.template"
        output_file="Conceal-OS.json"
        http_dir="http-4"
        needs_credentials=true
        ;;

    *)
        echo "Error: Invalid choice. Please select 1, 2, 3, or 4"
        exit 1
        ;;
esac

# Check if template file exists
if [ ! -f "$template_file" ]; then
    echo "Error: Template file '$template_file' not found"
    exit 1
fi

# Prompt for username and password only if needed
if [ "$needs_credentials" = true ]; then
    read -p "Enter username: " username
    if [ -z "$username" ]; then
        echo "Error: Username cannot be empty"
        exit 1
    fi

    read -sp "Enter password: " password
    echo ""
    if [ -z "$password" ]; then
        echo "Error: Password cannot be empty"
        exit 1
    fi

    # Generate SHA-512 password hash (Ubuntu uses SHA-512)
    echo "Generating password hash..."
    password_hash=$(openssl passwd -6 "$password")

    # Restore from templates and replace placeholders
    echo "Updating configuration files..."

    # Restore user-data from template
    cp "$http_dir/user-data.temp" "$http_dir/user-data"
    sed -i "s/    username: conceal/    username: $username/" "$http_dir/user-data"
    sed -i "s|    password: \".*\"|    password: \"$password_hash\"|" "$http_dir/user-data"
    sed -i "s/echo 'conceal ALL=(ALL) NOPASSWD:ALL'/echo '$username ALL=(ALL) NOPASSWD:ALL'/" "$http_dir/user-data"
    sed -i "s|/etc/sudoers.d/conceal|/etc/sudoers.d/$username|" "$http_dir/user-data"

    # Restore JSON from template
    cp "$template_file" "$output_file"
    # Only replace in variables section (builder section uses {{user `variable`}})
    sed -i "/\"variables\":/,/},/ s/\"ssh_username\": \"conceal\"/\"ssh_username\": \"$username\"/" "$output_file"
    sed -i "/\"variables\":/,/},/ s/\"ssh_password\": \"conceal\"/\"ssh_password\": \"$password\"/" "$output_file"
else
    # For Pi builds, just copy the template (no credential replacement needed)
    echo "Updating configuration files..."
    cp "$template_file" "$output_file"
fi

echo "Configuration updated"
echo ""
echo "Starting Packer build..."
packer-1.11.0 build "$output_file"

