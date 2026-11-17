# Create a Linux Lab on Your Computer

Set up a disposable Ubuntu environment on your own computer using **VirtualBox**, **VMware Workstation/Fusion**, or **Windows Subsystem for Linux (WSL 2)**.

For the most isolated learning environment, choose a VM in VirtualBox or VMware. WSL 2 is a convenient Windows alternative, but it is integrated with your Windows system: keep experiments inside your Linux home directory and do not assume WSL protects Windows files from changes.

## Before you begin

- Use a computer with enough free memory and disk space. A practical Ubuntu VM starting point is **2 virtual CPUs, 4 GB RAM and 30 GB virtual disk**, subject to what your host can spare.
- Use **Ubuntu Desktop LTS** for the graphical VM instructions. Download its installation ISO from [Ubuntu Desktop](https://ubuntu.com/download/desktop).
- Make sure the ISO matches your computer's architecture: **x86-64/amd64** for an Intel/AMD host or **arm64** for an Apple Silicon VM.
- Use an account you own or are authorised to administer. Do not run deliberate service-failure labs on production systems.

Choose **one** path below.

## Option A — VirtualBox (Windows, Linux, or compatible macOS hosts)

1. Download and install [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your host operating system. Check its supported host and guest architectures before proceeding.
2. Download an Ubuntu Desktop LTS ISO from the link above.
3. Open VirtualBox and select **New**.
4. Name the VM `linux-devops-lab`, select Linux/Ubuntu as the guest operating system, and choose the ISO.
5. **Choose an interactive installation** (skip the unattended install option if shown), so you can create and check your own Ubuntu user account.
6. Assign approximately **2 CPUs, 4 GB RAM and 30 GB** of virtual disk, or adjust for your computer.
7. Leave networking in **NAT** mode for basic package downloads; you do not need to expose a server to your local network.
8. Start the VM, select **Install Ubuntu**, and follow the installation screens. Install to the **VM's virtual disk**, not your host computer's physical disk.
9. When prompted for an account, create a normal Linux username such as `labuser` and a strong password. Use the normal installer-created administrator account so you can run `sudo`.
10. Restart into the installed Ubuntu system, remove the installation ISO if prompted, and sign in as your new user.
11. Open **Terminal** and complete [Verify your Linux account and tools](#verify-your-linux-account-and-tools).
12. Once setup works, take a **VM snapshot** so you can restore your sandbox if a later exercise goes wrong.

Ubuntu also provides an [illustrated VirtualBox guide](https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox).

## Option B — VMware Workstation or VMware Fusion

Use **VMware Workstation** on Windows/Linux or **VMware Fusion** on macOS.

1. Download the appropriate edition from the [VMware desktop hypervisor page](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion). Downloads may require a Broadcom account.
2. Download an Ubuntu Desktop LTS installation ISO.
3. For **Apple Silicon Macs**, use an **Ubuntu ARM64 ISO**, not the x86-64 ISO. VMware Fusion on Apple Silicon runs ARM guest operating systems.
4. Open VMware and select **Create a New Virtual Machine** (Workstation) or **File → New** (Fusion).
5. Choose the option to install an operating system **from an ISO/disc image**, then select your Ubuntu ISO.
6. Name the VM `linux-devops-lab` and allocate around **2 CPUs, 4 GB RAM and 30 GB** virtual disk.
7. Use **NAT** networking. Choose the manual installation route if you want to control creation of the Linux account.
8. Start the VM and follow **Install Ubuntu**. When prompted, create a normal user such as `labuser` with a strong password and administrator/`sudo` access.
9. Reboot into Ubuntu and sign in as the new user.
10. Open Terminal and complete [Verify your Linux account and tools](#verify-your-linux-account-and-tools).
11. Create a **snapshot** before starting exercises that change services, permissions or networking.

See the [official VMware download guidance](https://knowledge.broadcom.com/external/article/368667/download-and-license-vmware-desktop-hyper.html) if installation or downloads differ from these screens.

## Option C — Windows Subsystem for Linux (WSL 2)

WSL 2 lets you run an Ubuntu Linux terminal on Windows without installing a separate desktop VM.

1. On Windows 11, or a supported Windows 10 release, open **PowerShell as Administrator**.
2. Install WSL and Ubuntu:

   ```powershell
   wsl --install -d Ubuntu
   ```

3. Restart Windows if prompted.
4. Open **Ubuntu** from the Start menu. On first launch, create a **Linux username** such as `labuser` and a strong Linux password. This is separate from your Windows account. Ubuntu's initial WSL user normally has `sudo` access.
5. Verify that your distribution uses WSL 2. Run this in **PowerShell**:

   ```powershell
   wsl --list --verbose
   ```

   The Ubuntu entry should show version **2**. If it shows version 1, use `wsl --set-version Ubuntu 2` in PowerShell (using the exact distro name reported by the list).
6. In the **Ubuntu terminal**, run the checks below.
7. The later NGINX labs need `systemd`. Check:

   ```bash
   ps -p 1 -o comm=
   ```

   Expected: `systemd`. If it is not shown, update WSL from PowerShell with `wsl --update`. In Ubuntu, edit `/etc/wsl.conf` with `sudo nano /etc/wsl.conf` and add the following under its `[boot]` section, preserving any existing settings:

   ```ini
   [boot]
   systemd=true
   ```

   Then run `wsl --shutdown` in **PowerShell**, reopen Ubuntu, and repeat the PID 1 check.
8. Keep the exercises under `~/devops-lab` in the Linux filesystem, not in `/mnt/c`. WSL can access Windows files, so do not treat it as a security boundary.

For additional details, see [Microsoft's WSL installation guide](https://learn.microsoft.com/en-us/windows/wsl/install) and [systemd guidance](https://learn.microsoft.com/en-us/windows/wsl/systemd).

## Verify your Linux account and tools

Run these commands in the **Ubuntu terminal**, regardless of which option you chose:

```bash
cat /etc/os-release
whoami
hostname
id -nG
sudo -v
sudo whoami
ps -p 1 -o comm=
```

Check that:
- The distribution is Ubuntu.
- `whoami` shows your **normal Linux user**, not `root`.
- `sudo whoami` prints **root** (proving that you can perform authorised administrative commands).
- PID 1 is **systemd**, which is needed for the service exercises.

If your existing VM account lacks administrator privileges, use an **existing authorised administrator** to grant them. On Ubuntu, that administrator can create a separate lab account:

```bash
sudo adduser labuser
sudo usermod -aG sudo labuser
```

Sign out and back in as `labuser`, then repeat `sudo whoami`. Do not try to bypass restrictions on a system you do not administer.

Now install Git and curl:

```bash
sudo apt update
sudo apt install -y git curl python3
git --version
curl --version
python3 --version
```

Do **not** install NGINX yet if following the book in order; Chapter 7 introduces it.

## Get the companion repository

In the **Linux terminal**:

```bash
cd ~
git clone https://github.com/vebai/linux-for-devops-engineers.git
cd linux-for-devops-engineers
bash tests/validate-files.sh
```

Your clone is a reference for instructions and example files. The separate `~/devops-lab` workspace will be created in Chapter 1.

**Next:** [Start Chapter 1 — Establish Your Linux Operating Context](../../chapters/chapter-01-operating-context/README.md).
