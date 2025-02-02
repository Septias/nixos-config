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
    };
  };

  networking.networkmanager.enable = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      efi.canTouchEfiVariables = true;
    };
  };

  # Configure Language
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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
  console.keyMap = "neo";

  users.users.septias = {
    hashedPassword = "$6$zG32U5C91iUTFQWl$dgLpq4LN9X9UTUfpVA981QHcmMRArHjXKC5m3BnGX.00UvY3ILh5TysXYlGgXqAdLbv9hLQ84jRZ8tt3TaVv00";
    isNormalUser = true;
    extraGroups = ["media" "audio" "video" "networkmanager" "wheel"];
  };

  # media buttons support
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = ["network.target" "sound.target"];
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      jack.enable = true;
    };

    gnome.gnome-keyring.enable = true;

    minecraft-server = {
      enable = false;
      eula = true;
      openFirewall = true;
    };
    
    xserver = {
      xkb = {
        layout = "de";
        variant = "neo";
      };

      enable = true;
      desktopManager.gnome.enable = true;
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

    onedrive.enable = true;
    openssh.enable = true;
  };
  
  security = {
    polkit.enable = true;
    pam = {
      services = {
        gdm-password.enableGnomeKeyring = true;
        gdm.enableGnomeKeyring = true;
        hyprland.enableGnomeKeyring = true;
        hyprlock = {};
      };
    };
    rtkit.enable = true;
  };
  
  hardware = {
    # Sound setup
    pulseaudio = {
      enable = false;
      package = pkgs.pulsaudioFull;
      configFile = pkgs.writeText "default.pa" ''
        load-module module-bluetooth-policy
        load-module module-bluetooth-discovery
      '';
    };

    # Bluetooth
    bluetooth = {
      enable = true;
      # Enable A2DP
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        # Needed to show bluetooth headphone charge
        Experimental = true;
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];
  };
  
  programs = {
    seahorse.enable = true;
    ssh.startAgent = true;
    steam.enable = true;
    hyprland.enable = true;
  };

  environment = {
    shells = with pkgs; [nushell zsh];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "hx";
      RUST_LOG = "info";
      XDG_RUNTIME_DIR = "/run/user/$UID";
    };
  };
  
  users.defaultUserShell = pkgs.nushell;

  environment.systemPackages = with pkgs; [
    home-manager
    git
    nodejs
    python3
    zip
    unzip
    libsecret
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05";
}
