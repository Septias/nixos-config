{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  waybar_config = import ./catppuccin/config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./catppuccin/style.nix {inherit (config) colorscheme;};
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = waybar_config;
    style = waybar_style;
  };
}
