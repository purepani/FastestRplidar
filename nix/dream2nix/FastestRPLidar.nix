{
  config,
  lib,
  dream2nix,
  ...
}: {
  imports = [
    #dream2nix.modules.dream2nix.WIP-python-pdm
    dream2nix.modules.dream2nix.pip
    #dream2nix.modules.dream2nix.WIP-python-pyproject
  ];

  name = "FastestRPLidar";
  version = "0.1.0";
  deps = {
    inputs,
    cell,
    nixpkgs,
    ...
  }: {
    python = nixpkgs.python39;
    inherit (nixpkgs) swig;
    inherit cell;
    inherit inputs;
    inherit nixpkgs;
  };
  #pdm = {
  #  lockfile = ../../pdm.lock;
  #  pdm.pyproject = ../../pyproject.toml;
  #  pdm.pythonInterpreter = config.deps.python;
  #};
  buildPythonPackage = {
    format = lib.mkForce "pyprojecct";
    pythonImportsCheck = [
      "fastestrplidar"
    ];
  };
  paths = {
    projectRoot = /home/satwik/projects/FastestRplidar;
    package = ./FastestRPLidar;
  };
  mkDerivation = {
    src = /home/satwik/projects/FastestRplidar/FastestRPLidar;
    #buildInputs = [config.deps.python.pkgs.setuptools];
    nativeBuildInputs = [config.deps.nixpkgs.swig config.deps.inputs.setuptools];
    propagatedBuildInputs = [config.deps.inputs.cells.rplidar_sdk.package];
    preConfigure = ''
      cp ${config.deps.inputs.cells.rplidar_sdk.package}/bin/libsl_lidar_sdk.a fastestrplidar/librplidar_sdk.a
      ${config.deps.nixpkgs.swig}/bin/swig -c++ -python fastestrplidar/fastestrplidar.i
      cd fastestrplidar
      ${config.deps.python}/bin/python setup.py build_ext --inplace
      cd ..
    '';
  };

  pip = {
    requirementsList = [
      "/home/satwik/projects/FastestRplidar/FastestRPLidar"
      #"setuptools"
    ];
    #flattenDependencies = true;
  };
}
