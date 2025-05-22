{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,1920x1200,0x0,1"
    "desc:Eizo Nanao Corporation EV2785 0x03015951, 2560x1440, 0x-1440,1"
    ", preferred, auto, 1, mirror, eDP-1"
  ];
  wayland.windowManager.hyprland.settings.input.sensitivity = 1.3;
  programs.hyprpanel.layout = lib.mkOverride 10 {
    bar.layouts = {
      "0" = {
        left = ["dashboard" "workspaces" "windowtitle"];
        middle = ["media"];
        right = [
          "cava"
          "ram"
          "cpu"
          "systray"
          "volume"
          "battery"
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
}
