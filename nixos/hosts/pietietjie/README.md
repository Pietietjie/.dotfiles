# pietietjie host

## rclone Google Drive setup

After `sudo nixos-rebuild switch`, configure rclone for Passwords.kdbx sync:

```bash
rclone config
```

1. `n` — new remote
2. Name: `gdrive`
3. Storage: `drive`
4. Leave client_id and client_secret blank
5. Scope: `1` (full access)
6. Leave root_folder_id and service_account_file blank
7. Auto config: `y` (opens browser for Google OAuth)
8. Team drive: `n`
9. Confirm with `y`, then `q` to quit

Test the sync:

```bash
systemctl --user start rclone-passwords
```

Verify the timer is active:

```bash
systemctl --user status rclone-passwords.timer
```

The timer syncs `~/Passwords.kdbx` bidirectionally with `gdrive:Passwords.kdbx` every hour, starting 1 minute after login.
