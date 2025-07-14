{
  inputs,
  lib,
  pkgs,
  outputs,
  config,
  ...
}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.additions
      inputs.nix-your-shell.overlays.default
      inputs.nix4vscode.overlays.forVscode
    ];
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./hyprland
    ./modules/gnome.nix
    ./modules/helix.nix
    ./modules/kitty.nix
    ./modules/anyrun/mod.nix
    ./modules/nu/mod.nix
    ./modules/vscode/mod.nix
    ./modules/hyprshell.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    username = "septias";
    homeDirectory = "/home/septias";
  };

  home.packages = with pkgs; [
    unstable.deltachat-desktop
    google-chrome
    unstable.obsidian
    unstable.nodePackages.pnpm
    unstable.aider-chat

    ## Office
    telegram-desktop
    discord
    libreoffice
    thunderbird
    sqlitebrowser
    gthumb
    zoom-us
    vlc
    anki
    firefox
    nautilus
    gimp
    evince
    gnome-calendar
    gnome-control-center

    ## Testing
    # code-cursor
    warp-terminal

    ## Tooling
    scc # loc counter
    fd # find
    alejandra # Nix Formatter
    powertop # tui power usage analysis
    btop # tui resource monitor
    nix-tree
    fzf # fuzzy finder
    sl # funny train
    sops # Encrypted secrets in flake
    bluetuith # bluetooth tui
    ripgrep
    dig # DNS-lookup
    wev # input viewer
    yazi
    cachix

    ## langs
    (agda.withPackages [agdaPackages.standard-library])

    ## Utils
    wl-clipboard

    ## Custom
    inputs.dc-times.packages.x86_64-linux.dc-times
    inputs.reddit-wallpapers.packages.x86_64-linux.reddit-wallpapers
  ];

  xdg.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome];
    config.common = {
      default = ["hyprland" "gtk" "gnome"];
      "org.freedesktop.impl.portal.Settings" = "gnome";
    };
  };

  programs = {
    bat.enable = true;
    sioyek = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "sioyek";
        paths = [pkgs.sioyek];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/sioyek \
            --set QT_QPA_PLATFORM xcb
        '';
      };

      config = {
        # default_dark_mode = "false";
        papers_folder_path = "/home/septias/life/Areas/Studium/Masterproject/Paper";
        shared_database_path = "/home/septias/life/Ressources/shared.db";
      };
    };
    lazygit = {
      enable = true;
      settings = {
        keybindings.universal = {
          openDiffTool = "<c-d>";
          scrollDownMain-alt2 = "?";
        };
      };
    };
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
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
    zsh = {
      enable = false;
      enableCompletion = true;
      autosuggestion.enable = true;
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
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = false;
    };
    atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        style = "compact";
        inline_height = 20;
        enter_accept = true;
      };
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 25;
    };
  };

  sops = {
    age.keyFile = "/home/septias/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secret.yaml;
    secrets.copilot = {};
    secrets.weather = {};
    secrets.openai = {};
    secrets.cachix = {};
    secrets.openrouter = {};
    templates = {
      ".aider.conf.yaml".content = ''
        openai-api-key: ${config.sops.placeholder.openai}
        openrouter: ${config.sops.placeholder.openai}
      '';
    };
  };

  services.activitywatch = {
    enable = true;
    watchers = {
      aw-watcher-afk = {
        package = pkgs.activitywatch;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };

      aw-watcher-window = {
        package = pkgs.activitywatch;
        settings = {
          poll_time = 1;
          exclude_title = true;
        };
      };
    };
  };

  systemd.user.services.aider-config = {
    Unit = {
      Description = "Generate Config File for Aider";
      After = ["graphical-session.target" "sops-nix.service"];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "write-aider-config" ''
        ${pkgs.coreutils}/bin/cat ${config.sops.templates.".aider.conf.yaml".path} > /home/septias/.aider.conf.yml
      '';
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  home.file.".XCompose".source = ./Xcompose;
  home.activation.installWritableRepo = let
    repo = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      rev = "6751dae7ab8785f90edea585160926bad5e3e2ff";
      sha256 = "sha256-ajHgzeYcD1moI1Eir+GT0iZsOxMSlgkgB+Bh513TnxQ=";
    };
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      rm -rf "$HOME/.emacs.d"
      mkdir -p "$HOME/.emacs.d"
      cp -r ${repo}/. "$HOME/.emacs.d"
      chmod -R u+w "$HOME/.emacs.d"
    '';
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
