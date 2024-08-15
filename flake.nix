{
  description = "template-purescript-node";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    garnix-lib.url = "github:garnix-io/garnix-lib";
    flake-utils.url = "github:numtide/flake-utils";
    purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
    spago2nix.url = "github:justinwoo/spago2nix";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import "${inputs.nixpkgs}" {
            inherit system;
            overlays = [
              inputs.purescript-overlay.overlays.default
            ];
          };
        in
        {
          # Here you can define packages that your flake outputs.
          packages = {
            # Import ./backend/default.nix, which defines the nix package
            # that builds the Purescript backend.
            backend = pkgs.callPackage ./backend { };
          };
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              inputs.spago2nix.packages."${system}".spago2nix
              nodejs
              purs
              spago
              purs-tidy
              purs-backend-es
              purescript-language-server
            ];
          };
        }) //
    {
      # Define the configuration for the 'server'.
      nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.garnix-lib.nixosModules.garnix

          {
            _module.args = { self = inputs.self; };
          }
          # This is where the work happens
          ./hosts/server.nix
        ];
      };
    };
}
