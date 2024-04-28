{
  # https://github.com/Misterio77/nix-starter-configs
  description = "Septias' nixos config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Lanzaboot
    lanzaboote.url = "github:nix-community/lanzaboote";

    # Custom
    dc-times.url = "github:septias/dc-times";
    reddit-wallpapers.url = "github:septias/reddit-wallpapers";

    sf-mono-liga-src = {
      url ="github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    berkeley-mono = {
      url = "github:redyf/test";
      flake = false;
    };

    monolisa-script = {
      url = "github:redyf/test2";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Custom packages
    #packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      nixos-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./nixos/configuration.nix
          ./hosts/desktop
        ];
      };

      nixos-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          ./hosts/laptop
          lanzaboote.nixosModules.lanzaboote
          inputs.nixos-hardware.nixosModules.dell-xps-13-9310
        ];
      };
    };

    # 'home-manager --flake .username@hostname'
    homeConfigurations = {
      septias = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/home.nix];
      };
    };
  };
}
