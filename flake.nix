{
  description = "My system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      darwinConfigurations.Ya = darwin.lib.darwinSystem {
        inherit system;
        inherit pkgs;

        modules = [
          {
            services.nix-daemon.enable = true;
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            imports = [ ./darwin.nix ];
          }

          home-manager.darwinModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.polle = {
                imports = [ ./home.nix ];
              };
            };
          }
        ];
      };
    };
}
