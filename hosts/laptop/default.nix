
{ config, pkgs, ... }:
{

  networking.hostName = "nixos-laptop";

  # Laptop power management
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
}