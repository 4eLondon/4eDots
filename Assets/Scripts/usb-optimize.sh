#!/bin/bash

set -e

if [[ "$EUID" -ne 0 ]]; then
    echo "Run as root: sudo bash usb-optimize.sh"
    exit 1
fi

echo "==> Disabling USB autosuspend..."
echo 'options usbcore autosuspend=-1' > /etc/modprobe.d/usb.conf

echo "==> Lowering dirty page writeback ratios..."
cat > /etc/sysctl.d/99-usb-transfers.conf << EOF
vm.dirty_ratio = 5
vm.dirty_background_ratio = 2
EOF

echo "==> Applying sysctl settings for current session..."
sysctl -p /etc/sysctl.d/99-usb-transfers.conf

echo "==> Applying autosuspend for current session..."
echo -1 > /sys/module/usbcore/parameters/autosuspend

echo "Done. Changes are permanent and active now."
