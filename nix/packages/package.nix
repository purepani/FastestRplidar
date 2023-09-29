{
  inputs,
  cell,
}:
inputs.std.findTargets {
  inherit inputs cell;
  block = ./.;
}
