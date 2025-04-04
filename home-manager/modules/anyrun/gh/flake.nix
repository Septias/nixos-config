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
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [rust-overlay.overlays.default self.overlays.default];
          };
        });
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
    packages = forEachSupportedSystem ({pkgs}: {
      default = let
        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        pname = cargoToml.package.name;
        version = cargoToml.package.version;
      in
        rustPlatform.buildRustPackage {
          inherit pname version;

          src = builtins.path {
            path = lib.sources.cleanSource inputs.self;
            name = "${pname}-${version}";
          };
          cargoLock = {
            inherit lockFile;
          };

          strictDeps = true;

          nativeBuildInputs = [
            pkg-config
            makeWrapper
          ];

          buildInputs =
            [
              glib
              atk
              gtk3
              librsvg
              gtk-layer-shell
            ]
            ++ extraInputs;

          doCheck = true;
          checkInputs = [
            cargo
            rustc
          ];

          copyLibs = true;
          cargoBuildFlags = ["-p ${name}"];
          buildAndTestSubdir = "plugins/${name}";

          CARGO_BUILD_INCREMENTAL = "false";
          RUST_BACKTRACE = "full";

          meta = {
            description = "The ${name} plugin for Anyrun";
            homepage = "https://github.com/anyrun-org/anyrun";
            license = [lib.licenses.gpl3];
            maintainers = with lib.maintainers; [NotAShelf n3oney];
          };
        };
    });

    devShells = forEachSupportedSystem ({pkgs}: {
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
          # Required by rust-analyzer
          RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
        };
      };
    });
  };
}
