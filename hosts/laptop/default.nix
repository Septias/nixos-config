
{ config, pkgs, ... }:
{
  inputs = [./hardware-configuration.nix];
  networking.hostName = "nixos-laptop";
  # Laptop power management
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
}