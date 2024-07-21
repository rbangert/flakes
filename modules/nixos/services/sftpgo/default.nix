{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.services.sftpgo;
in {
  options.${namespace}.services.sftpgo = {
    enable = mkEnableOption "sftpgo weather service";
  };

  config = mkIf cfg.enable {

    services.sftpgo = {
      enable = true;
      settings = {
        proxy_protocol = 1;
        proxy_allowed = [ "107.172.20.201" ];
        httpd.bindings = [{ port = 8888; }];
        webdavd.bindings = [{
          port = 888;
          proxy_allowed = [ "107.172.20.201" ];
        }];
      };
    };
  };
}
