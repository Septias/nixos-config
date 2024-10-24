{lib, ...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "nixos-laptop";
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;  
  services.fprintd.enable = lib.mkForce false;
  services.touchegg.enable = true;
}
