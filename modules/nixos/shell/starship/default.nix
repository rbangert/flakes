inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.shell.starship;
in {
  options.rr-sv.shell.starship = with types; {
    enable = mkBoolOpt false "Whether or not to enable starship";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "\${custom.git_server_icon}"
            "$git_branch"
            "$git_status"
            "\${custom.nix_shell}"
            "$line_break"
            "$character"
          ];

          right_format = "$cmd_duration";

          character = {
            success_symbol = "[  ](blink fg:#9ece6a)";
            error_symbol = "[ ✖ ](fg:#ef596f)";
          };

          username = {
            style_user = "bold #6ec2e8";
            style_root = "bold #f74e27";
            format = "[$user]($style)@";
          };

          hostname = {
            style = "bold #6ec2e8";
            format = "[$sshsymbol$hostname]($style) ";
          };

          git_branch = {
            symbol = "";
            style = "bold #f74e27"; # git brand color
            format = "[$symbol$branch(:$remote_branch)]($style) ";
          };

          cmd_duration = {
            format = "[ $duration]($style)";
            style = "bold #586068";
          };

          time = {
            time_format = "%R";
            format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
            style = "bold  #1d2230";
          };

          directory = {read_only = " 󰌾";};

          custom = {
            git_server_icon = {
              description = "Show a GitLab or GitHub icon depending on current git remote";
              when = "git rev-parse --is-inside-work-tree 2> /dev/null";
              command = ''
                GIT_REMOTE=$(git ls-remote --get-url 2> /dev/null); if [[ "$GIT_REMOTE" =~ "github" ]]; then printf "\e[1;37m\e[0m"; elif [[ "$GIT_REMOTE" =~ "gitlab" ]]; then echo ""; else echo "󰊢"; fi'';
              shell = ["bash" "--noprofile" "--norc"];
              style = "bold #f74e27"; # git brand color
              format = "[$output]($style)  ";
            };

            nix_shell = {
              description = "Show an indicator when inside a Nix ephemeral shell";
              when = ''[ "$IN_NIX_SHELL" != "" ]'';
              shell = ["bash" "--noprofile" "--norc"];
              style = "bold #6ec2e8";
              format = "[ ]($style)";
            };
          };
        };
      };
    };
  };
}
