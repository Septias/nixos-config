{
  # https://github.com/Misterio77/nix-starter-configs
  description = "Septias' nixos config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprpanel
    hyprpanel.url = "github:Septias/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";

    # App Switcher
    hyprswitch.url = "github:h3rmt/hyprshell";

    # Nix your shell
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Anyrun
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    dc-times.url = "github:septias/dc-times";
    reddit-wallpapers.url = "github:septias/reddit-wallpapers";
    better-ilias.url = "github:septias/better-ilias";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
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
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      nixos-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          ./hosts/desktop
          inputs.sops-nix.nixosModules.sops
        ];
      };

      nixos-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          ./hosts/laptop
          inputs.nixos-hardware.nixosModules.dell-xps-13-9310
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };

    # 'home-manager --flake .username@hostname'
    homeConfigurations = {
      "septias@nixos-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
          ./hosts/desktop/home-manager.nix
        ];
      };
      "septias@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
          ./hosts/laptop/home-manager.nix
        ];
      };
    };
  };
}
