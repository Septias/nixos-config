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
    unstable.pnpm
    unstable.claude-code
    google-chrome

    ## Office
    telegram-desktop
    discord
    libreoffice
    thunderbird
    # evolution
    sqlitebrowser
    gthumb
    loupe
    zoom-us
    vlc
    anki
    firefox
    nautilus
    gimp
    evince
    inkscape
    unstable.blender
    # mixxx
    audacity
    signal-desktop

    ## Tooling
    # wev # input viewer
    scc # loc counter
    powertop # TUI power usage analysis
    btop # TUI resource monitor
    fzf # Fuzzy finder
    sl # Funny train
    sops # Encrypted secrets in flake
    bluetuith # Bluetooth tui
    ripgrep # Text search
    dig # DNS-lookup
    yazi # tui file explorer
    cachix # cache
    qpdf
    qdirstat
    pavucontrol
    pandoc
    gnome-font-viewer
    gh

    linuxPackages.cpupower

    ## langs
    # (agda.withPackages [agdaPacages.standard-library])

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
      extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome];
      config.common = {
        default = ["hyprland" "gtk" "gnome"];
        "org.freedesktop.impl.portal.Settings" = "gnome";
      };
    };
  };

  programs = {
    bat.enable = true;
    aider-chat = {
      enable = true;
      settings = {
        dark-mode = true;
        model = "openrouter/openai/gpt-5";
        # weak-model = "openrouter/openrouter/gpt-5";
        auto-commits = false;
      };
    };
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
        highlight_color_e = "#338C0C";
        highlight_color_w = "#eef21f";
        should_highlight_unselected_search = "1";
      };
    };
    lazygit = {
      enable = true;
      package = pkgs.unstable.lazygit;
      settings = {
        keybinding.universal = {
          openDiffTool = "<c-g>";
        };
        git.diffRenderers = [
          {
            command = "${pkgs.delta}/bin/delta --features drr --paging=never";
          }
          {
            command = "${pkgs.ydiff}/bin/ydiff -p cat -s --wrap --width={{columnWidth}}";
            colorArg = "never";
          }
          # {
          #   externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
          # }
        ];
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Sebastian Klähn";
        user.email = "info@sebastian-klaehn.de";
        pull.rebase = true;
        push.default = "current";
        init.defaultBranch = "main";
        core.editor = "hx";
        checkout.defaultRemote = "origin";
        "delta \"drr\"" = {
          syntax-theme = "Dracula";
          plus-color = "#50fa7b";
          minus-color = "#ff5555";
        };
      };
    };
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
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

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Ice";
    size = 20;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  gtk.enable = true;

  sops = {
    age.keyFile = "/home/septias/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secret.yaml;
    secrets.copilot = {};
    secrets.openai = {};
    secrets.cachix = {};
    secrets.openrouter = {};
  };
  services = {
    activitywatch.enable = true;
    mpris-proxy.enable = true;
    udiskie.enable = true; # automount usb
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
        WantedBy = ["activitywatch.target" "graphical-session.target"];
      };
    };
    user.startServices = "sd-switch";
  };

  home.file.".XCompose".source = ./Xcompose;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
