<p align="right">
  **English 🇬🇧** | <a href="README.es.md">Español 🇪🇸</a>
</p>

# BlackOpsDocker

Repository with multiple Docker services organized in separate folders, each containing its own `docker-compose.yml`.

To ease management, it includes the `blackopsdocker` script that lets you control all services at once with a single command, from anywhere in your system.

---

## Project Structure

```
.
├── akuma/
│   └── docker-compose.yml
├── blackopsdocker_manager.sh
├── blackopsdocker.sh
├── ftp-server/
│   └── docker-compose.yml
├── glances/
│   └── docker-compose.yml
├── jaeger/
│   ├── docker-compose.yml
│   └── nginx.conf
├── portainer/
│   └── docker-compose.yml
├── prometheus/
│   ├── docker-compose.yml
│   └── prometheus.yml
├── README.md
├── traefik/
│   ├── acme.json
│   ├── docker-compose.yml
│   ├── dynamic_conf.yml
│   ├── fullchain.pem
│   ├── logs/
│   └── traefik.yml
├── .env.example
└── .env (NOT versioned)
```

---

## Environment Variables Configuration

The `.env` file **is not versioned** for security reasons. To configure your environment:

1. Copy the example file:

```bash
cp .env.example .env
```

2. Edit `.env` with your real values (IPs, users, passwords, paths, etc.):

```bash
nano .env
```

Save and close.

---

## Using the `blackopsdocker` Script

The `blackopsdocker` script lets you manage all Docker services defined in the project folders in a unified way. You can:

* Start all services with `blackopsdocker up`
* Stop all services with `blackopsdocker down`
* Restart all services with `blackopsdocker restart`
* View combined logs with `blackopsdocker logs`
* Clean volumes with `blackopsdocker prune volumes`
* And other useful commands

The script automatically detects the project root from any location.

---

## Installing the `blackopsdocker` Command

To run the command from anywhere, use the installer/uninstaller script:

### Installation steps

1. From the project root, make the manager script executable:

```bash
chmod +x blackopsdocker_manager.sh
```

2. Run the installer:

```bash
./blackopsdocker_manager.sh install
```

This copies `blackopsdocker.sh` to `/usr/local/bin/blackopsdocker` and makes it executable.

3. Verify the installation:

```bash
which blackopsdocker
# Should output /usr/local/bin/blackopsdocker
```

---

## Uninstallation

To remove the command:

```bash
./blackopsdocker_manager.sh uninstall
```

---

## Recommendations

* Make sure Docker and Docker Compose are installed.
* Always create and configure your `.env` file before using the script.
* The script works from any folder, auto-detecting the project root.
* Check help with `blackopsdocker help` for available commands.

---

## License

MIT License

---

Thank you for using BlackOpsDocker! 🚀

---
