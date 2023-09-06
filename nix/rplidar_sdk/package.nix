{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs;
  source = inputs.rplidar_sdk;
in
  pkgs.stdenv.mkDerivation rec {
    pname = "rplidar_sdk";
    version = "2.0.0";

    src = source;
    nativeBuildInputs = [
      #pkgs.gnumake
      pkgs.gccMultiStdenv
    ];

    #configurePhase = ''
    #  cmake .
    #'';

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv output/Linux/Release/libsl_lidar_sdk.a $out/bin
    '';
  }
