{...}: {
  wayland.windowManager.hyprland = {
    settings.monitor = [
      # "DP-1,2560x1440,auto-up,1"
      ",preferred,auto-up,1"
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
