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
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  imports = [
    ./hyprland
  ];

  home = {
    username = "septias";
    homeDirectory = "/home/septias";
  };

  home.packages = with pkgs; [
    unstable.whatsapp-for-linux
    deltachat-desktop
    unstable.google-chrome
    unstable.obsidian
    unstable.nodePackages.pnpm
    unstable.isabelle
    gnome.gnome-software

    ## coding
    agda

    ## Office
    telegram-desktop
    discord
    inkscape
    insomnia
    evince
    libreoffice
    thunderbird
    gimp
    sqlitebrowser
    gthumb
    zoom-us
    gparted
    blender
    ani-cli # animey
    vlc
    anki
    sioyek
    ranger

    ## Tooling
    nil # language server
    scc # loc counter
    fd # find
    # sequoia # gpg decrypt
    alejandra # formatter
    firebase-tools
    lazygit # tui git
    difftastic # diff files
    tlrc # tldr written in rust
    powertop # tui power usage analysis
    btop # tui resource monitor
    nix-tree # show nix store
    glxinfo # OpenGL info
    fzf # fuzzy finder
    sl # funny train
    taplo # toml language server

    ## Utils
    wl-clipboard # wayland clipboard utils

    ## Custom
    inputs.dc-times.packages.x86_64-linux.dc-times
    inputs.reddit-wallpapers.packages.x86_64-linux.reddit-wallpapers
    inputs.better-ilias.packages.x86_64-linux.better-ilias
  ];
  programs = {
    bat.enable = true;
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
        enabled_layouts = "horizontal,stack";
      };
      keybindings = {
        "ctrl+t" = "launch --cwd=/home/septias/coding";
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
      };
      shellAliases = {
        dc-acc = "curl -X POST 'https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek'";
        nd = "nix develop";
        nb = "nix build";
        nc = "hx /home/septias/coding/nixos-config";
        nh = "hx /home/septias/coding/nixos-config/home-manager/home.nix";
        nrs = "sudo nixos-rebuild switch --flake /home/septias/coding/nixos-config";
        hms = "home-manager switch --flake /home/septias/coding/nixos-config";
        _ = "sudo ";
        pkg = "nix-shell -p";
        pkg-s = "nix search nixpkgs";
        dr = "nix develop /home/septias/coding/nixos-config/direnvs/rust";
        c-fmt = "cargo fmt";
        c-fix = "cargo clippy --fix --allow-staged";
        gro = "git reset HEAD~1";
        gc = "git commit -am";
        gu = "git push --force-with-lease";
        gd = "git pull";
        gds = "git stash and git pull --ff and git stash pop";
        nix-clean = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old and nix-collect-garbage -d";
        #sess_type = "loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'";
        lg = "lazygit";
        life = "hx /home/septias/OneDrive/Life";
        todo = "hx /home/septias/OneDrive/Life/Projects/TODOS.md";
        o = "xdg-open";
        fu = "nix flake update";
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
    helix = {
      enable = true;
      package = pkgs.unstable.helix;
      settings = {
        theme = "catppuccin_frappe";

        editor = {
          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };
          line-number = "relative";
          completion-timeout = 100;
          completion-replace = true;
          statusline.left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator" "total-line-numbers"];
          auto-save.focus-lost = true;
        };
        # https://docs.helix-editor.com/keymap.html
        keys.insert = {
          "C-s" = ":w";
          "C-r" = "insert_register";
          "C-x" = "completion";
          "C-u" = "kill_to_line_start";
          "C-k" = "kill_to_line_end";
        };
        keys.normal = {
          "C-m" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          "C-h" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          "C-f" = "jump_forward";
          "C-g" = "jump_backward";
          "C-s" = "save_selection";
          "C-b" = "goto_previous_buffer";
          "C-e" = "goto_file_end";
          "C-l" = "last_picker";
          # Changes
          "R" = "replace_with_yanked";
          "=" = "format_selections";
          "A-d" = "delete_selection_noyank";
          "Q" = "record_macro";
          "q" = "replay_macro";
          # Selection manipulation
          "s" = "select_regex";
          "S" = "split_selection";
          "&" = "align_selections";
          "_" = "trim_selections";
          "C" = "copy_selection_on_next_line";
          "A-f" = "expand_selection";
          "A-g" = "shrink_selection";
          "A-n" = "select_next_sibling";
          "A-b" = "select_prev_sibling";
          # Search
          "*" = "search_selection";
        };
        # keys.goto = {
        #   "s" = "goto_first_nonwhitespace";
        #   "f" = "goto_file";
        #   "a" = "goto_last_accessed_file";
        #   "." = "goto_last_modification";
        #   "w" = "goto_word";
        # };
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
    "org/gnome/gnome-session" = {
      logout-prompt = false;
    };
  };

  home.file.".XCompose".source = ./Xcompose;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
