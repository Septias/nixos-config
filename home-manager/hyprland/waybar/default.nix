{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.readFile ./style.css;

    settings = builtins.fromJSON (builtins.readFile ./config.json);
  };
  xdg.configFile = {
    "waybar/theme.css".source = ./theme.css;
  };
}
