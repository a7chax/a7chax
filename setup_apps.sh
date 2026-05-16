#!/bin/bash

# Setup script for a new laptop
# Installs: VS Code Insiders, Cursor, Bruno, Burp Suite, Zotero, Firefox Nightly

set -e

echo "Starting software installation..."

# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install Firefox Nightly (Official Mozilla Repo)
echo "Installing Firefox Nightly..."
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo -e "Types: deb\nURIs: https://packages.mozilla.org/apt\nSuites: mozilla\nComponents: main\nSigned-By: /etc/apt/keyrings/packages.mozilla.org.asc" | sudo tee /etc/apt/sources.list.d/mozilla.sources
echo -e "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla
sudo apt update && sudo apt install -y firefox-nightly

# 3. Install VS Code Insiders (Microsoft Repo)
echo "Installing VS Code Insiders..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update && sudo apt install -y code-insiders

# 4. Install Cursor
echo "Installing Cursor..."
# Note: Assuming the repo was added during the previous local .deb install. 
# For a fresh install, we'd typically download the .deb or use their repo if available.
# Since we have the repo setup from the .deb install, we try apt.
sudo apt install -y cursor || echo "Cursor repo not found, please download .deb manually."

# 5. Install Bruno
echo "Installing Bruno..."
BRUNO_VERSION="3.3.0"
wget https://github.com/usebruno/bruno/releases/download/v${BRUNO_VERSION}/bruno_${BRUNO_VERSION}_amd64_linux.deb -O /tmp/bruno.deb
sudo apt install -y /tmp/bruno.deb
rm /tmp/bruno.deb

# 6. Install Zotero
echo "Installing Zotero..."
mkdir -p ~/Downloads
wget -O /tmp/Zotero.tar.xz "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64"
mkdir -p ~/Apps/Zotero
tar -xvf /tmp/Zotero.tar.xz -C ~/Apps/Zotero --strip-components=1
cd ~/Apps/Zotero
./set_launcher_icon
mkdir -p ~/.local/share/applications
ln -sf ~/Apps/Zotero/zotero.desktop ~/.local/share/applications/
rm /tmp/Zotero.tar.xz

# 7. Burp Suite Community
echo "Downloading Burp Suite Community Installer..."
# Note: Version numbers change frequently.
BURP_URL="https://portswigger.net/burp/releases/download?product=community&version=2024.3.3&type=Linux"
wget "$BURP_URL" -O /tmp/burp_installer.sh
chmod +x /tmp/burp_installer.sh
echo "Run: sudo /tmp/burp_installer.sh to finish Burp installation."

echo "Installation script completed!"
