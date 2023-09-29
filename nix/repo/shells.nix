/*
This file holds reproducible shells with commands in them.

They conveniently also generate config files in their startup hook.
*/
{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib;
in {
  default = inputs.devenv.lib.mkShell {
    inherit inputs;
    pkgs = inputs.nixpkgs;
    modules = [
      ({
        pkgs,
        config,
        ...
      }: {
        packages = with pkgs; [
        ];
        languages.python = {
          enable = true;
          package = pkgs.python39.withPackages (ps: [inputs.cells.packages.package.FastestRplidar]);
        };
      })
    ];
  };
}
