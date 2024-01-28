{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.suites.common;
in {
  options.rr-sv.suites.common = {enable = mkEnableOption "common";};
  config = mkIf cfg.enable {
    programs = {
      mtr.enable = true;
      fish.enable = true;
      gnupg.agent.enable = true;
      gnupg.agent.enableSSHSupport = true;
    };

    services.openssh.enable = true;

    sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    sops.age.generateKey = true;
    sops.age.keyFile = "/home/russ/.config/sops/age/keys.txt";

    environment = {
      defaultPackages = [];
      systemPackages = with pkgs; [
        ripgrep
        neovim
        bash
        htop
        ncdu
        fzf
        curl
        ps
        wget
        pass
        gnupg
        bat
        jq
        zip
        unzip
        git
        gh
        lazygit
        lazycli
        lazydocker
        docker-client
        teleport
        gum
        charm
        pkgs._1password
        rsync
        thefuck
        coreutils-full
      ];
    };
  };
}
