{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.user;
  defaultIconFileName = "profile.jpg";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {fileName = defaultIconFileName;};
  };
  propagatedIcon =
    pkgs.runCommandNoCC "propagated-icon"
    {passthru = {fileName = cfg.icon.fileName;};}
    ''
      local target="$out/share/rr-sv-icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
in {
  options.${namespace}.user = with types; {
    name = mkOpt str "russ" "The name to use for the user account.";
    fullName = mkOpt str "Russell Bangert" "The full name of the user.";
    email = mkOpt str "russ@rr-sv.win" "The email of the user.";
    initialPassword = mkOpt str "omgrus/* s */b" "The initial password to use when the user is first created.";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) ["libvirtd" "wheel" "audio" "docker" "podman" "input" "networkmanager" "code-server"] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      propagatedIcon
    ];

    programs.zsh.enable = true;

    rr-sv.home = {
      file = {
        "Desktop/.keep".text = "";
        "Documents/.keep".text = "";
        "Downloads/.keep".text = "";
        "Music/.keep".text = "";
        "Pictures/.keep".text = "";
        "Videos/.keep".text = "";
        "work/.keep".text = "";
        ".face".source = cfg.icon;
        "Pictures/${
          cfg.icon.fileName or (builtins.baseNameOf cfg.icon)
        }".source =
          cfg.icon;
      };

      extraOptions = {
        xdg.userDirs = {
          enable = true;
          documents = "$HOME/stuff/other/";
          download = "$HOME/stuff/other/";
          videos = "$HOME/stuff/other/";
          music = "$HOME/stuff/music/";
          pictures = "$HOME/stuff/pictures/";
          desktop = "$HOME/stuff/desktop/";
          publicShare = "$HOME/stuff/";
        };
      };
    };

    users.users.${cfg.name} =
      {
        isNormalUser = true;
        # inherit (cfg) name initialPassword;
        home = "/home/${cfg.name}";
        group = "users";
        shell = pkgs.zsh;
        extraGroups = ["wheel"] ++ cfg.extraGroups;
      }
      // cfg.extraOptions;
  };
}
