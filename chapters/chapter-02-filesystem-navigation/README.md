# Chapter 2 — Navigate and Understand the Linux Filesystem

**Goal:** understand how the same relative path changes meaning with your current location.

## Before you begin

[Chapter 1](../chapter-01-operating-context/README.md) should have created `~/devops-lab`. Use a disposable Linux VM.

## Run and observe

```bash
cd ~
pwd
ls -a
cd devops-lab
pwd
cd ..
pwd
cd /etc
pwd
cd ~/devops-lab
pwd
```

Compare paths that start at `/` (absolute), `~` (home-relative) and a directory name (working-directory-relative). Do not modify files inside `/etc`.

## Verify

Your final `pwd` should identify `~/devops-lab`. Explain why `cd devops-lab` from your home directory may work while the same command from `/tmp` identifies a different target.

## Troubleshoot

If `cd devops-lab` fails, inspect `pwd` and `ls` before changing the path. A missing directory is not a reason to run a destructive command.

**Continue:** [Chapter 3 — safe file management](../chapter-03-files-and-archives/README.md).
