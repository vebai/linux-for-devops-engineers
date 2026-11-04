# Troubleshoot Linux from evidence

Start with a **requirement** (for example, a local HTTP request to `http://localhost` should succeed) and the observed symptom. Identify the first abnormal boundary, rather than guessing at a cause.

## Orient

```bash
hostname
whoami
pwd
cat /etc/os-release
```

## Choose evidence close to the symptom

| Question | Observation | What it does not prove |
|---|---|---|
| Does the software exist? | `command -v nginx` | That the service is running |
| Is the service active? | `systemctl is-active nginx` | That the application serves requests |
| Is TCP port 80 listening? | `ss -lnt` | That HTTP will succeed |
| Does local HTTP work? | `curl --fail --silent --show-error http://localhost` | That remote clients can reach it |
| What does the service report? | `systemctl status nginx` | The complete history of the incident |
| What recent service records exist? | `journalctl -u nginx -n 20` | That every application failure was logged |

On some systems, journal access requires additional authorisation. Use `sudo journalctl -u nginx -n 20` only when appropriate for your lab identity and permissions.

## Make a bounded decision

1. State the expected behaviour.
2. Record what you observed.
3. Locate the first abnormal boundary supported by evidence.
4. Form a testable explanation; do not confuse hypothesis with observation.
5. Apply the **smallest authorised correction**.
6. Repeat the original failing test and save useful evidence.

### Common lab problems

**`Permission denied` on a lab configuration file:** inspect `whoami`, `ls -l config/app.conf` and the directory's permissions. Do not use `sudo` or `chmod 777` as an indiscriminate fix.

**`systemctl` cannot access the service manager:** check that you are on your intended systemd-enabled Linux VM, not macOS or a container/WSL environment without an active systemd service manager.

**NGINX active, but `curl` fails:** inspect `ss -lnt`, then the local HTTP response and service status. The service may have started without meeting your request-level requirement.

**The Bash check exits non-zero:** read every PASS/FAIL line, run `echo $?` immediately after execution, then inspect only the failed boundary with the corresponding interactive command.

**`journalctl` returns no matching records:** this is limited evidence, not proof that no failure happened. Check the current service state, time boundary and where this distribution records the relevant evidence.

Continue to [Chapter 11](../chapters/chapter-11-evidence-first-troubleshooting/README.md) for the controlled stop/restore drill.
