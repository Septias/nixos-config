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
    ];
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./hyprland
    ./gnome.nix
    ./modules/helix.nix
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
    inkscape
    evince
    libreoffice
    thunderbird
    gimp
    sqlitebrowser
    gthumb # image viewer
    zoom-us
    gparted # partition editor
    vlc
    anki
    sioyek # pdf reader
    ranger # tui file manager
    gnome-software
    sonic-pi # music coding

    ## Tooling
    scc # loc counter
    fd # find
    alejandra # Nix Formatter
    firebase-tools
    powertop # tui power usage analysis
    btop # tui resource monitor
    nix-tree
    glxinfo # OpenGL info
    fzf # fuzzy finder
    sl # funny train
    tldr # Short man pages
    sops # Encrypted secrets in flake
    bluetuith # bluetooth tui
    via # keyboard config
    delta # Difftool
    difftastic # Difftool

    ## Utils
    wl-clipboard # wayland clipboard utils

    ## Custom
    inputs.dc-times.packages.x86_64-linux.dc-times
    inputs.reddit-wallpapers.packages.x86_64-linux.reddit-wallpapers
    inputs.better-ilias.packages.x86_64-linux.better-ilias
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
    kitty = {
      enable = true;
      font = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
        size = 15;
      };
      themeFile = "Catppuccin-Frappe";
      settings = {
        confirm_os_window_close = 0;
        remember_window_size = true;
        initial_window_width = 640;
        initial_window_height = 1080;
        hide_window_decorations = true;
        tab_bar_style = "powerline";
        enabled_layouts = "horizontal,stack";
        background_opacity = 0.9;
      };
      keybindings = {
        "ctrl+t" = "launch --cwd=current";
        "ctrl+shift+t" = "launch --type=tab --cwd=current";
        "ctrl+shift+n" = "next_window";
        "ctrl+q" = "close_window";
        # "ctrl+g" = "kitten hints --type=linenum --linenum-action=tab code --goto \"{path}:{line}\"";
      };
      shellIntegration.enableZshIntegration = false;
    };
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
      environmentVariables = {
        CHATMAIL_DOMAIN = "\"nine.testrun.org\"";
        HANDLER = "copilot";
      };
      extraConfig = "$env.COPILOT_API_KEY = (open ${config.sops.secrets.copilot.path} | str trim)";
      shellAliases = {
        dc-acc = "curl -X POST 'https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek'";
        nd = "nix develop";
        nb = "nix build";
        fu = "nix flake update";
        nc = "hx /home/septias/coding/nixos-config";
        nh = "hx -w /home/septias/coding/nixos-config /home/septias/coding/nixos-config/home-manager/home.nix";
        nrs = "sudo nixos-rebuild switch --flake /home/septias/coding/nixos-config";
        hms = "home-manager switch --flake /home/septias/coding/nixos-config";
        _ = "sudo ";
        pkg = "nix-shell -p";
        pkg-s = "nix search nixpkgs";
        c-fmt = "cargo fmt";
        c-fix = "cargo clippy --fix --allow-staged";
        gaa = "git add *";
        gro = "git reset HEAD~1";
        gc = "git commit -am";
        gu = "git push --force-with-lease";
        gd = "git pull";
        gds = "git stash and git pull and git stash pop";
        nix-clean = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old and nix-collect-garbage -d";
        lg = "lazygit";
        life = "hx /home/septias/OneDrive/Life";
        todo = "hx /home/septias/OneDrive/Life/Projects/TODOS.md";
        o = "xdg-open";
        debug_h = "tail --follow ~/.cache/helix/helix.log";
      };
    };
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
    # unused
    zsh = {
      enable = true;
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
  };

  home.file.".XCompose".source = ./Xcompose;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
