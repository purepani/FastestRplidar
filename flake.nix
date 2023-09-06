{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    mach-nix.url = "github:DavHau/mach-nix";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    mach-nix,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    fastestrplidar_drv = system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      mach-nix.lib."${system}".buildPythonPackage {
        src = ./.;
        nativeBuildInputs = [pkgs.swig4 pkgs.gccMultiStdenv];
        buildInputs = [pkgs.python3 ];
        preConfigure = ''
          ${pkgs.swig4}/bin/swig -c++ -python fastestrplidar.i
          ls
          ${pkgs.python3}/bin/python setup.py build_ext --inplace
        '';
        postInstall = ''
          ls
          ls $out
        '';
      };
  in {
    devShells =
      forEachSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = mach-nix.lib.${system}.mkPythonShell {packagesExtra = [(fastestrplidar_drv system)];};
      });
    packages = forEachSystem (system: {default = fastestrplidar_drv system;});
  };
}
