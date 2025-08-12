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
      remember_window_size = true;
      initial_window_width = 640;
      initial_window_height = 1080;
      hide_window_decorations = true;
      tab_bar_style = "powerline";
      enabled_layouts = "stack,tall";
      background_opacity = 0.9;
    };
    keybindings = {
      "ctrl+t" = "launch --cwd=current";
      "ctrl+shift+f" = "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i";
      "ctrl+shift+t" = "launch --type=tab --cwd=current";
      "ctrl+shift+n" = "next_window";
      "ctrl+q" = "close_window";
      "kitty_mod+/" = "launch";
    };
  };
}
