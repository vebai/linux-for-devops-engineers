# Chapter 7 — Software, Processes, Services and System Resources

**Goal:** verify the software you need, establish a service's current state and inspect system resources. State-changing commands are restricted to your **disposable VM**.

## Before you begin

Use a Linux system with `systemd`, package repositories and authorised `sudo` access. Check you're on the expected machine before installing software.

## Inspect NGINX before installing

```bash
hostname
whoami
command -v nginx
```

If NGINX is missing, choose the installation command for **your distribution** (do not run both):

**Ubuntu/Debian**

```bash
sudo apt update
sudo apt install nginx
```

**Fedora/RHEL family**

```bash
sudo dnf install nginx
```

## Verify at separate boundaries

```bash
command -v nginx
nginx -v
systemctl status nginx
ps -ef
free -h
df -h
```

If NGINX is installed but inactive and your lab requires a running service, inspect the reason before deciding to start it. Only then, in the disposable VM, use `sudo systemctl start nginx` and re-check the status.

## Outcome

You should distinguish the evidence that a binary exists, a service is active and a process is visible. None alone establishes that HTTP requests succeed.

**Continue:** [Chapter 8 — service logs](../chapter-08-logs-and-evidence/README.md).
