{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    mach-nix.url = "github:DavHau/mach-nix";

    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db";
      flake = false;
    };
    mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";

    std.url = "github:divnix/std";
    std.inputs.devshell.url = "github:numtide/devshell";
    rplidar_sdk = {
      url = "github:Slamtec/rplidar_sdk";
      flake = false;
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        # Development Environments
        (nixago "configs")
        (devshells "shells")
        #(functions "FastestRplidar")
        (installables "package")
      ];
    }
    {
      devShells = std.harvest inputs.self ["repo" "shells"];
    }
    {
      packages = std.harvest inputs.self ["FastestRplidar" "package"];
    };
}
