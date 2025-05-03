{inputs, ...}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];
  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    theme = "catppuccin_mocha";
    settings = {
      theme.bar = {
        transparent = false;
        enableShadow = true;
      };
      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "12px";
      };
      bar = {
        clock.format = "%a %b %d %H:%M";
        launcher.autoDetectIcon = true;
        customModules.hyprsunset.label = false;
      };
      menus = {
        clock = {
          weather.unit = "metric";
          weather.location = "Freiburg";
          time.military = true;
          # weather.key = config.sops.secrets.weather.path;
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
