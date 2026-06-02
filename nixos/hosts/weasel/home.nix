# WSL home configuration - disable systemd user services (no dbus)
{ ... }:
{
  systemd.user.startServices = false;
}
