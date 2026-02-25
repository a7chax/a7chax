# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Ubuntu 22.04 LTS (Jammy Jellyfish)
  config.vm.box = "ubuntu/jammy64"

  # VM hostname
  config.vm.hostname = "openclaw-vm"
  # Network configuration
  # Forward common web ports for OpenClaw
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
  config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
  config.vm.network "forwarded_port", guest: 8000, host: 8000, auto_correct: true
  config.vm.network "forwarded_port", guest: 18789, host: 18789, auto_correct: true

  # Private network for easier access
  config.vm.network "private_network", ip: "192.168.56.10"
  # Synced folder - share current directory with VM
  config.vm.synced_folder ".", "/vagrant", disabled: false
  # VirtualBox provider configuration
  config.vm.provider "virtualbox" do |vb|
    vb.name = "openclaw-vm"
    vb.memory = "4096"
    vb.cpus = 4

    # Enable GUI if needed (set to true for desktop)
    vb.gui = false

    # Performance optimizations
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  # Provisioning script - basic setup
  config.vm.provision "shell", inline: <<-SHELL
    # Update system
    apt-get update
    apt-get upgrade -y

    # Install common dependencies
    apt-get install -y \
      build-essential \
      curl \
      wget \
      git \
      vim \
      htop \
      unzip \
      software-properties-common \
      apt-transport-https \
      ca-certificates \
      gnupg \
      lsb-release
    # Install Docker (commonly needed for OpenClaw)
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker vagrant

    # Install Docker Compose
    apt-get install -y docker-compose-plugin

    # Install Node.js 22.x (OpenClaw requires Node >= 22)
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs

    # Install Python 3 and pip
    apt-get install -y python3 python3-pip python3-venv

    # ============================================
    # Install and configure OpenClaw
    # ============================================

    # Install OpenClaw globally
    npm install -g openclaw@latest

    # Create OpenClaw config directory for vagrant user
    mkdir -p /home/vagrant/.openclaw

    # Configure OpenClaw to bind on all interfaces so the
    # dashboard is reachable from the host via port forwarding
    cat > /home/vagrant/.openclaw/openclaw.json << 'EOF'
{
  "gateway": {
    "bind": "all",
    "port": 18789
  }
}
EOF
    chown -R vagrant:vagrant /home/vagrant/.openclaw

    # Create a systemd service so the gateway starts automatically on boot
    cat > /etc/systemd/system/openclaw.service << 'EOF'
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
Type=simple
User=vagrant
ExecStart=/usr/bin/openclaw gateway --port 18789 --bind all
Restart=always
RestartSec=5
Environment=HOME=/home/vagrant

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable openclaw
    systemctl start openclaw

    echo ""
    echo "============================================"
    echo "VM provisioning complete!"
    echo "============================================"
    echo "Access VM:        vagrant ssh"
    echo "Private IP:       192.168.56.10"
    echo "Ports forwarded:  80->8080, 443->8443, 3000, 8000"
    echo "--------------------------------------------"
    echo "OpenClaw dashboard: http://localhost:18789"
    echo "  or via private IP: http://192.168.56.10:18789"
    echo "Check gateway status: systemctl status openclaw"
    echo "View logs:            journalctl -u openclaw -f"
    echo "============================================"
  SHELL
end
