# Chapter 1 — Establish Your Linux Operating Context

**Goal:** identify the distribution, user, host and working directory before changing anything. Work **inside your authorised Linux VM**; use the normal terminal, not an EC2 shell or macOS shell unless that is your deliberate lab context.

## Before you begin

Read [setup and prerequisites](../../docs/SETUP.md). You need a disposable Linux environment with Bash and standard core utilities. Do not use a production system.

## Run and observe

```bash
cat /etc/os-release
whoami
hostname
pwd
ls ~
```

Answer: which host and identity receive your commands? Your output will not necessarily match a sample. If `~/devops-lab` is absent, create it **only after checking your home directory**:

```bash
mkdir ~/devops-lab
ls -ld ~/devops-lab
```

If it already exists, inspect it and keep its contents. Do not overwrite or delete earlier work.

## Verify

```bash
cd ~/devops-lab
pwd
```

The path should end in `/devops-lab`. You should be able to state your distribution, identity, host and location.

## Common failure

`Permission denied` creating the lab? Inspect `whoami`, `pwd` and your home-directory permissions. Do not fix a home-directory problem by recursively changing ownership or using indiscriminate `sudo`.

**Continue:** [Chapter 2 — filesystem paths](../chapter-02-filesystem-navigation/README.md).
