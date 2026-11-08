# Live laboratory validation sign-off

Use an **authorised disposable Ubuntu VM**. Record the actual Ubuntu release, VM type,
non-root user, date, commit SHA and any differences from the manuscript. Keep the
validation report under `~/devops-lab/validation-reports/`; do not commit host-specific
logs, private keys, system configuration or credentials to this repository.

## Automated Ubuntu checkpoint runner

After following Chapter 7 to install and start NGINX, run **inside the Ubuntu VM**:

```bash
cd ~/linux-for-devops-engineers
bash tests/validate-files.sh
bash tests/validate-ubuntu-live.sh
```

The first script checks source files with mocks. The second performs real commands in an
**isolated temporary directory within `~/devops-lab`** and writes a permanent report.
It will stop at the first failed checkpoint. Review the failed command/requirement,
correct the cause, and rerun. It does not install packages or overwrite existing lab files.

To run the Chapter 11 deliberate service outage, after confirming this is an **unused
sandbox** with no workloads depending on NGINX, separately opt in:

```bash
bash tests/validate-ubuntu-live.sh --allow-service-stop
```

It asks for a hostname-specific confirmation, restarts NGINX after the drill, and
attempts emergency restart on exit. If the host loses power or sudo fails, manually
check `systemctl status nginx` and recover with `sudo systemctl start nginx`.

## Chapter-by-chapter sign-off

| Chapter | Core evidence in runner | Remaining manual review |
| --- | --- | --- |
| 1 — Operating context | OS, user, host, workspace | Confirm correct VM and `sudo` rights |
| 2 — Navigation | Absolute and home paths | Book's relative path examples |
| 3 — Files and archives | File, copy, tar and extract | Manual editor operations, exact book examples |
| 4 — Permissions | Owner-read failure and recovery | Check directory traversal and any ownership examples |
| 5 — Search | File search, example log | Remaining `find` / `grep` options from the book |
| 6 — Pipes and redirection | INFO count and stderr capture | Other pipeline and environment examples |
| 7 — Software and services | NGINX, service, RAM, disk | Install path for your Ubuntu release, process interpretation |
| 8 — Logs | Service journal query | Real journal/file log interpretation and privilege checks |
| 9 — Networking and SSH | IP, route, DNS, socket and HTTP | **SSH host identity, remote commands, scp, firewall checks** |
| 10 — Bash | Actual script, output, exit, permission fault | Optional scheduler example, review book code line-by-line |
| 11 — Troubleshooting | Opt-in stop/restart and recovery | Document the evidence and conclusion independently |

Check the live-runner report and manually complete the remaining items before declaring
all manuscript labs validated. The Ubuntu run does **not** establish RHEL/Fedora
compatibility; run the relevant `dnf` and service-path checks in a second disposable VM
if cross-distribution validation is needed.

**Release evidence:** date / Ubuntu version / repository commit / checklist reviewer / report path.
