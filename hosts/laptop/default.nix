
{ config, pkgs, ... }:
{
  imports = [./hardware-configuration.nix];
  networking.hostName = "nixos-laptop";
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
}