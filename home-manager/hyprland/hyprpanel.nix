{...}: {
  programs.hyprpanel = {
    enable = true;
    settings = {
      theme =
        builtins.fromJSON (builtins.readFile ./hyprpanel/theme.json)
        // {
          font = {
            name = "JetBrainsMono Nerd Font";
            size = "12px";
          };
        };
      bar = {
        clock.format = "%a %b %d %H:%M";
        launcher.autoDetectIcon = true;
        customModules = {
          hyprsunset.label = false;
          cava = {
            showIcon = false;
            showActiveOnly = true;
          };
        };
        systray.ignore = ["deltachat-desktop" "telegram"];
      };
      menus = {
        clock = {
          weather.unit = "metric";
          weather.location = "Freiburg";
          time.military = true;
          weather.key = "c9b2bc7713f34e49862192604250603";
        };
        dashboard.stats.enable_gpu = true;
        media.noMediaText = "No music ~ uwu";
        power.confirmation = false;
        dashboard.directories.enabled = false;
      };
      wallpaper.enable = false;
    };
  };
}
