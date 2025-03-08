{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = [
    "DP-2,1920x1080@144.00Hz,0x0,1"
    "HDMI-A-1,1920x1080,1920x0,1"
    ", preferred, auto, 1"
    "Unkown-1, disabled"
  ];
  programs.hyprpanel.layout = {
    bar.layouts = {
      "1" = {
        left = ["dashboard" "workspaces" "windowtitle"];
        middle = ["media"];
        right = [
          "kbinput"
          "hyprsunset"
          "cava"
          "systray"
          "volume"
          "network"
          "bluetooth"
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
