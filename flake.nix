{
  description = "TimeKeeper";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
    systems = {
      url = "github:nix-systems/default";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems = import inputs.systems;
      perSystem = { self', pkgs, system, ... }:
        let
          cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
          rust-toolchain =
            pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;

          buildDeps = with pkgs; [
            libGL
            (lib.getLib gcc-unwrapped)
            xorg.libX11
            xorg.libXrandr
            xorg.libXinerama
            xorg.libXcursor
            xorg.libXi
            libxkbcommon
            stdenv.cc.libc_bin
            pkg-config
            clang
            cmake
            coreutils
            bashInteractive
            clang
            wayland
            glfw
            nil
            nixd
          ];

          mkPackage = rust-toolchain:
            pkgs.rustPlatform.buildRustPackage {
              inherit (cargoToml.package) version;
              pname = "timekeeper";
              src = ./.;
              buildInputs = buildDeps;
              nativeBuildInputs = buildDeps ++ [ rust-toolchain ];
              cargoLock.lockFile = ./Cargo.lock;
              meta = {
                description =
                  "A Rusty program to record project log with timestamps in csv";
                license = pkgs.lib.licenses.agpl3Plus;
              };
            };

          mkDevShell = rust-toolchain:
            pkgs.mkShell {
              LD_LIBRARY_PATH =
                "${pkgs.lib.makeLibraryPath buildDeps}:$LD_LIBRARY_PATH";
              packages = buildDeps ++ [ rust-toolchain ];
            };
        in {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ (import inputs.rust-overlay) ];
          };

          formatter = pkgs.alejandra;

          packages.default = mkPackage rust-toolchain;

          devShells.default = self'.devShells.msrv;
          devShells.msrv = mkDevShell rust-toolchain;
          devShells.stable = mkDevShell pkgs.rust-bin.stable.latest.default;
          devShells.nightly = mkDevShell (pkgs.rust-bin.selectLatestNightlyWith
            (toolchain: toolchain.default));
        };
    };
}
