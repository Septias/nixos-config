{...}: {
  wayland.windowManager.hyprland = {
    settings.monitor = [
      "eDP-1,1920x1200,0x0,1"
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
