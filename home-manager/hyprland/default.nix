{pkgs, ...}: {
  imports = [
    ./waybar
    ./rofi
  ];
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
        preload = ["~/coding/nixos-config/home-manager/mask.jpeg"];
        wallpaper = ", ~/coding/nixos-config/home-manager/mask.jpeg";
      };
    };
    hypridle = {
      enable = true;
      settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
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
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      auth = {
        "fingerprint:enabled" = true;
      };

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          dots_size = 0.2;
          dots_spacing = 0.6;
          font_color = "rgb(198, 208, 245)";
          inner_color = "rgb(48, 52, 70)";
          outer_color = "rgb(131, 139, 167)";
          check_color = "rgb(48, 52, 70)";
          fail_color = "rgb(231, 130, 132)";
          outline_thickness = 2;
          placeholder_text = "•`_´•";
          shadow_passes = 2;
        }
      ];
    };
  };
  home.packages = with pkgs; [
    hyprsunset
    easyeffects
    (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | wl-copy
    '')
    (writeShellScriptBin "screenshot-edit" ''
      wl-paste | ${swappy}/bin/swappy -f -
    '')
    (writeShellScriptBin "autostart" ''
      # Variables
      config=$HOME/.config/hypr

      # Dunst (Notifications)
      pkill dunst
      dunst &

      pkill hyprsunset
      hyprsunset -t 5000 &
      hyprctl setcursor "Bibata-Original-Ice" 20
    '')
  ];
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
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

      decoration = {
        rounding = 12;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever= true;
      };
      
      animations = {
        enabled = true;
        bezier = [
          "pace, 0.46, 1, 0.29, 0.99"
          "overshot, 0.13, 0.99, 0.29, 1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "windowsIn,1,2,md3_decel,slide"
          "windowsOut,1,3,md3_decel,slide"
          "windowsMove,1,3,md3_decel,slide"
          "fade,1,6,md3_decel"
          "workspaces,1,9,md3_decel,slide"
          "workspaces,1,6,default"
          "specialWorkspace,1,8,md3_decel,slide"
          "border,1,10,md3_decel"
        ];
      };
      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        default_split_ratio = 1.0;
      };

      debug = {
        damage_tracking = 2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
      };

      opengl = {
        nvidia_anti_flicker = true;
      };

      misc = {
        vfr = true; # misc:no_vfr -> misc:vfr. bool, heavily recommended to leave at default on. Saves on CPU usage.
        vrr = 0; # misc:vrr -> Adaptive sync of your monitor. 0 (off), 1 (on), 2 (fullscreen only). Default 0 to avoid white flashes on select hardware.
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        animate_mouse_windowdragging = true;
      };

      exec-once = [
        "autostart"
        "easyeffects --gapplication-service" # Starts easyeffects in the background
      ];

      bind = [
        "SUPER,Q,killactive,"
        "SUPER,f,togglefloating,"
        "SUPER,g,togglegroup"
        "SUPER,m,fullscreen"
        "SUPER,p,pin"
        "SUPER,c,centerwindow"
        "SUPER,l,exec, hyprlock"

        # Move focus
        "SUPER,r,workspace,-1"
        "SUPER,t,workspace,+1"
        "SUPER,n,cyclenext"
        "SUPER,d,movefocus,r"

        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"

        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"

        # Move window
        "SUPER ALT, t, movetoworkspace, +1"
        "SUPER ALT, r, movetoworkspace, -1"
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

        # Start programs
        "SUPER,RETURN, exec, kitty"
        ",Print, exec, screenshot"
        "SUPER, Print, exec, screenshot-edit"
        "SUPER, o, exec, obsidian"
        "SUPER SHIFT, s, exec, google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "SUPER,space, exec, rofi -show run"

        # Focus windows
        "SUPER, s, focuswindow, chrome"
      ];

      bindm = [
        "ALT, mouse:272, movewindow"
        "ALT, mouse:273, resizewindow"
      ];

      bindle = [
        # Backlight Keys
        ",XF86MonBrightnessUp,exec, ${pkgs.brightnessctl}/bin/brightnessctl set +10%"
        ",XF86MonBrightnessDown,exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
        # Volume Keys
        ",XF86AudioRaiseVolume,exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        ",XF86AudioLowerVolume,exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ];
    };

    extraConfig = ''
      env = XDG_SESSION_TYPE,wayland
      env = WLR_NO_HARDWARE_CURSORS,1
      env = NIXOS_OZONE_WL,1
      env = QT_QPA_PLATFORMTHEME,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    '';
  };
}
