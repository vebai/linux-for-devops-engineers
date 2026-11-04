# Clean up your Linux DevOps lab safely

Your practice workspace is usually `~/devops-lab/`. **Cleanup is not automated** because the lab may contain work you want to keep.

## 1. Confirm the system and location

```bash
hostname
whoami
cd ~
pwd
ls -ld ~/devops-lab
```

If the path does not identify your intended sandbox workspace, stop.

## 2. Inspect the resources you created

```bash
find ~/devops-lab -maxdepth 3 -print
```

Review any scripts, configuration, reports or archives you want to retain. The sample `app.log` and `app.conf` may have been modified while practising.

## 3. Preserve what matters

Move wanted results to a location outside the lab, or retain the workspace for later practice. Review file contents for sensitive material **before** copying them into version control. Do not commit actual credentials or private keys.

## 4. Remove only what you explicitly choose

For isolated temporary files, remove each selected path deliberately after inspecting it. Do **not** use indiscriminate system-wide cleanup commands.

If you deliberately want to remove **the entire learning workspace**, first verify that `~/devops-lab` is precisely the disposable directory you created and contains no wanted work. The recursive removal command below is irreversible and is **not run by any script**:

```bash
# ONLY after inspecting the exact directory above:
rm -r -- "$HOME/devops-lab"
```

Do not run it in a production environment or against a differently named directory.

## 5. Review system-level changes separately

Installing NGINX and changing its service state are **outside** the `~/devops-lab/` directory. Removing the workspace does not uninstall software or change service state. Decide separately whether to retain NGINX in the disposable VM, revert your lab changes or delete the entire disposable VM through your virtualisation provider.

The safest complete reset is often to discard a dedicated temporary VM after verifying that it contains no important work.
