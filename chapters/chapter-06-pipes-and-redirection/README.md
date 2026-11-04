# Chapter 6 — Pipes, Redirection and the Linux Environment

**Goal:** use command pipelines to answer specific questions and keep standard output separate from diagnostics.

## Before you begin

Chapters 3 and 5 should have created `~/devops-lab/config/app.conf` and `logs/app.log`.

## Inspect and compose

```bash
cd ~/devops-lab
grep 'INFO' logs/app.log | wc -l
sort logs/app.log | uniq
```

The first pipeline counts matching lines in the supplied sample log. The second shows a distinct command-composition task; ask what its ordering changes before treating it as meaningful evidence.

## Capture a controlled diagnostic

Verify first that `config/missing.conf` does **not** exist:

```bash
find config -maxdepth 1 -name 'missing.conf'
```

If nothing is returned, capture the expected read failure:

```bash
cat config/missing.conf 2> logs/error.log
cat logs/error.log
```

This is an intentional failed command, not a repository error. The diagnostic file should contain a message explaining that the requested file could not be read. Keep it for inspection; do not redirect away relevant errors simply to silence them.

## Verify

```bash
printf '%s\n' "$PATH"
command -v grep
wc -l logs/error.log
```

Explain stdout versus stderr and which result confirms that the failure evidence was saved.

**Continue:** [Chapter 7 — processes and services](../chapter-07-processes-and-services/README.md).
