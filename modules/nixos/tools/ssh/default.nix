
{
  config,
    lib,
    pkgs,
    ...
}:
with lib;
with lib.rr-sv; let
cfg = config.rr-sv.tools.ssh;
# configFiles = lib.snowfall.fs.get-files ../../../../config/ssh;


in {
  options.rr-sv.tools.ssh = with types; {
    enable = mkBoolOpt false "Whether or not to enable ssh.";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      extraConfig = ''
        Host devvm
        HostName devvm
        User russ
        ForwardAgent yes

        Host 10.0.0.32
        HostName 10.0.0.32
        User russ
        ForwardAgent yes

        Host algol
        HostName algol
        User russ
        ForwardAgent yes

        Host rr-sv
        HostName rr-sv
        User russ
        ForwardAgent yes
        '';
    };
  };
}
