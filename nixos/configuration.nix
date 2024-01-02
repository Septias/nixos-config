{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [];
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-generations +5";
    };

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking.networkmanager.enable = true;

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["ntfs"];
    bootspec.enable = true;
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
  services.xserver = {
    layout = "de";
    xkbVariant = "neo";
  };
  console.keyMap = "neo";

  users.users.septias = {
    hashedPassword = "$6$zG32U5C91iUTFQWl$dgLpq4LN9X9UTUfpVA981QHcmMRArHjXKC5m3BnGX.00UvY3ILh5TysXYlGgXqAdLbv9hLQ84jRZ8tt3TaVv00";
    isNormalUser = true;
    extraGroups = ["media" "audio" "video" "networkmanager" "wheel"];
  };

  # Sound setup
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;
  services.onedrive.enable = true;
  services.openssh = {
    enable = true;
  };

  programs.zsh.enable = true;
  programs.steam.enable = true;

  environment.shells = with pkgs; [zsh];
  environment.variables = {
    DCC_NEW_TMP_EMAIL = "https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek";
    RUST_LOG = "info";
  };
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    home-manager
    git
    nodejs
    nodePackages.pnpm
    yarn
    python312
    zip
    gcc
    nvd
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05";
}
