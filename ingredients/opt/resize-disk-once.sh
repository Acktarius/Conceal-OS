#!/bin/bash
# First-boot script to resize LVM volume to use full disk
# This script runs once on first boot and then disables itself

FIRST_BOOT_FLAG="/var/lib/resize-disk-done"

# Only run once
if [ -f "$FIRST_BOOT_FLAG" ]; then
    exit 0
fi

# Create flag file immediately to prevent multiple runs
touch "$FIRST_BOOT_FLAG"

# Log to syslog
logger -t resize-disk "Starting disk resize on first boot"

# Get the root device
ROOT_DEV=$(findmnt -n -o SOURCE / | head -1)
if [ -z "$ROOT_DEV" ]; then
    logger -t resize-disk "ERROR: Could not determine root device"
    exit 1
fi

# Check if we're using LVM
if [[ "$ROOT_DEV" =~ /dev/mapper/.*-.* ]]; then
    # Extract VG and LV from /dev/mapper/vg-lv
    MAPPER_NAME=$(basename "$ROOT_DEV")
    VG_NAME=$(echo "$MAPPER_NAME" | cut -d'-' -f1)
    LV_NAME=$(echo "$MAPPER_NAME" | sed "s/^${VG_NAME}-//")
    
    logger -t resize-disk "Detected LVM: VG=$VG_NAME, LV=$LV_NAME"
    
    # Get the physical volume
    PV_DEV=$(pvs --noheadings -o pv_name | head -1 | tr -d ' ')
    if [ -z "$PV_DEV" ]; then
        logger -t resize-disk "ERROR: Could not determine physical volume"
        exit 1
    fi
    
    # Get the partition containing the PV
    PART_DEV=$(lsblk -n -o NAME "$PV_DEV" | head -1)
    if [[ "$PART_DEV" =~ ^[0-9]+$ ]]; then
        # It's a partition number, get the disk
        DISK_DEV=$(lsblk -n -o PKNAME "$PV_DEV" | head -1)
        PART_DEV="/dev/${DISK_DEV}${PART_DEV}"
    else
        PART_DEV="$PV_DEV"
    fi
    
    # Get the disk device
    DISK_DEV=$(lsblk -n -d -o PKNAME "$PART_DEV" | head -1)
    if [ -z "$DISK_DEV" ]; then
        DISK_DEV=$(echo "$PART_DEV" | sed 's/[0-9]*$//')
    fi
    DISK_DEV="/dev/$DISK_DEV"
    
    logger -t resize-disk "Disk: $DISK_DEV, Partition: $PART_DEV, PV: $PV_DEV"
    
    # Check if partition needs resizing
    PART_NUM=$(echo "$PART_DEV" | grep -o '[0-9]*$')
    if [ -n "$PART_NUM" ]; then
        # Resize partition using growpart
        if command -v growpart >/dev/null 2>&1; then
            logger -t resize-disk "Resizing partition $PART_DEV"
            growpart "$DISK_DEV" "$PART_NUM" 2>&1 | logger -t resize-disk || {
                logger -t resize-disk "WARNING: growpart failed (partition may already be at max size), continuing anyway"
            }
            partprobe "$DISK_DEV" || true
            sleep 2
        fi
    fi
    
    # Resize physical volume (will do nothing if already at max)
    logger -t resize-disk "Resizing physical volume $PV_DEV"
    pvresize "$PV_DEV" 2>&1 | logger -t resize-disk || {
        logger -t resize-disk "WARNING: pvresize failed (may already be at max size), continuing"
    }
    
    # Check if there's free space in the volume group
    VG_FREE=$(vgs --noheadings -o vg_free "$VG_NAME" 2>/dev/null | tr -d ' ' | grep -v '^$')
    if [ -n "$VG_FREE" ] && [ "$VG_FREE" != "0" ] && [ "$VG_FREE" != "0.00g" ] && [ "$VG_FREE" != "0.00m" ]; then
        # Extend logical volume to use all available space
        logger -t resize-disk "Extending logical volume $VG_NAME/$LV_NAME (free space: $VG_FREE)"
        lvextend -l +100%FREE "$VG_NAME/$LV_NAME" 2>&1 | logger -t resize-disk || {
            logger -t resize-disk "WARNING: lvextend failed (may already be at max size), continuing"
        }
        
        # Resize filesystem
        FSTYPE=$(blkid -o value -s TYPE "$ROOT_DEV")
        logger -t resize-disk "Resizing $FSTYPE filesystem on $ROOT_DEV"
        
        case "$FSTYPE" in
            ext4|ext3|ext2)
                resize2fs "$ROOT_DEV" 2>&1 | logger -t resize-disk || {
                    logger -t resize-disk "WARNING: resize2fs failed (may already be at max size)"
                }
                ;;
            xfs)
                xfs_growfs / 2>&1 | logger -t resize-disk || {
                    logger -t resize-disk "WARNING: xfs_growfs failed (may already be at max size)"
                }
                ;;
            *)
                logger -t resize-disk "WARNING: Unknown filesystem type $FSTYPE, skipping resize"
                ;;
        esac
    else
        logger -t resize-disk "No free space available in volume group, disk already at maximum size"
    fi
    
    logger -t resize-disk "Disk resize completed successfully"
    df -h / | logger -t resize-disk
    
else
    logger -t resize-disk "Root device $ROOT_DEV is not LVM, skipping resize"
fi

# Disable this service so it never runs again
systemctl disable resize-disk-once.service 2>/dev/null || true

exit 0

