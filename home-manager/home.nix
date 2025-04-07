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
      outputs.overlays.hyprpanel
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
    inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    username = "septias";
    homeDirectory = "/home/septias";
  };

  home.packages = with pkgs; [
    whatsapp-for-linux
    unstable.deltachat-desktop
    unstable.google-chrome
    unstable.obsidian
    unstable.nodePackages.pnpm

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
    sioyek
    yazi
    fd
    firefox
    unstable.aider-chat
    nautilus
    gimp
    # inkscape
    # evince
    # sonic-pi # music coding

    ## Tooling
    scc # loc counter
    fd # find
    alejandra # Nix Formatter
    firebase-tools
    powertop # tui power usage analysis
    btop # tui resource monitor
    nix-tree
    fzf # fuzzy finder
    sl # funny train
    tldr # Short man pages
    sops # Encrypted secrets in flake
    bluetuith # bluetooth tui
    # via # keyboard config
    delta # Difftool
    difftastic # Difftool
    ripgrep
    dig
    copyq

    ## Utils
    wl-clipboard

    ## Custom
    inputs.dc-times.packages.x86_64-linux.dc-times
    inputs.reddit-wallpapers.packages.x86_64-linux.reddit-wallpapers
    inputs.better-ilias.packages.x86_64-linux.better-ilias
    inputs.hyprswitch.packages.x86_64-linux.default
  ];

  programs = {
    bat.enable = true;
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
    vscode = {
      enable = true;
      package = pkgs.unstable.vscode;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = true;
    };
    atuin = {
      enable = false;
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
    templates = {
      ".aider.conf.yaml".content = ''
        openai-api-key: ${config.sops.placeholder.openai}
      '';
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
