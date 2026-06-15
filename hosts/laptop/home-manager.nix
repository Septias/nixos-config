{...}: {
  wayland.windowManager.hyprland = {
    settings.monitor = [
      "DP-5,1920x1080@144.00,auto-right,1"
      ",preferred,auto-right,1"
    ];
    settings.general.gaps_out = 10;
    settings.input.sensitivity = 1.3;
  };
  programs.hyprpanel.settings = {
    bar.layouts = {
      "0" = {
        left = [
          "cava"
          "volume"
          "cpu"
          "ram"
        ];
        middle = ["media"];
        right = [
          "battery"
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
}
