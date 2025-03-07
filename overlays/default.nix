# This file defines overlays
{inputs, ...}: {
  hyprpanel = inputs.hyprpanel.overlay;
  additions = final: prev: import ../pkgs {pkgs = final;};
  emacs = inputs.emacs;
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
