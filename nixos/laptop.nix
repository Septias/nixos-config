
{ config, pkgs, ... }:
{
  # Laptop power management
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
}