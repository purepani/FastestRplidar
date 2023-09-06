{
  inputs,
  cell,
}: let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs;
in {
  default = inputs.mach-nix.lib."${system}".buildPythonPackage {
    src = inputs.self;
    nativeBuildInputs = [pkgs.swig4 pkgs.gccMultiStdenv inputs.cells.rplidar_sdk.package];
    buildInputs = [pkgs.python310];
    preConfigure = ''
      cp ${inputs.cells.rplidar_sdk.package}/bin/libsl_lidar_sdk.a librplidar_sdk.a
      ${pkgs.swig4}/bin/swig -c++ -python fastestrplidar.i
      ls
      ${pkgs.python310}/bin/python setup.py build_ext --inplace
    '';
  };
}
