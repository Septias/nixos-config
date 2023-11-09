{
  inputs,
  lib,
  config,
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
    whatsapp-for-linux
    telegram-desktop
    discord

    gnomeExtensions.pop-shell
    gnomeExtensions.appindicator
    gnome.gnome-software

    unstable.google-chrome
    unstable.obsidian
    inkscape
    insomnia
    evince
    libreoffice
    agda

    inputs.dc-times.packages.x86_64-linux.dc-times
  ];

  programs = {
    git = {
      enable = true;
      userName = "Sebastian Klähn";
      userEmail = "scoreplayer2000@gmail.com";
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
      ];
      shellAliases = {
        dc-acc = "curl -X POST 'https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek'";
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
      languages = {
        language = [{
          name = "rust";
          config = {
            inlayHints.bindingModeHints.enable = false;
            inlayHints.closingBraceHints.minLines = 10;
            inlayHints.closureReturnTypeHints.enable = "with_block";
            inlayHints.discriminantHints.enable = "fieldless";
            inlayHints.lifetimeElisionHints.enable = "skip_trivial";
            inlayHints.typeHints.hideClosureInitialization = false;
          };
        }];
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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
