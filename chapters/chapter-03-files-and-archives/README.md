# Chapter 3 — Create and Manage Files Safely

**Goal:** build the persistent configuration and working directories used in later exercises, then practise safe copying and archiving.

## Before you begin

Complete Chapters 1–2 and confirm that `~/devops-lab` exists. Run all commands **in your Linux VM**.

## Build

```bash
cd ~/devops-lab
pwd
mkdir -p config logs scripts
ls
```

If `config/app.conf` already contains your work, inspect it instead of replacing it. Otherwise, edit it with `nano config/app.conf` and enter:

```ini
environment=lab
```

A matching example is available at [`examples/app.conf`](../../examples/app.conf), but writing it yourself is useful practice.

## Verify and preserve

```bash
cat config/app.conf
cp config/app.conf config/app.conf.backup
cat config/app.conf.backup
tar -czf config-backup.tar.gz config
tar -tf config-backup.tar.gz
```

You should see `environment=lab` in the file and `config/app.conf` among archive entries. A completed `tar` command alone does not prove the required content was archived.

For a controlled extraction drill, create a separate empty directory:

```bash
mkdir -p archive-test
tar -xf config-backup.tar.gz -C archive-test
cat archive-test/config/app.conf
```

Review the archive contents before extraction; never extract unknown archives into sensitive directories.

## Cleanup boundary

Keep `config/app.conf`, `logs/` and `scripts/` for the next chapters. Remove only selected temporary archive/test files after inspecting them; refer to [safe cleanup](../../docs/CLEANUP.md). The later chapters assume the configuration remains.

**Continue:** [Chapter 4 — identity and permissions](../chapter-04-identity-and-permissions/README.md).
