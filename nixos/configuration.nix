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
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    #registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

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
      efi.canTouchEfiVariables = true;
      /*
         grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 8;
        theme =
          pkgs.fetchFromGitHub
          {
            owner = "Lxtharia";
            repo = "minegrub-theme";
            rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
            sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
          };
      };
      */
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
  services.xserver.xkb = {
    layout = "de";
    variant = "neo";
  };
  console.keyMap = "neo";

  users.users.septias = {
    hashedPassword = "$6$zG32U5C91iUTFQWl$dgLpq4LN9X9UTUfpVA981QHcmMRArHjXKC5m3BnGX.00UvY3ILh5TysXYlGgXqAdLbv9hLQ84jRZ8tt3TaVv00";
    isNormalUser = true;
    extraGroups = ["media" "audio" "video" "networkmanager" "wheel"];
  };

  # Sound setup
  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    # more codecs
    package = pkgs.pulsaudioFull;
    # global pulseaudio installation
    configFile = pkgs.writeText "default.pa" ''
      load-module module-bluetooth-policy
      load-module module-bluetooth-discovery
    '';
  };

  # media buttons support
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = ["network.target" "sound.target"];
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    jack.enable = true;
  };
  # realtime scheduling for user processes
  security.rtkit.enable = true;

  services.minecraft-server = {
    enable = false;
    eula = true;
    openFirewall = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    # Enable A2DP
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      # Needed to show bluetooth headphone charge
      Experimental = true;
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # update firmeware
  services.fwupd.enable = true;

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
    openFirewall = true;
  };

  hardware.printers = {
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

  # local network communication
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.onedrive.enable = true;
  services.openssh = {
    enable = true;
  };

  xdg.portal.enable = true;

  #programs.zsh.enable = true;
  programs.steam.enable = true;
  programs.hyprland.enable = true;

  environment = {
    shells = with pkgs; [nushell zsh];
    variables = {
      DCC_NEW_TMP_EMAIL = "https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek";
      RUST_LOG = "info";
    };
  };
  users.defaultUserShell = pkgs.nushell;

  environment.systemPackages = with pkgs; [
    home-manager
    git
    nodejs_20
    python312
    zip
    nvd
    unzip
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05";
}
