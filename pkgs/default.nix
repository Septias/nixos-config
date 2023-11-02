# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  dc-times = pkgs.callPackage /home/septias/coding/dc-times/flake.nix { };
}