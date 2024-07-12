{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.zsh;
in {
  options.${namespace}.cli-apps.zsh = {
    enable = mkEnableOption "zsh shell";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      history.path = "$XDG_CACHE_HOME/zsh.history";
      autocd = true;
      dotDir = ".config/zsh";

      initExtra = ''
        # Fix an issue with tmux.
        export KEYTIMEOUT=1

        export EDITOR=nvim

        # Use vim bindings.
        set -o vi

        # Improved vim bindings.
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        eval "$(starship init zsh)"
        eval "$(direnv hook zsh)"

        export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      '';

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "82ca15e638cc208e6d8368e34a1625ed75e08f90";
            hash = "sha256-Rtg8kWVLhXRuD2/Ctbtgz9MQCtKZOLpAIdommZhXKdE=";
          };
        }
      ];

      # TODO add zsh aliases
      shellAliases = {
        cat = "bat";
        l = "eza --icons -alG --group-directories-first --git";
        ls = "eza -F";
        la = "eza -la";
        rm = "rm -i";
        mv = "mv -i";
        cp = "cp -i";
        im = "nvim";
        grep = "grep --color=auto";
        neofetch = "disfetch";
        fetch = "disfetch";
        gitfetch = "onefetch";

        # git
        gc = "git clone";
        ga = "git add *";
        cm = "git commit -m";
      };
    };

    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "rg --files --hidden --follow";
        defaultOptions = ["-m --bind ctrl-a:select-all,ctrl-d:deselect-all"];
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      bat = {
        enable = true;
      };
    };
  };
}
