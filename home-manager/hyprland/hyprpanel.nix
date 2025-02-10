{inputs, ...} : {
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  # TODO: Add hyprsunset, kblayout, powermodule, matugen?
  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    theme = "nord";
    settings = {
      theme.bar.transparent = true;
      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "12px";
      };
      bar.clock.format = "%a %b %d %H:%M";
      bar.launcher.autoDetectIcon = true;
      menus.clock.weather.location = "Berlin";
      # menu.clock.weather.unit = "";
      menus.dashboard.stats.enable_gpu = true;
      menus.media.noMediaText = "No music ~ uwu";
      menus.power.confirmation = false;
    };
  };
}
