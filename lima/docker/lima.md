# Docker Setup with Lima on macOS
This guide will walk you through setting up Docker using Lima on macOS. Lima is a lightweight virtual machine manager that allows you to run Linux virtual machines on macOS, making it an excellent choice for running Docker containers.

## Prerequisites
- A macOS machine
- Homebrew installed on your macOS machine
- Basic knowledge of terminal commands

## Step 1: Install Lima
First, you need to install Lima. Open your terminal and run the following command:
```bash
brew install lima
```
## Step 2: Install Docker CLI
Next, install the Docker CLI using Homebrew:
```bash
brew install docker
```
## Step 3: Create a Lima Instance
Create a new Lima instance with Docker support. You can use the following command to create a default Lima instance:
```bash
limactl start template://docker
```
This command will download the Docker template and create a new Lima instance configured to run Docker.

## Step 4: Configure Docker CLI to Use Lima
To use the Docker CLI with the Lima instance, you need to set the `DOCKER_HOST
` environment variable. You can do this by adding the following line to your shell configuration file (e.g., `.bashrc`, `.zshrc`):
```bash
docker context create lima-docker --docker "host=unix:///Users/hs094/.lima/docker/sock/docker.sock"
docker context use lima-docker
docker run hello-world
```
