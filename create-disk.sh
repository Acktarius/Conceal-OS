#!/bin/bash
# Script to write Conceal OS image to disk (USB, SSD, HDD, etc.)
# The image will automatically expand to use the full disk on first boot

if [ "$EUID" -ne 0 ]; then
    echo "Run with: sudo $0"
    exit 1
fi

# Select image file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Run interactively - prompts go to stderr (visible), path goes to stdout (captured)
QCOW2_IMAGE=$(bash "$SCRIPT_DIR/select-image.sh")
SELECT_EXIT=$?
if [ $SELECT_EXIT -ne 0 ] || [ -z "$QCOW2_IMAGE" ]; then
    exit 1
fi
RAW_IMAGE="${QCOW2_IMAGE}.raw"

if [ ! -f "$QCOW2_IMAGE" ]; then
    echo "Error: $QCOW2_IMAGE not found!"
    exit 1
fi

if [ ! -f "$RAW_IMAGE" ]; then
    echo "Converting to raw..."
    qemu-img convert -f qcow2 -O raw "$QCOW2_IMAGE" "$RAW_IMAGE" || {
        echo "✗ qemu-img convert failed"
        exit 1
    }
fi

# Get virtual size (what we need to write)
IMAGE_VIRTUAL_SIZE=$(qemu-img info "$QCOW2_IMAGE" 2>/dev/null | grep "virtual size" | awk '{print $3, $4}')
DISK_SIZE=$(qemu-img info "$QCOW2_IMAGE" 2>/dev/null | grep "disk size" | awk '{print $3, $4}')
echo "Image virtual size: $IMAGE_VIRTUAL_SIZE"
echo "Image disk size: $DISK_SIZE"

echo "Available disk devices:"
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN | grep -E "^(NAME|sd|nvme)" | grep -E "(disk|usb)"
echo ""

read -p "Enter disk device (e.g., sdb, sda, nvme0n1): " dev
if [ -z "$dev" ] || [ ! -b "/dev/$dev" ]; then
    echo "Invalid device"
    exit 1
fi

read -p "Type device name again to confirm: " dev2
if [ "$dev2" != "$dev" ]; then
    echo "Device mismatch, aborting."
    exit 1
fi

DISK_SIZE_STR=$(lsblk -h -d -o SIZE "/dev/$dev" | tail -1)
echo "Target disk size: $DISK_SIZE_STR"

# Get sizes in bytes for comparison
IMAGE_SIZE_BYTES=$(qemu-img info "$QCOW2_IMAGE" 2>/dev/null | grep "virtual size" | sed -n 's/.*(\([0-9]*\) bytes).*/\1/p')
TARGET_SIZE_BYTES=$(blockdev --getsize64 "/dev/$dev" 2>/dev/null)

if [ -n "$IMAGE_SIZE_BYTES" ] && [ -n "$TARGET_SIZE_BYTES" ]; then
    if [ "$TARGET_SIZE_BYTES" -lt "$IMAGE_SIZE_BYTES" ]; then
        echo ""
        echo "✗ ERROR: Target disk is too small!"
        echo "  Image needs: $IMAGE_VIRTUAL_SIZE"
        echo "  Disk has: $DISK_SIZE_STR"
        echo ""
        echo "You need a disk with at least $IMAGE_VIRTUAL_SIZE"
        exit 1
    fi
    echo "✓ Target disk is large enough"
    if [ "$TARGET_SIZE_BYTES" -gt "$IMAGE_SIZE_BYTES" ]; then
        echo "  Note: Disk is larger than image. System will auto-expand on first boot."
    fi
fi

echo ""
echo "⚠ LAST WARNING: /dev/$dev will be completely overwritten!"
lsblk "/dev/$dev"
read -p "Type YES in uppercase to continue: " final
if [ "$final" != "YES" ]; then
    echo "Aborted."
    exit 0
fi

echo "Writing to /dev/$dev (sparse, skips zeros)..."
dd if="$RAW_IMAGE" of="/dev/$dev" bs=4M status=progress conv=sparse,fsync || {
    echo "✗ dd write failed"
    exit 1
}

sync
partprobe "/dev/$dev" 2>/dev/null || true

echo ""
echo "✓ Done! Image written to /dev/$dev"
if [ -n "$TARGET_SIZE_BYTES" ] && [ -n "$IMAGE_SIZE_BYTES" ] && [ "$TARGET_SIZE_BYTES" -gt "$IMAGE_SIZE_BYTES" ]; then
    echo ""
    echo "Note: The system will automatically expand to use the full disk on first boot."
fi

