{ config
, pkgs
, lib
, inputs
, ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.nix.remote-build;
in
{
  options.rr-sv.nix.remote-build = with types; {
    enable = mkBoolOpt true "Whether or not to manage nixos remote-build configuration.";
  };

  config = mkIf cfg.enable {
    nix.distributedBuilds = true;
    nix.buildMachines = [
      {
        hostName = "algol";
        systems = [ "x86_64-linux" "aarch64-linux" ];
        maxJobs = 4;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
    programs.ssh.extraConfig = ''

