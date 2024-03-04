{...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "nixos-laptop";
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
}
