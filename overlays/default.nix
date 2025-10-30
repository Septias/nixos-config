# This file defines overlays
{inputs, ...}: {
  # Custom packages from the pkgs directory
  additions = final: prev: {additions = import ../pkgs {pkgs = final;};};
  
  # Overlay to access packages from nixpkgs-unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = {
        # Required for Obsidian which depends on an older Electron version
        permittedInsecurePackages = [
          "electron-34.5.8"
        ];
        allowUnfree = true;
      };
    };
  };
}
