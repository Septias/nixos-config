{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,1920x1080@144.00Hz,0x0,1"
    "HDMI-A-1,1920x1080,1920x0,1"
    ", preferred, auto, 1"
    "Unkown-1, disabled"
  ];
  programs.hyprpanel.settings = {
    bar.layouts = {
      "1" = {
        left = [
          "cava"
          "volume"
          "cpu"
          "ram"
        ];
        middle = ["media"];
        right = [
          "bluetooth"
          "network"
          "clock"
          "notifications"
        ];
      };
      "*" = {
        left = [];
        middle = [];
        right = [];
      };
    };
  };
  wayland.windowManager.hyprland.extraConfig = lib.mkOverride 10 ''
    env = XDG_SESSION_TYPE,wayland
    env = WLR_NO_HARDWARE_CURSORS,1
    env = NIXOS_OZONE_WL,1
    env = GBM_BACKEND,nvidia-drm
    env = LIBVA_DRIVER_NAME,nvidia
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = ELECTRON_OZONE_PLATFORM_HINT,auto
  '';
}
