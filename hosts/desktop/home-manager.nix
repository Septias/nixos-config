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
  services.hypridle.settings.listener = [
    {
      timeout = 900;
      on-timeout = "hyprlock";
    }
    {
      timeout = 1200;
      on-timeout = "hyprctl dispatch dpms off";
    }
  ];
}
