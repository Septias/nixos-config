{pkgs, ...}: {
  services.hyprshell = {
    enable = true;
    package = pkgs.unstable.hyprshell;
    systemd.args = "-v";
    settings = {
      windows = {
        enable = true;
        overview = {
          enable = true;
          key = "tab";
          modifier = "super";
          launcher = {
            max_items = 6;
          };
        };
        switch.enable = true;
      };
    };
  };
}
