{
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      move-to-monitor-left = ["<Shift><Super>r"];
      move-to-monitor-right = ["<Shift><Super>t"];
      move-to-workspace-left = ["<Alt><Super>r"];
      move-to-workspace-right = ["<Alt><Super>t"];
      switch-to-workspace-left = ["<Super>r"];
      switch-to-workspace-right = ["<Super>t"];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/shell" = {
      favorite-apps = ["google-chrome.desktop" "code.desktop"];
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };
    "org/gnome/evince" = {
      document-directory = "@ms file:///home/septias/OneDrive/Life/Ressources/books";
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Shift><Super>Return";
      command = "kitty /home/septias/coding";
      name = "Terminal";
    };
    "org/gnome/terminal/legacy" = {
      theme-variant = "dark";
    };
    "org/gnome/gnome-session" = {
      logout-prompt = false;
    };
  };
}
