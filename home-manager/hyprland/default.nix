{
  pkgs,
  ...
}: {
  #gsettings = "${pkgs.glib}/bin/gsettings";{
  imports = [
    ./gtk
    ./swww
    ./waybar
    ./wofi
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  home.packages = with pkgs; [
    grim # Grab images from a Wayland compositor
    slurp # Select a region in a Wayland compositor
    swappy # A Wayland native snapshot editing tool, inspired by Snappy on macOS
    easyeffects

    (writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" - | wl-copy
    '')
    (writeShellScriptBin "screenshot-edit" ''
      wl-paste | swappy -f -
    '')
    (writeShellScriptBin "autostart" ''
      # Variables
      config=$HOME/.config/hypr
      scripts=$config/scripts

      # Waybar
      pkill waybar
      $scripts/launch_waybar

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
        gaps_in = 1;
        gaps_out = 2;
        border_size = 3;
        layout = "dwindle";
        apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };

      decoration = {
        rounding = 12;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 1.3;
          brightness = 1;
          xray = true;
        };
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
        new_is_master = true;
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
        "SUPER,t,movefocus,r"
        "SUPER,r,movefocus,l"
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
      # bindle = [
      #     # Backlight Keys
      #     ",XF86MonBrightnessUp,exec,light -A 5"
      #     ",XF86MonBrightnessDown,exec,light -U 5"
      #     # Volume Keys
      #     ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%  "
      #     ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%  "
      # ];

      windowrule = [
        "tile,title:^(kitty)$"
        "float,title:^(fly_is_kitty)$"
      ];
    };
    # extraConfig = [
    #        env = GBM_BACKEND,nvidia-drm
    #        env = LIBVA_DRIVER_NAME,nvidia
    #        env = XDG_SESSION_TYPE,wayland
    #        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    #        env = WLR_NO_HARDWARE_CURSORS,1
    # ];
  };
  # Hyprland configuration files
  xdg.configFile = {
    "hypr/store/dynamic_out.txt".source = ./store/dynamic_out.txt;
    "hypr/store/prev.txt".source = ./store/prev.txt;
    "hypr/store/latest_notif".source = ./store/latest_notif;
    "hypr/scripts/wall".source = ./scripts/wall;
    "hypr/scripts/launch_waybar".source = ./scripts/launch_waybar;
    "hypr/scripts/tools/dynamic".source = ./scripts/tools/dynamic;
    "hypr/scripts/tools/expand".source = ./scripts/tools/expand;
    "hypr/scripts/tools/notif".source = ./scripts/tools/notif;
    "hypr/scripts/tools/start_dyn".source = ./scripts/tools/start_dyn;
  };
}
