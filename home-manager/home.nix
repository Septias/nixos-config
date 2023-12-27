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

  home.packages = with pkgs; [
    unstable.whatsapp-for-linux
    unstable.deltachat-desktop
    unstable.google-chrome
    #unstable.obsidian

    gnome.gnome-software
    
    telegram-desktop
    discord
    inkscape
    insomnia
    gitkraken
    evince
    libreoffice
    agda
    nil
    scc
    fd
    rust-analyzer
    inputs.dc-times.packages.x86_64-linux.dc-times
  ];

  programs = {
    git = {
      enable = true;
      userName = "Sebastian Klähn";
      userEmail = "scoreplayer2000@gmail.com";
      extraConfig = {
        pull.rebase = true;
        checkout.defaultRemote = "origin";
        pull.ff = "only";
        push.default = "current";
        init.defaultBranch = "main";
      };
    };
    alacritty = {
      enable = true;
      settings = {
        colors = {
          primary = {
            background = "#303446";
            foreground = "#C6D0F5";
            # Bright and dim foreground colors
            dim_foreground = "#C6D0F5";
            bright_foreground = "#C6D0F5";
          };
          
          cursor = {
            text = "#303446";
            cursor = "#F2D5CF";
          };

          vi_mode_cursor = {
              text = "#303446"; # base
              cursor = "#BABBF1"; # lavender
          };

          # Search colors
          search.matches = {
              foreground = "#303446"; # base
              background = "#A5ADCE"; # subtext0
          };

          search.focused_match = {
              foreground = "#303446"; # base
              background = "#A6D189"; # green
          };
          footer_bar = {
              foreground = "#303446"; # base
              background = "#A5ADCE"; # subtext0
          };
          # Keyboard regex hints
          hints.start = {
              foreground = "#303446"; # base
              background = "#E5C890"; # yellow
          };

          hints.end = {
              foreground = "#303446"; # base
              background = "#A5ADCE"; # subtext0
          };
          # Selection colors
          section = {
              text = "#303446"; # base
              background = "#F2D5CF"; # rosewater
          };

          # Normal colors
          normal = {
              black = "#51576D"; # surface1
              red = "#E78284"; # red
              green = "#A6D189"; # green
              yellow = "#E5C890"; # yellow
              blue = "#8CAAEE"; # blue
              magenta = "#F4B8E4"; # pink
              cyan = "#81C8BE"; # teal
          white = "#B5BFE2"; # subtext1
          };

          # Bright colors
          bright = {
              black = "#626880"; # surface2
              red = "#E78284"; # red
              green = "#A6D189"; # green
              yellow = "#E5C890"; # yellow
              blue = "#8CAAEE"; # blue
              magenta = "#F4B8E4"; # pink
              cyan = "#81C8BE"; # teal
              white = "#A5ADCE"; # subtext0
          };

          # Dim colors
          dim = {
              black = "#51576D"; # surface1
              red = "#E78284"; # red
              green = "#A6D189"; # green
              yellow = "#E5C890"; # yellow
              blue = "#8CAAEE"; # blue
              magenta = "#F4B8E4"; # pink
              cyan = "#81C8BE"; # teal
              white = "#B5BFE2"; # subtext1
          };
        };
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      initExtra = "cd coding";
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
      ];
      shellAliases = {
        dc-acc = "curl -X POST 'https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek'";
        nd = "nix develop";
        gro = "git reset HEAD~1";
        c = "code .";
      };
    };
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_frappe";
        editor.lsp = {
          display-inlay-hints = true;
        };
      };
    };
    vscode = {
      enable = true;
      package = pkgs.unstable.vscode;
    };
    direnv.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      move-to-monitor-left=["<Shift><Super>r"];
      move-to-monitor-right=["<Shift><Super>t"];
      move-to-workspace-left=["<Alt><Super>r"];
      move-to-workspace-right=["<Alt><Super>t"];
      switch-to-workspace-left=["<Super>r"];
      switch-to-workspace-right=["<Super>t"];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      color-scheme= "prefer-dark";
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
      document-directory= "@ms file:///home/septias/OneDrive/Life/Ressources/books";
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled=true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Shift><Super>Return";
      command = "alacritty";
      name = "Terminal";
    };
    "org/gnome/terminal/legacy" = {
      theme-variant="dark";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
