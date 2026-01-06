#!/bin/bash
# Script to boot Conceal OS VM locally for testing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"

# Select image file
QCOW2_IMAGE=$(bash "$SCRIPT_DIR/select-image.sh")
if [ $? -ne 0 ] || [ -z "$QCOW2_IMAGE" ]; then
    exit 1
fi

if [ ! -f "$QCOW2_IMAGE" ]; then
    echo "Error: $QCOW2_IMAGE not found!"
    exit 1
fi

echo "Booting: $QCOW2_IMAGE"
echo ""
echo "Display options:"
echo "1) GTK (GUI window)"
echo "2) VNC (localhost:5900)"
read -p "Select display [1-2] (default: 1): " display_choice
display_choice=${display_choice:-1}

case $display_choice in
    1)
        DISPLAY_OPT="-display gtk"
        ;;
    2)
        DISPLAY_OPT="-display vnc=:0"
        echo "Connect with VNC viewer to localhost:5900"
        ;;
    *)
        DISPLAY_OPT="-display gtk"
        ;;
esac

echo ""
echo "Press Ctrl+Alt+G to release mouse/keyboard"
echo "SSH will be available on localhost:2222"
echo ""

# Boot VM with KVM acceleration
qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -smp 2 \
    -drive file="$QCOW2_IMAGE",format=qcow2 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device virtio-net,netdev=net0 \
    $DISPLAY_OPT \
    -vga virtio

