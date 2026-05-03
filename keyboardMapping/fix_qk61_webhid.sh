#!/usr/bin/env bash

echo "Setting up udev rules for CIDOO QK61..."
sudo tee /etc/udev/rules.d/50-cidoo-qk61.rules >/dev/null <<'EOF'
KERNEL=="hidraw*", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3035", MODE="0664", GROUP="plugdev", TAG+="uaccess"
EOF

echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Adding user to plugdev group..."
sudo usermod -aG plugdev $USER

echo "Done! Please log out and log back in, then unplug and replug the keyboard."
