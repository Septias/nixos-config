# This file defines overlays
{inputs, ...}: {
  additions = final: prev: {additions = import ../pkgs {pkgs = final;};};
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
