{
  inputs,
  lib,
  pkgs,
  outputs,
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
    unstable.obsidian
    unstable.nodePackages.pnpm
    google-chrome

    ## Office
    cider # apple music client
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
    aider-chat

    ## Tooling
    scc # loc counter
    powertop # TUI power usage analysis
    btop # TUI resource monitor
    nix-tree
    fzf # Fuzzy finder
    sl # Funny train
    sops # Encrypted secrets in flake
    bluetuith # Bluetooth tui
    ripgrep # Text search
    dig # DNS-lookup
    wev # input viewer
    yazi # tui file explorer
    cachix # cache
    difftastic
    meld

    ## langs
    # (agda.withPackages [agdaPackages.standard-library])

    ## Utils
    wl-clipboard

    ## Custom
    inputs.dc-times.packages.x86_64-linux.dc-times
    inputs.reddit-wallpapers.packages.x86_64-linux.reddit-wallpapers
  ];

  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome];
      # configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome];
      config.common = {
        default = ["hyprland" "gtk" "gnome"];
        "org.freedesktop.impl.portal.Settings" = "gnome";
      };
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
        papers_folder_path = "/home/septias/life/Areas/Studium/Masterproject/Paper";
        shared_database_path = "/home/septias/life/Ressources/shared.db";
      };
    };
    lazygit = {
      enable = true;
      package = pkgs.unstable.lazygit;
      settings = {
        keybinding.universal = {
          openDiffTool = "<c-g>";
        };
      };
    };
    git = {
      enable = true;
      userName = "Sebastian Klähn";
      userEmail = "info@sebastian-klaehn.de";
      extraConfig = {
        pull.rebase = true;
        push.default = "current";
        init.defaultBranch = "main";
        core.editor = "hx";
        difftool.prompt = false;
        difftool.meld = {
          cmd = ''meld "$LOCAL" "$REMOTE"'';
        };
        diff.tool = "meld";
        checkout.defaultRemote = "origin";
      };
      difftastic.enable = true;
      aliases = {
        dl = "-c diff.external=difft log -p --ext-diff";
        ds = "-c diff.external=difft show --ext-diff";
        dft = "-c diff.external=difft diff";
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
  };
  services = {
    activitywatch = {
      enable = true;
    };
    mpris-proxy.enable = true;
  };

  systemd = {
    user.services.activitywatch-watcher-window-hyprland = {
      Unit = {
        Description = "ActivityWatch watcher 'aw-watcher-window-hyprland'";
        After = [
          "graphical-session.target"
          "activitywatch.service"
        ];
        BindsTo = ["activitywatch.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        ExecStart = lib.getExe pkgs.aw-watcher-window-wayland;
      };
      Install = {
        WantedBy = ["activitywatch.target"];
      };
    };
    user.startServices = "sd-switch";
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
