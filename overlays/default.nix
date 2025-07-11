# This file defines overlays
{inputs, ...}: {
  additions = final: prev: {additions = import ../pkgs {pkgs = final;};};
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = {
        permittedInsecurePackages = [
          "electron-34.5.8"
        ];
        allowUnfree = true;
      };
    };
  };
}
