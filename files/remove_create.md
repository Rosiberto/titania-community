## Container Management Guide

This section explains how to remove, create, and manage the project containers using Docker Compose or the automated installation script.

---

### Prerequisites

Make sure you have the following installed on your system:

- Docker
- Docker Compose
- Bash (for running the install script)

---

### Step 1: Navigate to the project directory

```bash
cd titania-community
```


Step 2: Remove containers

This command stops and removes all running containers:

```bash
sudo docker compose down
```


Step 3: Create / Start containers

This command builds (if needed) and starts the containers in detached mode:

```bash
sudo docker compose up -d
```


Alternative: Automatic installation

You can also use the provided script to automate the setup:

```bash
./install.sh
```