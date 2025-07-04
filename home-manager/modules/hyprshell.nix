{inputs, ...}: {
  imports = [
    inputs.hyprshell.homeModules.hyprshell
  ];
  programs.hyprshell = {
    enable = false;
    systemd.args = "-v";
    settings = {
      windows = {
        enable = false;
        overview = {
          key = "super_l";
          modifier = "super";
          launcher = {
            enable = false;
          };
        };
        switch.enable = true;
      };
    };
  };
}
