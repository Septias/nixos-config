{pkgs, ...}: {
  services.hyprshell = {
    enable = false;
    package = pkgs.unstable.hyprshell;
    systemd.args = "-v";
    settings = {
      windows = {
        enable = true;
        overview = {
          enable = true;
          key = "tab";
          modifier = "alt";
          launcher = {
            max_items = 6;
          };
        };
        switch.enable = true;
      };
    };
  };
}
