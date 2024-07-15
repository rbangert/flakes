{ config
, lib
, namespace
, ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.tools.keybase;
in
{
  options.${namespace}.tools.keybase = with types; {
    enable = mkBoolOpt false "Whether or not to enable keybase.";
  };

  config = mkIf cfg.enable {
    services = {
      keybase.enable = true;
      kbfs = {
        enable = true;
        extraFlags = [ "-label kbfs" "-mount-type normal" ];
      };
    };
  };
}
