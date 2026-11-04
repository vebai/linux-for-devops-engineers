# Chapter 8 — Logs and Operational Evidence

**Goal:** inspect service records and distinguish observation from explanation. Start with a question, not a preferred log path.

## Before you begin

NGINX should be installed from Chapter 7. Work in the same Linux VM. A live log may be empty or stored differently depending on distribution and configuration.

## Compare current and recorded state

```bash
hostname
systemctl status nginx
journalctl -u nginx -n 20
```

If your identity cannot read the journal, follow your lab's access policy. Use `sudo journalctl -u nginx -n 20` only where authorised.

## Observe the application without inventing an incident

```bash
curl --fail --silent --show-error http://localhost
systemctl is-active nginx
```

Compare the current service status with recent records. If NGINX writes to file-based logs on your host, inspect the actual configured paths before reading them; do not assume every distribution writes the same file.

## Record a bounded conclusion

- What requirement was tested?
- What did the command actually return?
- What does that result establish, and which questions remain unanswered?

A service can be active while the HTTP request fails. A missing journal record does not prove an event never happened.

**Continue:** [Chapter 9 — networking](../chapter-09-networking-and-ssh/README.md).
