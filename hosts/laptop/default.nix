{lib, ...}: {
  imports = [./hardware-configuration.nix];

  networking = {
    # Enable WiFi power saving for battery life
    networkmanager.wifi.powersave = true;
    hostName = "nixos-laptop";
  };
  
  # Power management configuration
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  
  services = {
    # Fingerprint reader (disabled - can be enabled if needed)
    fprintd.enable = lib.mkForce false;
    # Touchpad gestures
    touchegg.enable = true;
    # Battery status monitoring
    upower.enable = true;
    # Thermal management
    thermald.enable = true;
    # Suspend on lid close
    logind.lidSwitch = "suspend";
    # Advanced power management with TLP
    tlp = {
      enable = true;
      settings = {
        # Performance mode when plugged in
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        # Power saving mode on battery
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # Battery charge thresholds to extend battery life
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 81;
      };
    };
  };
}
