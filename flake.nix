{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
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
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    devShells =
      forEachSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ({
              pkgs,
              config,
              ...
            }: {
              # https://devenv.sh/reference/options/
              packages = with pkgs; [
                pkgs.hello
                pkgs.swig
                pkgs.gccMultiStdenv
                binutils
                zlib
                glib
                stdenv.cc.cc.lib
                pam
                #swig
                gcc
              ];
              languages.python = {
                enable = true;
                package = pkgs.python310;
                venv.enable = true;
              };
              enterShell = ''
                hello
              '';

              env.LD_LIBRARY_PATH = config.devenv.dotfile + "/profile/lib";
            })
          ];
        };
      });
  };
}
