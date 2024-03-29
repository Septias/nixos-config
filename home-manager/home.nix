{
  inputs,
  lib,
  pkgs,
  outputs,
  ...
}: {
  imports = [];
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "septias";
    homeDirectory = "/home/septias";
  };

  wayland.windowManager.hyprland = (import ./hyprland.nix) {inherit pkgs;};

  home.packages = with pkgs; [
    unstable.whatsapp-for-linux
    unstable.deltachat-desktop
    unstable.google-chrome
    unstable.obsidian

    gnome.gnome-software

    ## Office
    telegram-desktop
    discord
    inkscape
    insomnia
    gitkraken
    evince
    libreoffice
    thunderbird
    gimp
    sqlitebrowser
    gthumb
    zoom-us
    gparted

    ## Tooling
    nil # language server
    scc # loc counter
    fd # find
    sequoia # gpg decrypt
    alejandra # formatter
    firebase-tools 
    lazygit # tui git
    difftastic # diff files
    tlrc # tldr written in rust
    powertop # tui power usage analysis
    btop # tui resource monitor

    ## Utils
    wl-clipboard # wayland clipboard utils

    ## Custom
    inputs.dc-times.packages.x86_64-linux.dc-times
    inputs.reddit-wallpapers.packages.x86_64-linux.reddit-wallpapers
  ];
  programs = {
    git = {
      enable = true;
      userName = "Sebastian Klähn";
      userEmail = "scoreplayer2000@gmail.com";
      extraConfig = {
        pull.rebase = true;
        push.default = "current";
        init.defaultBranch = "main";
        core.editor = "hx";
        checkout.defaultRemote = "origin";
      };
    };
    kitty = {
      enable = true;
      font = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
        size = 15;
      };
      theme = "Catppuccin-Frappe";
      settings = {
        confirm_os_window_close = 0;
        remember_window_size = true;
        initial_window_width = 640;
        initial_window_height = 1080;
        hide_window_decorations = true;
        tab_bar_style = "powerline";
        enabled_layouts = "horizontal,tall,stack";
      };
      keybindings = {
        "ctrl+t" = "launch --cwd=/home/septias/coding";
        "ctrl+shift+n" = "next_window";
        "ctrl+q" = "close_window";
        "ctrl+g" = "kitten hints --type=linenum --linenum-action=tab code --goto \"{path}:{line}\"";
      };
      shellIntegration.enableZshIntegration = true;
    };
    nushell = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.7.0";
            sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
          };
        }
      ];
      shellAliases = {
        dc-acc = "curl -X POST 'https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek'";
        CHATMAIL_DOMAIN = "nine.testrun.org";
        coder = "dr && code";
        nd = "nix develop";
        nb = "nix build";
        nc = "hx /home/septias/coding/nixos-config";
        nf = "nix fmt";
        nrs = "sudo nixos-rebuild switch --flake /home/septias/coding/nixos-config";
        hms = "home-manager switch --flake /home/septias/coding/nixos-config";
        pkg = "nix-shell -p";
        dr = "nix develop /home/septias/coding/nixos-config/direnvs/rust";
        cfmt = "cargo fmt";
        cclippy = "cargo clippy --fix --allow-staged";
        gro = "git reset HEAD~1";
        gc = "git commit -am";
        gp = "git push --force-with-lease";
        sess_type = "loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'";
        lg = "lazygit";
        life = "hx /home/septias/OneDrive/Life";
        todo = "hx /home/septias/OneDrive/Life/Projets/TODOS.md";
      };
    };
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_frappe";
        editor.lsp = {
          display-inlay-hints = true;
        };
        keys.insert = {
          "C-s" = ":w";
        };
      };
    };
    vscode = {
      enable = true;
      package = pkgs.unstable.vscode;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    atuin = {
      enable = true;
      enableZshIntegration = false;
    };
  };

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
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Shift><Super>Return";
      command = "kitty /home/septias/coding";
      name = "Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift><Super>g";
      command = "rofi -show run";
      name = "Rofi";
    };
    "org/gnome/terminal/legacy" = {
      theme-variant = "dark";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
