{
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  networking = {
    networkmanager.wifi.powersave = true;
    hostName = "nixos-laptop";
  };
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services = {
    fprintd.enable = lib.mkForce false;
    touchegg.enable = true;
    upower.enable = true;
    thermald.enable = true;
    logind.settings.Login.HandleLidSwitch = "suspend";
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c09d", TEST=="power/control", ATTR{power/control}="on"
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c246", TEST=="power/control", ATTR{power/control}="on"
    '';
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 1;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 1;
        CPU_MAX_PERF_ON_BAT = 20;

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 81;

        USB_DENYLIST = "046d:c09d";
      };
    };
  };
}
