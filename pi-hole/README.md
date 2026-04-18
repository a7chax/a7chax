# Pi-hole Docker Compose Guide

This guide explains how to start, configure, and use your Pi-hole instance using the provided `pihole-docker-compose.yml` file.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed.
- [Docker Compose](https://docs.docker.com/compose/install/) installed.

## Getting Started

1. **Configure the Environment:**
   Before starting the container, open `pihole-docker-compose.yml` and review the environment variables:
   - `TZ`: Set this to your local timezone (e.g., `America/Chicago`, `Europe/London`).
   - `FTLCONF_webserver_api_password`: Change `your_secure_password_here` to a strong, secure password. You will use this to log into the Pi-hole web interface.

2. **Start Pi-hole:**
   Open your terminal, navigate to the directory containing the file, and run:
   ```bash
   docker compose -f pihole-docker-compose.yml up -d
   ```
   This will download the official Pi-hole image and start it in the background.

3. **Access the Web Interface:**
   Once the container is running, open your web browser and go to:
   - `http://localhost/admin` (if running locally) or `http://<your-server-ip>/admin`
   - Log in using the password you set in the `FTLCONF_webserver_api_password` variable.

## Setting Up Your Devices to Use Pi-hole

To start blocking ads, you need to point your devices' DNS settings to your Pi-hole's IP address. 

- **Router Level (Recommended):** Log into your router's administration page and change the primary DNS server to the IP address of the machine running this Docker container. This will instantly provide ad-blocking to all devices on your network.
- **Device Level:** If you only want specific devices to use Pi-hole, go to the network/Wi-Fi settings of that device and change the DNS server manually to the Pi-hole's IP address.

## Managing the Container

- **View Logs:**
  ```bash
  docker compose -f pihole-docker-compose.yml logs -f
  ```
- **Stop Pi-hole:**
  ```bash
  docker compose -f pihole-docker-compose.yml down
  ```
- **Update Pi-hole:**
  To pull the latest official Pi-hole image and restart the container:
  ```bash
  docker compose -f pihole-docker-compose.yml pull
  docker compose -f pihole-docker-compose.yml up -d
  ```

## Advanced Settings (DHCP)
If you want to use Pi-hole as your DHCP server instead of your router:
1. Edit the `pihole-docker-compose.yml` file and uncomment the `67:67/udp` port mapping. 
2. Restart the container (`docker compose -f pihole-docker-compose.yml up -d`).
3. Make sure to **disable** the DHCP server on your router to avoid conflicts.
