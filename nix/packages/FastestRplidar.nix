let
  pkgs = inputs.nixpkgs;
  mach-nix = import inputs.mach-nix {
    inherit pkgs;
    python = "python39";
  };
in
  mach-nix.buildPythonPackage {
    src = "${inputs.self}/FastestRPLidar";
    nativeBuildInputs = [pkgs.swig4 pkgs.gccMultiStdenv cell.package.rplidar_sdk];
    #buildInputs = [pkgs.python310];
    preConfigure = ''
      cp ${cell.package.rplidar_sdk}/bin/libsl_lidar_sdk.a fastestrplidar/librplidar_sdk.a
      ${pkgs.swig4}/bin/swig -c++ -python fastestrplidar/fastestrplidar.i
      ${pkgs.python39}/bin/python setup.py build_ext --inplace
    '';
  }
#inputs.dream2nix.lib.importPackages {
#projectRoot = inputs.self;
#projectRootFile = "${inputs.self}/flake.nix";
#packagesDir = "${inputs.cells.dream2nix.dreamModules}";
#packageSets = {
#nixpkgs = pkgs;
#inherit inputs cell;
#};
#}
#inputs.dream2nix.lib.evalModules {
#  packageSets = {
#    inherit (inputs) nixpkgs;
#    inherit inputs cell;
#    #python = inputs.nixpkgs.python39;
#  };
#  modules = [
#    inputs.cells.dream2nix.dreamModules.FastestRPLidar
#  ];
#}

