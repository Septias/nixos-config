{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    font = {
      package = pkgs.jetbrains-mono;
      name = "JetBrains Mono";
      size = 15;
    };
    settings = {
      confirm_os_window_close = 0;
      hide_window_decorations = true;
      tab_bar_style = "powerline";
      enabled_layouts = "tall,stack";
      background_opacity = 0.9;
    };
    keybindings = {
      "ctrl+q" = "close_window";
      "ctrl+t" = "launch --type=os-window --cwd=current";
      "ctrl+shift+t" = "launch --type=tab --cwd=current";
      "ctrl+shift+f" = "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i";
      "ctrl+e" = "launch --type=os-window --cwd=current --copy-env hx .";
      "ctrl+w" = "launch --type=overlay --cwd=current --copy-env"; # testing
      "ctrl+l" = "launch --type=overlay --cwd=current lazygit";
      "ctrl+shift+e" = "combine : launch --type=background --hold=no --copy-env --cwd=current codium .: close_window";
    };
  };

  home.file.light = {
    source = ./kitty/light-theme.conf;
    target = ".config/kitty/light-theme.auto.conf";
  };
  home.file.dark = {
    source = ./kitty/dark-theme.conf;
    target = ".config/kitty/dark-theme.auto.conf";
  };
}
