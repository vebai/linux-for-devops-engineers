# Set up your Linux learning environment

## Before you begin

Choose a **disposable Linux virtual machine or sandbox** that you are authorised to administer. For the smoothest progression, use a recent **Ubuntu/Debian** or **RHEL/Fedora-family** Linux system with `systemd`, `sudo`, networking and access to its package repositories.

MacBook users can run a Linux VM and open its Linux terminal. The book's `systemctl`, `journalctl`, `/etc`, `ip` and `ss` examples are **Linux** operations, not native macOS terminal operations. Windows users can use a full Linux VM; WSL installations without `systemd` service management may not match the NGINX labs.

**Never run the deliberate service failure exercises on a production machine.**

If you do not already have a Linux environment, first follow [Create a Linux lab with VirtualBox, VMware or WSL 2](linux-lab-setup/README.md). It includes user creation, sudo verification and service-manager checks.

## 1. Identify your distribution and user

Run **in the Linux VM**:

```bash
cat /etc/os-release
whoami
hostname
pwd
```

Confirm that you recognise the host and are using the intended non-root learning account. Verify that this account has the `sudo` permissions needed for package installation and service management; do not attempt to bypass missing permissions.

## 2. Install optional prerequisites

The core exercises use standard Linux command-line tools. For repository access, you may need Git.

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install -y git curl
```

**Fedora/RHEL family:**

```bash
sudo dnf install -y git curl
```

Verify:

```bash
git --version
curl --version
```

Do not install NGINX yet if you're following the book in order. Chapter 7 first checks for the software and then installs it only when needed.

## 3. Get the example files

```bash
cd ~
git clone https://github.com/vebai/linux-for-devops-engineers.git
cd linux-for-devops-engineers
```

The cloned repository is a **reference directory**. Your hands-on changes belong in `~/devops-lab`, which you establish in Chapter 1. The two directories should not be confused.

Verify that the files are readable:

```bash
ls
bash tests/validate-files.sh
```

This tests repository contents, not your host's service state.

## 4. Create the continuous lab at the correct time

[Chapter 1](../chapters/chapter-01-operating-context/README.md) introduces and creates `~/devops-lab`. Chapter 3 adds `config/`, `logs/` and `scripts/`; later chapters reuse these files. Avoid starting in the middle unless the required state from earlier chapters already exists.

## 5. Distinguish commands from output

Examples show only the command text inside code blocks. If the book shows `$` before a command, **do not type `$`**. Values such as your hostname, username, process IDs and installed versions will vary. Verify the property the exercise asks you to establish, not an exact sample string.

## 6. Lab readiness checklist

- Correct Linux host and account selected.
- Non-production environment with authorised `sudo` access.
- Familiar with `pwd`, `whoami`, `hostname` and `cat /etc/os-release`.
- Git installed if cloning the repository.
- NGINX exercises reserved for a disposable environment.

Continue to [Chapter 1](../chapters/chapter-01-operating-context/README.md).
