{ config, lib, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.nfs;
in
{
  options.rr-sv.services.nfs = with types; {
    enable = mkBoolOpt false "Whether or not to enable nfs";
  };

  config = mkIf cfg.enable {
    services.nfs.enable = true;
    services.nfs.exports = [
      { path = "/srv/nfs"; fsid = "0"; options = "rw,fsid=0"; }
    ];
