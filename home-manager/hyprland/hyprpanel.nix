{inputs, ...} : {
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    systemd.enable = true;
    overwrite.enable = true;
    theme = "nord";
    settings = {
      theme.bar.transparent = true;
      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "12px";
      };
    };
  };
}
