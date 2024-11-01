{
  inputs,
  lib,
  pkgs,
  outputs,
  ...
}: {
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,1920x1200,0x0,1"
  ];
  extraConfig = lib.mkOverride 10 ''
      env = XDG_SESSION_TYPE,wayland
      env = WLR_NO_HARDWARE_CURSORS,1
      env = NIXOS_OZONE_WL,1
      env = GBM_BACKEND,nvidia-drm
      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    '';
}
