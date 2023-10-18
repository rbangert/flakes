{ inputs
, lib
, pkgs
, ...
}:
with lib;
with lib.rr-sv; {
  imports = [ ./hardware.nix ];

  rr-sv = { 
