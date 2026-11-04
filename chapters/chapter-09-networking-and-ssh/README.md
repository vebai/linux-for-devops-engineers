# Chapter 9 — Essential Networking and Remote Linux Work

**Goal:** trace the communication path from a local endpoint to a service. The SSH path is optional and requires a **separate host you are authorised to access**.

## Before you begin

NGINX should be installed and running in your Linux sandbox. Be able to identify the host, identity and interface being inspected.

## Local networking evidence

```bash
hostname
ip -br addr
ip route
getent hosts localhost
ss -lnt
curl --fail --silent --show-error http://localhost
```

If `ip`, `ss` or `getent` is not installed, consult the package names for your distribution and obtain authorisation before installing missing tools.

Explain what each result supports: host address, routing context, name resolution, TCP listener and HTTP response. A successful local HTTP request does not prove that remote clients can reach the host.

## Optional authorised SSH practice

Only use an assigned remote test host with verified host identity and approved SSH access. Do not copy a private key into this repository or bypass host-key verification.

```bash
ssh user@host
```

Once connected, orient **again on the remote system**:

```bash
hostname
whoami
pwd
```

For a permitted file-transfer exercise, follow the book's `scp` workflow and verify the resulting file **on the destination host**. Replace `user@host` with your assigned remote identity; it is illustrative, not a runnable hostname.

**Continue:** [Chapter 10 — Bash automation](../chapter-10-bash-automation/README.md).
