inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.hyprland;
in {
  options.rr-sv.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable hyprland";
  };

  config = mkIf cfg.enable {
    #TODO: Pull in the hyprland config file
    environment.systemPackages = with pkgs; [
      wlsunset
      wl-clipboard
      cliphist
      swaylock-effects
      swayidle
      grim
      gscreenshot
      ksnip
      slurp
      swaybg
      brightnessctl
      pamixer
      kitty
      polkit_gnome
      libva-utils
      fuseiso
      udiskie
      gnome.adwaita-icon-theme
      gnome.gnome-themes-extra
      gsettings-desktop-schemas
      swaynotificationcenter
      wlr-randr
      ydotool
      wl-clipboard
      hyprland-protocols
      hyprpicker
      swayidle
      swaylock
      xdg-desktop-portal-hyprland
      hyprpaper
      wofi
      firefox-wayland
      swww
      xdg-utils
      xdg-desktop-portal
      qt5.qtwayland
      qt6.qmake
      qt6.qtwayland
      adwaita-qt
      adwaita-qt6
    ];

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      };
    };

    security = {
      pam.services.swaylock = {
        text = ''
          auth include login
        '';
      };
    };

    boot.plymouth = {
      enable = true;
      themePackages = with pkgs; [rr-sv.catppuccin-plymouth];
      theme = "catppuccin-mocha";
    };

    services = {
      xserver = {
        enable = true;
        videoDrivers = ["displaylink" "modesetting"];
        excludePackages = [pkgs.xterm];
        libinput.enable = true;
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };
      };
      dbus.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
    };

    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
      };
    };

    rr-sv.home = {
      configFile."hypr/hyprland.conf".source = ../../../../config/hypr/hyprland.conf;
      extraOptions = {
        services = {
          dunst = {
            enable = true;
            iconTheme = {
              package = pkgs.gnome3.adwaita-icon-theme;
              name = "Adwaita";
              size = "32x32";
            };
          };
          #   # TODO config kanshi: hotswap monitor configs
          # kanshi =  {
          #   enable = true;
          #   extraConfig = ''
          #   '';
          #   profiles = ``
          #   ``;
          #   https://nix-community.github.io/home-manager/options.html#opt-services.kanshi.profiles
          # };
        };
        programs.swaylock = {
          enable = true;
          package = pkgs.swaylock-effects;
          settings = {
            screenshots = true;
            effect-blur = "20x3";
            effect-vignette = "0.6:0.6";
            fade-in = 0.1;
            clock = true;
            font = "JetBrainsMono Nerd Font";
            font-size = 15;
            grace = 15;

            line-uses-inside = true;
            disable-caps-lock-text = true;
            indicator-caps-lock = true;
            indicator-radius = 100;
            indicator-idle-visible = true;

            ring-color = "#3e4451";
            inside-wrong-color = "#e06c75";
            ring-wrong-color = "#e06c75";
            key-hl-color = "#98c379";
            bs-hl-color = "#e06c75";
            ring-ver-color = "#d19a66";
            inside-ver-color = "#d19a66";
            inside-color = "#353b45";
            text-color = "#c8ccd4";
            text-clear-color = "#353b45";
            text-ver-color = "#353b45";
            text-wrong-color = "#353b45";
            text-caps-lock-color = "#c8ccd4";
            inside-clear-color = "#56b6c2";
            ring-clear-color = "#56b6c2";
            inside-caps-lock-color = "#d19a66";
            ring-caps-lock-color = "#3e4451";
            separator-color = "#3e4451";
          };
        };
      };
    };
  };
}
