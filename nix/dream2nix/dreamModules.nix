{
  inputs,
  cell,
}:
inputs.std.findTargets {
  #inherit (inputs) dream2nix;
  inherit inputs cell;
  block = ./.;
}
