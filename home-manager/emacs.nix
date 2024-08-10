
{
  inputs,
  lib,
  pkgs,
  outputs,
  ...
}: 
    pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacsGit;  # replace with pkgs.emacsPgtk, or another version if desired.
      config = ./emacs.el;
      # config = path/to/your/config.org; # Org-Babel configs also supported

      # Optionally provide extra packages not in the configuration file.
       #  extraEmacsPackages = epkgs: [
       #    epkgs.use-package
       # ];

      # Optionally override derivations.
      # override = epkgs: epkgs // {
      #   somePackage = epkgs.melpaPackages.somePackage.overrideAttrs(old: {
      #      # Apply fixes here
      #   });
      #};
}
