{
  lib,
  # Common dependencies for the plugin
  glib,
  makeWrapper,
  rustPlatform,
  atk,
  gtk3,
  gtk-layer-shell,
  pkg-config,
  librsvg,
  cargo,
  rustc,
  # Generic args
  extraInputs ? [], # allow appending buildInputs
  ...
}: let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
  pname = cargoToml.package.name;
  version = cargoToml.package.version;
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = builtins.path {
      path = lib.sources.cleanSource ./.;
      name = "${pname}-${version}";
    };
    cargoLock = {
      lockFile = ./Cargo.lock;
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
    cargoBuildFlags = ["-p gh"];

    CARGO_BUILD_INCREMENTAL = "false";
    RUST_BACKTRACE = "full";

    meta = {
      description = "The gh plugin for Anyrun";
      homepage = "https://github.com/anyrun-org/anyrun";
      license = [lib.licenses.gpl3];
      maintainers = with lib.maintainers; [NotAShelf n3oney];
    };
  }
