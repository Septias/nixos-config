{...}: {
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,1920x1200,0x0,1"
    ", preferred, auto, 1, mirror, eDP-1"
  ];
  programs.hyprpanel.layout = {
    bar.layouts = {
      "0" = {
        left = ["dashboard" "workspaces" "windowtitle"];
        middle = ["media"];
        right = [
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
}
