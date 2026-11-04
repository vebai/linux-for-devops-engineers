# Chapter 10 — Automate Linux Operations with Bash

**Goal:** turn a verified manual NGINX check into repeatable evidence: command available → active service → listening port → successful local HTTP request.

## Before you begin

The persistent `~/devops-lab/` workspace must contain `scripts/` and `logs/`. NGINX should be installed and operating normally in your disposable Linux VM. Establish normal behaviour with `systemctl`, `ss` and `curl` before automating it.

## Copy the runnable Bash example

From the **cloned repository root**:

```bash
ls -l scripts/verify-nginx.sh
```

Check whether you already have a modified lab copy:

```bash
ls -l ~/devops-lab/scripts/verify-nginx.sh
```

If that file does **not** exist, install the provided example:

```bash
cp scripts/verify-nginx.sh ~/devops-lab/scripts/verify-nginx.sh
chmod u+x ~/devops-lab/scripts/verify-nginx.sh
```

If it exists, compare or preserve your version first; never overwrite unreviewed work.

## Check, run and inspect

```bash
cd ~/devops-lab
bash -n scripts/verify-nginx.sh
./scripts/verify-nginx.sh
status=$?
printf 'Exit status: %s\n' "$status"
```

Expected when all four checks succeed: four `PASS` lines, host name and exit status **0**. A non-zero status means at least one reported check failed; investigate the matching boundary.

## Preserve a report

```bash
./scripts/verify-nginx.sh > logs/nginx-verification.txt
status=$?
cat logs/nginx-verification.txt
printf 'Exit status: %s\n' "$status"
```

The saved report describes **one execution**, not the current state forever. Re-run when fresh evidence is required.

## Controlled script-permission failure

In the disposable VM, with a working script, remove only the owner's execute bit:

```bash
chmod u-x scripts/verify-nginx.sh
ls -l scripts/verify-nginx.sh
./scripts/verify-nginx.sh
```

The attempted direct execution should fail. Restore **only** the removed bit, then verify:

```bash
chmod u+x scripts/verify-nginx.sh
./scripts/verify-nginx.sh
```

This drill does not require stopping NGINX. It tests script execution permission, not application health.

**Continue:** [Chapter 11 — evidence-first troubleshooting](../chapter-11-evidence-first-troubleshooting/README.md).
