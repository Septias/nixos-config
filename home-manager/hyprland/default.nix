{pkgs, ...}: {


  home.packages = with pkgs; [
    /*
    easyeffects
    pamixer
    playerctl
    pavucontrol */

    # pipewire
    # wireplumber
    # playerctl 
    # brightnessctl 
    # networkmanager
    # wlogout
    # rofi-wayland
    
    (writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" - | wl-copy
    '')
    (writeShellScriptBin "screenshot-edit" ''
      wl-paste | swappy -f -
    '')
    (writeShellScriptBin "autostart" ''
      # Variables
      config=$HOME/.config/hypr

      # Waybar
      pkill waybar

      # Wallpaper
      swww kill
      swww init

      # Dunst (Notifications)
      pkill dunst
      dunst &

      # Cursor
      # gsettings set org.gnome.desktop.interface cursor-theme "Catppuccin-Frappe-Sky-Cursors"
      # gsettings set org.gnome.desktop.interface cursor-size 30
      # hyprctl setcursor "Catppuccin-Mocha-Mauve-Cursors" 30
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland = {
      enable = true;
    };
    settings = {
      "$mainMod" = "SUPER";

      input = {
        kb_layout = "de";
        kb_variant = "neo";
        kb_model = "p4104";
        kb_options = "terminate:ctrl_alt_bksp";
        kb_rules = "";

        follow_mouse = 1;
        repeat_delay = 400;
        repeat_rate = 25;
        accel_profile = "flat";
        sensitivity = 0;
        force_no_accel = 1;
        touchpad = {
          natural_scroll = 1;
        };
      };

      general = {
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
      };

      animations = {
        enabled = true;
        bezier = [
          "pace,0.46, 1, 0.29, 0.99"
          "overshot,0.13,0.99,0.29,1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "windowsIn,1,6,md3_decel,slide"
          "windowsOut,1,6,md3_decel,slide"
          "windowsMove,1,6,md3_decel,slide"
          "fade,1,10,md3_decel"
          "workspaces,1,9,md3_decel,slide"
          "workspaces, 1, 6, default"
          "specialWorkspace,1,8,md3_decel,slide"
          "border,1,10,md3_decel"
        ];
      };

      misc = {
        vfr = true; # misc:no_vfr -> misc:vfr. bool, heavily recommended to leave at default on. Saves on CPU usage.
        vrr = 0; # misc:vrr -> Adaptive sync of your monitor. 0 (off), 1 (on), 2 (fullscreen only). Default 0 to avoid white flashes on select hardware.
      };

      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        default_split_ratio = 1.0;
      };

      master = {
        no_gaps_when_only = false;
      };

      debug = {
        damage_tracking = 2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
      };

      exec-once = [
        "autostart"
        "easyeffects --gapplication-service" # Starts easyeffects in the background
      ];

      bind = [
        "SUPER,Q,killactive,"
        "SUPER,S,togglefloating,"
        "SUPER,g,togglegroup"

        # Move focus
        "SUPER,t,workspace,+1"
        "SUPER,r,workspace,-1"
        "SUPER,left,movefocus,l"
        "SUPER,down,movefocus,d"
        "SUPER,up,movefocus,u"
        "SUPER,right,movefocus,r"

        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"

        # Move window
        "SUPER ALT, t, movewindow, r"
        "SUPER ALT, r, movewindow, l"
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"

        "SUPER $mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER $mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER $mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER $mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER $mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER $mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER $mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER $mainMod SHIFT, 8, movetoworkspacesilent, 8"

        "SUPER,RETURN,exec,kitty"
        ",Print,exec,screenshot"
        "SUPER,Print,exec,screenshot-edit"
        "SUPER,o,exec,obsidian"
        "SUPER SHIFT,C,exec,wallpaper"
        "SUPER,z,exec,waybar"
        "SUPER,space,exec,wofi --show drun -I -s ~/.config/wofi/style.css DP-3"
      ];

      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
      bindle = [
        # Backlight Keys
        ",XF86MonBrightnessUp,exec,light -A 5"
        ",XF86MonBrightnessDown,exec,light -U 5"
        # Volume Keys
        ",XF86AudioRaiseVolume,exec, pamixer -i 5"
        ",XF86AudioLowerVolume,exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ",pactl set-sink-volume @DEFAULT_SINK@ -5% d "
        ",pactl set-sink-volume @DEFAULT_SINK@ -5% d "
      ];

      windowrule = [
      ];
    };

    extraConfig = ''
      env = XDG_SESSION_TYPE,wayland
      env = WLR_NO_HARDWARE_CURSORS,1
      env = NIXOS_OZONE_WL,1
    '';

    # env = GBM_BACKEND,nvidia-drm
    # env = LIBVA_DRIVER_NAME,nvidia
    # env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  };
  # Hyprland configuration files
  xdg.configFile = {
  };
}
