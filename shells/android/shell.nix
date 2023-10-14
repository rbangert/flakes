
{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
      name = "calyxos-device-flashing";
}).env
