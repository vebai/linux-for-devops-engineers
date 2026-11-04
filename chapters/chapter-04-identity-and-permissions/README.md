# Chapter 4 — Control Access with Identity, Ownership and Permissions

**Goal:** establish **who** is performing an operation and **which permission** permits or prevents it. The controlled failure modifies only a file you own in the disposable lab.

## Before you begin

Your `~/devops-lab/config/app.conf` should exist with `environment=lab`. Confirm it is a file you own and that it currently has owner-read permission.

## Observe before changing

```bash
cd ~/devops-lab
whoami
id
ls -ld config
ls -l config/app.conf
cat config/app.conf
```

## Controlled failure — optional but recommended in your sandbox

If the file is owned by you and reads successfully, remove the **owner's** read bit:

```bash
chmod u-r config/app.conf
ls -l config/app.conf
cat config/app.conf
```

A read failure is expected for the owner in the ordinary Unix permission model. If your session is root or the file is not owned by you, **do not run this drill** until you have the correct sandbox context.

## Diagnose, fix and verify

Inspect the file metadata and your identity. Restore **only** the removed permission:

```bash
chmod u+r config/app.conf
ls -l config/app.conf
cat config/app.conf
```

Expected: the file is readable again and contains `environment=lab`. Do not use `chmod 777` or blindly add `sudo` to make errors disappear.

**Continue:** [Chapter 5 — search and text](../chapter-05-search-and-text/README.md).
