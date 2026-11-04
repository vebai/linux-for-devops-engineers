# Chapter 5 — Search, Filter and Understand Text

**Goal:** reduce noisy information to relevant evidence using bounded filesystem searches and text inspection.

## Before you begin

You need `~/devops-lab/config/app.conf`. The repository includes a **fabricated practice log** at [`examples/app.log`](../../examples/app.log); it is not evidence from a live service.

## Prepare sample evidence

From the cloned repository root, copy the mock log only if you do not already have an `app.log` you wish to keep:

```bash
test ! -e "$HOME/devops-lab/logs/app.log" && \
  cp examples/app.log "$HOME/devops-lab/logs/app.log"
```

The command may do nothing if the file already exists; inspect that file before choosing whether to use the example.

## Run and inspect

```bash
cd ~/devops-lab
find config -maxdepth 2 -type f
find logs -maxdepth 1 -name 'app.log'
grep -n 'environment=lab' config/app.conf
grep -n 'WARNING' logs/app.log
head -n 3 logs/app.log
tail -n 3 logs/app.log
wc -l logs/app.log
```

Expected sample: one `WARNING retry requested` line and ten lines in the supplied log, unless you modified the data.

## Verification questions

- Which file contains the intended configuration value?
- Is `WARNING` present? Which line?
- What information does `wc -l` report, and what does it **not** prove about a service?

**Continue:** [Chapter 6 — compose commands](../chapter-06-pipes-and-redirection/README.md).
