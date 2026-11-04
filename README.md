# Linux for DevOps Engineers

**Official companion repository for _Linux for DevOps Engineers: Operate, Automate and Troubleshoot Linux Systems with Evidence_ by Victor Ebai.**

## Build the Linux skills that DevOps work actually requires

When an application stops responding, a deployment script fails, or a service behaves differently on another server, knowing a few Linux commands is not enough. You need to establish **which system and identity you are using**, understand the state of the filesystem and services, find relevant evidence, make a controlled change and verify that the original requirement now works.

_Linux for DevOps Engineers_ develops that capability through practical, cumulative exercises. Instead of memorising hundreds of commands, you learn **how to choose the right evidence**, interpret it and use it to make safer operational decisions. You'll progress from terminal orientation and file permissions to service administration, logs, network checks, Bash automation and recovery from real failures.

**By the end, you'll be able to:**

- Navigate and operate Linux filesystems with confidence, including ownership and permissions.
- Investigate running processes, NGINX services, memory, storage, logs and network endpoints.
- Combine commands and capture diagnostic output without losing important error evidence.
- Turn a manually verified operational procedure into a repeatable Bash check.
- Diagnose controlled failures by locating the first abnormal boundary and verifying recovery.

The book builds two complementary habits:

**Learning journey:** ORIENT → INSPECT → ACT → VERIFY → AUTOMATE → DIAGNOSE

**Operating habit:** ORIENT → ACT → OBSERVE → VERIFY → RECOVER

### About this companion repository

The book contains the explanations, mental models and practical exercises. This repository makes practice easier with a **ready-to-use NGINX verification script**, small sample data files, a chapter-by-chapter lab path, setup guidance, troubleshooting references and safe cleanup instructions. The book is self-contained; using the repository is optional.

**Looking for the complete learning path?** Read _Linux for DevOps Engineers: Operate, Automate and Troubleshoot Linux Systems with Evidence_ by Victor Ebai. The book explains the decisions behind each command and how to transfer the method to real DevOps work.

## Start here

**Use a disposable Linux VM or sandbox**, not your MacBook's macOS shell for the Linux service-management labs. A recent Ubuntu/Debian or RHEL-family distribution with `systemd`, `sudo` access and functioning package repositories is recommended.

1. Read [setup and prerequisites](docs/SETUP.md) and check which Linux host you're controlling.
2. Obtain the files **inside your Linux VM**:

   ```bash
   git clone https://github.com/vebai/linux-for-devops-engineers.git
   cd linux-for-devops-engineers
   ```

   If Git is not installed, obtain the repository as an archive and extract it into your Linux home directory.
3. Begin [Chapter 1](chapters/chapter-01-operating-context/README.md), establishing your user, host, distribution and `~/devops-lab/` workspace.
4. Complete the chapters in order, preserving `~/devops-lab/` as the continuous practical workspace.
5. Use the ready-to-use files only when the chapter calls for them. For example, Chapter 10 provides `scripts/verify-nginx.sh` to copy into `~/devops-lab/scripts/`.
6. Use [troubleshooting](docs/TROUBLESHOOTING.md) when something differs from the expected state, then follow [cleanup](docs/CLEANUP.md) when finished.

**Two directories have different purposes:** this cloned repository stores the example files; **`~/devops-lab/` is the workspace you modify** while completing the exercises. Run chapter commands from the Linux VM unless a guide explicitly says otherwise.

## Chapter guide

| Chapter | What you'll practise |
|---|---|
| [1 — Operating context](chapters/chapter-01-operating-context/README.md) | Identify distribution, user, host and location; create the workspace |
| [2 — Filesystem navigation](chapters/chapter-02-filesystem-navigation/README.md) | Understand paths and navigate deliberately |
| [3 — File management](chapters/chapter-03-files-and-archives/README.md) | Create, edit, preserve and archive configuration |
| [4 — Permissions](chapters/chapter-04-identity-and-permissions/README.md) | Diagnose and repair one controlled access failure |
| [5 — Search and text](chapters/chapter-05-search-and-text/README.md) | Find configuration and inspect a sample operational log |
| [6 — Pipes and redirection](chapters/chapter-06-pipes-and-redirection/README.md) | Combine commands; capture both results and diagnostics |
| [7 — Processes and services](chapters/chapter-07-processes-and-services/README.md) | Inspect or install NGINX; observe service and resource state |
| [8 — Logs and evidence](chapters/chapter-08-logs-and-evidence/README.md) | Inspect journal records and distinguish evidence from hypothesis |
| [9 — Networking and SSH](chapters/chapter-09-networking-and-ssh/README.md) | Trace the local HTTP path and learn safe remote checks |
| [10 — Bash automation](chapters/chapter-10-bash-automation/README.md) | Run and understand the verified four-check Bash script |
| [11 — Troubleshooting](chapters/chapter-11-evidence-first-troubleshooting/README.md) | Break NGINX deliberately, diagnose, recover and prove success |

## Practical files

```text
linux-for-devops-engineers/
├── README.md
├── chapters/                 # 11 reader-focused lab guides
├── docs/                     # setup, troubleshooting, cleanup, command reference
├── examples/
│   ├── app.conf              # environment=lab
│   └── app.log               # sample text evidence for Chapter 5
├── scripts/
│   └── verify-nginx.sh       # Chapter 10 application/service verification
├── tests/                    # non-destructive static and simulated checks
└── publish-to-github.sh      # optional one-time repository publishing
```

The sample `app.log` is **fabricated lab data**, not NGINX or production incident evidence.

## Verify the repository files

From the cloned repository directory, run:

```bash
bash tests/validate-files.sh
```

These checks verify Bash syntax, internal Markdown links and the verification script's behaviour against **mock** commands. They do not install packages, start or stop services, or assert that your Linux VM is correctly configured. For real system verification, use the commands in the appropriate chapter.

## Troubleshooting and safe stopping points

Inspect before destructive action; verify afterwards. Don't treat a running service, a listening port and an HTTP response as equivalent claims. A completed command is not necessarily evidence that the engineering requirement was satisfied.

- [Set up the Linux lab](docs/SETUP.md)
- [Troubleshoot from evidence](docs/TROUBLESHOOTING.md)
- [Linux command quick reference](docs/COMMAND-REFERENCE.md)
- [Evidence method](docs/EVIDENCE-METHOD.md)
- [Clean up safely](docs/CLEANUP.md)

This repository is designed for **authorised disposable learning environments**. Read commands before execution. Some exercises deliberately change permissions or stop NGINX; do not run those drills on production systems or shared servers.

## About the book

**_Linux for DevOps Engineers_ — Operate, Automate and Troubleshoot Linux Systems with Evidence**

**Author:** Victor Ebai

For a structured explanation of _why_ each Linux operation matters, the engineering decisions it supports, and the complete progression from first inspection to incident diagnosis, follow the book alongside these reusable lab files.
