{
  pkgs,
  outputs,
  ...
}: {
  imports = [];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      builders-use-substitutes = true;
      substituters = [
        "https://hyprland.cachix.org"
        "https://septias.cachix.org"
      ];
      trusted-public-keys = [
        "septias.cachix.org-1:49NwrE90/oHelsmAb1Ib7madbZtXoDzACAycBDWQ8Sw="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
  };

  # Configure Language
  time.timeZone = "Asia/Tokyo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
  console.keyMap = "neo";

  services = {
    pulseaudio = {
      enable = false;
      package = pkgs.pulsaudioFull;
      configFile = pkgs.writeText "default.pa" ''
        load-module module-bluetooth-policy
        load-module module-bluetooth-discovery
      '';
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      jack.enable = true;
    };

    gnome = {
      gnome-keyring.enable = true;
      evolution-data-server.enable = true;
      gnome-online-accounts.enable = true;
    };

    minecraft-server = {
      enable = false;
      eula = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "neo";
      };
      desktopManager.gnome.enable = false;
      displayManager.gdm.enable = true;
    };
    # update firmeware
    fwupd.enable = true;
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
      openFirewall = true;
    };

    # local network communication
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    openssh.enable = true;
    blocky = {
      # https://github.com/0xERR0R/blocky/blob/main/docs/config.yml
      enable = true;
      settings = {
        upstreams.groups = {
          default = ["1.1.1.1" "8.8.8.8" "https://dns.digitale-gesellschaft.ch/dns-query" "tcp-tls:fdns1.dismail.de:853"];
        };
        ports = {
          http = 4000;
          https = 443;
        };
        bootstrapDns = [
          {
            upstream = "https://one.one.one.one/dns-query";
            ips = ["1.1.1.1" "1.0.0.1"];
          }
          {
            upstream = "https://dns.quad9.net/dns-query";
            ips = ["9.9.9.9" "149.112.112.112"];
          }
          {
            upstream = "tcp-tls:dns.example.com";
            ips = ["123.123.123.123"];
          }
        ];
        blocking = {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
            social = [
              ''
                *.twitch.tv
                *.twitch.com
                *.chess.com
                *.youtube.com
                *.youtu.be
                *.yt.be
                *.ig.me
                *.instagram.com
                *.cdninstagram.com
              ''
            ];
          };
          allowlists = {
            social = [
              ''
                music.youtube.com
              ''
            ];
          };
          clientGroupsBlock = {
            default = ["ads" "social"];
          };
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
      };
    };
    # dbus service for storage devices
    udisks2.enable = true;
    # emacs daemon
    emacs.enable = false;
  };

  hardware = {
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # Enable A2DP
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    graphics = {
      enable = true;
      enable32Bit = false;
    };

    printers = {
      ensurePrinters = [
        {
          name = "Officejet-4620";
          location = "Home";
          deviceUri = "dnssd://Officejet%204620%20series%20%5BA6BBCE%5D._pdl-datastream._tcp.local/?uuid=1c852a4d-b800-1f08-abcd-c8cbb8a6bbce";
          model = "drv:///hp/hpcups.drv/hp-officejet_4620_series.ppd";
          ppdOptions = {
            PageSize = "A4";
          };
        }
      ];
    };
  };

  programs = {
    # Gnome password manager
    seahorse.enable = true;
    ssh.startAgent = true;
    steam.enable = false;
    hyprland = {
      enable = true;
      package = pkgs.unstable.hyprland;
      portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    };
    dconf.enable = true;
  };

  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
    resolvconf.useLocalResolver = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  environment = {
    shells = with pkgs; [nushell];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "hx";
      RUST_LOG = "info";
      XDG_RUNTIME_DIR = "/run/user/$UID";
      # SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };

    systemPackages = with pkgs; [
      home-manager
      git
      nodejs
      python3
      zip
      unzip
      killall
    ];
  };

  fonts.packages = with pkgs;
    [jetbrains-mono]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  users = {
    users.septias = {
      hashedPassword = "$6$zG32U5C91iUTFQWl$dgLpq4LN9X9UTUfpVA981QHcmMRArHjXKC5m3BnGX.00UvY3ILh5TysXYlGgXqAdLbv9hLQ84jRZ8tt3TaVv00";
      isNormalUser = true;
      extraGroups = ["media" "audio" "video" "networkmanager" "wheel"];
    };
    defaultUserShell = pkgs.nushell;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05";
}
