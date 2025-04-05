{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [rust-overlay.overlays.default self.overlays.default];
          };
        in
          f {
            pkgs = pkgs;
            system = system;
          }
      );

    # Define defaults for missing parameters
    pluginName = "gh";
    lockFile = ./Cargo.lock;
    extraInputs = [];
  in {
    overlays.default = final: prev: {
      rustToolchain = let
        rust = prev.rust-bin;
      in
        if builtins.pathExists ./rust-toolchain.toml
        then rust.fromRustupToolchainFile ./rust-toolchain.toml
        else if builtins.pathExists ./rust-toolchain
        then rust.fromRustupToolchainFile ./rust-toolchain
        else
          rust.stable.latest.default.override {
            extensions = ["rust-src" "rustfmt"];
          };
    };

    packages = forEachSupportedSystem (
      {
        pkgs,
        system,
      }: let
        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        pname = cargoToml.package.name;
        version = cargoToml.package.version;
      in {
        default = pkgs.rustPlatform.buildRustPackage {
          pname = pname;
          version = version;

          # Use the current directory as the source, cleaning it via pkgs.lib
          src = pkgs.lib.cleanSource ./.;

          cargoLock = {inherit lockFile;};

          strictDeps = true;

          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.makeWrapper
          ];

          buildInputs =
            [
              pkgs.glib
              pkgs.atk
              pkgs.gtk3
              pkgs.librsvg
              pkgs."gtk-layer-shell"
            ]
            ++ extraInputs;

          doCheck = true;
          checkInputs = [
            pkgs.cargo
            pkgs.rustc
          ];

          copyLibs = true;
          cargoBuildFlags = ["-p ${pluginName}"];

          CARGO_BUILD_INCREMENTAL = "false";
          RUST_BACKTRACE = "full";

          meta = {
            description = "The ${pluginName} plugin for Anyrun";
            homepage = "https://github.com/anyrun-org/anyrun";
            license = [pkgs.lib.licenses.gpl3];
            maintainers = with pkgs.lib.maintainers; [NotAShelf n3oney];
          };
        };
      }
    );

    devShells = forEachSupportedSystem (
      {
        pkgs,
        system,
      }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            rustToolchain
            openssl
            pkg-config
            cargo-deny
            cargo-edit
            cargo-watch
            rust-analyzer
          ];

          env = {
            # Required by rust-analyzer:
            RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
          };
        };
      }
    );
  };
}
