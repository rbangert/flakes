{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    home.file."${config.xdg.configHome}/hypr" = {
      source = ../../../../config/hypr;
      recursive = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      # extraConfig = ''
      #   exec-once = pypr
      # '';
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        extraCommands = [
          "systemctl --user stop hyprland-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
    };

    programs.hyprlock = { enable = true; };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ ",~/stuff/other/walls/digital/9py055cffwk71.png" ];
        wallpaper = [ ",~/stuff/other/walls/digital/9py055cffwk71.png" ];
      };
    };

    services.wlsunset = {
      enable = true;
      gamma = 0.6;
      latitude = 37.73;
      longitude = -119.57;
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
        config.common.default = "*";
      };
    };

    home.packages = with pkgs; [
      pyprland
      hypridle
      hyprlock
      hyprpaper
      polkit_gnome
      wl-clipboard
      cliphist
      grim
      gscreenshot
      slurp
      brightnessctl
      pamixer
      pavucontrol
      musikcube
      playerctl
      libva-utils
      udiskie
      gsettings-desktop-schemas
      wlr-randr
      ydotool
      hyprland-protocols
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-utils
      adwaita-qt
      adwaita-qt6
      gnome.adwaita-icon-theme
      gnome.gnome-themes-extra
      qt5.qtwayland
      qt6.qmake
      qt6.qtwayland
    ];
  };
}
