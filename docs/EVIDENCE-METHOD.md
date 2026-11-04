# A practical evidence method

**Requirement → Expected behaviour → Evidence → Conclusion.**

For every important Linux task ask:

1. **What should happen?** Be specific enough to test it.
2. **What is happening?** Record the actual output or state.
3. **What does that prove?** State the supported conclusion and its boundary.
4. **What changes next?** Apply the smallest justified change and repeat the original check.

## Example: local NGINX response

- **Requirement:** A request to `http://localhost` succeeds.
- **Response test:** `curl --fail --silent --show-error http://localhost`.
- **Port check:** `ss -lnt` — checks whether a TCP listener exists.
- **Service check:** `systemctl is-active nginx` — checks the service manager's current active state.
- **Recorded evidence:** `journalctl -u nginx -n 20` — inspects recent available service records.

These observations answer different questions. A service may be active while the HTTP test still fails. Return to the original request after repair.

### Practical recovery ladder

State the requirement → Orient → Test the symptom → Inspect the closest boundary → Form a hypothesis → Make one controlled change → Re-test → Record the result → Stop.

The book develops this engineering judgement in detail. Use the [Chapter 11 lab](../chapters/chapter-11-evidence-first-troubleshooting/README.md) to rehearse it on your disposable Linux VM.
