{pkgs, ...}: {
  imports = [
    ./rofi
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hyprpanel.nix
  ];

  home.packages = with pkgs; [
    hyprsunset
    easyeffects
    (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | wl-copy
    '')
    (writeShellScriptBin "screenshot-edit" ''
      wl-paste | ${swappy}/bin/swappy -f -
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
      general = {
        gaps_out = 0;
        "col.active_border" = "rgb(7287fd)";
        allow_tearing = true;
        layout = "dwindle";
      };

      input = {
        kb_layout = "de";
        kb_variant = "neo";
        kb_model = "p4104";
        kb_options = "terminate:ctrl_alt_bksp";

        follow_mouse = 2;
        repeat_delay = 220;
        repeat_rate = 45;
        accel_profile = "flat";
        touchpad = {
          natural_scroll = 1;
        };
      };

      windowrulev2 = [
        "monitor 1,class:^(deltachat-tauri)$"
        "fullscreenstate 0 0,class:^(deltachat-tauri)$"
        "tile,class:^(deltachat-tauri)$"
        "noinitialfocus,class:^(deltachat-tauri)$"
        "tile,class:^(sioyek)$"
        "workspace special:social,class:^(whatsapp-for-linux|org.telegram.desktop|signal|discord)$"
        "workspace special:social,title:^(WhatsApp Web)$"
        "workspace special:social,title:^(Delta Chat)$"
        "workspace special:obsidian,class:^(obsidian)$"
        "workspace special:calendar,class:^(org.gnome.Calendar)$"
        "workspace cs2,class:^(cs2)$"
        "immediate,class:^(cs2)$"
        "fullscreen,class:^(cs2)$"
        "size 574 50%,class:^(anki)$"
        "float,class:^(anki)$"
      ];

      decoration = {
        rounding = 4;
      };

      group = {
        groupbar = {
          "col.active" = "rgb(51576d)";
          "col.inactive" = "rgb(626880)";
          rounding = "5";
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
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
          "specialWorkspace,1,8,md3_decel,fade"
        ];
      };

      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        default_split_ratio = 1.0;
      };

      debug = {
        damage_tracking = 2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
        disable_logs = false;
      };

      opengl = {
        nvidia_anti_flicker = true;
      };

      binds = {
        hide_special_on_workspace_change = true;
      };

      render = {
        direct_scanout = 2;
      };

      misc = {
        vfr = true; # misc:no_vfr -> misc:vfr. bool, heavily recommended to leave at default on. Saves on CPU usage.
        vrr = 0; # misc:vrr -> Adaptive sync of your monitor. 0 (off), 1 (on), 2 (fullscreen only). Default 0 to avoid white flashes on select hardware.
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        animate_mouse_windowdragging = true;
        animate_manual_resizes = true;
        font_family = "JetBrainsMono Nerd Font";
        new_window_takes_over_fullscreen = true;
      };

      exec-once = let
        auto_close = pkgs.writeShellScriptBin "auto_close" ''
          function handle {
              if [[ ''${1:0:11} == "killactive" ]]; then
                  echo "Close Window detected"
                  if [[ 'hyprctl workspaces | grep "windows: 0"' ]]; then
                      echo "Empty workspace detected"
                      hyprctl dispatch workspace m 1
                      sleep 0.0001
                      hyprctl dispatch workspace 1
                  fi
              fi
          }
          ${pkgs.socat}/bin/socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
        '';
        set_wp = pkgs.writeShellScriptBin "set_wp" ''
          PICTURE_URI=$(gsettings get org.gnome.desktop.background picture-uri)
          PICTURE_PATH=$(echo "$PICTURE_URI" | sed -E "s/^'file:\/\/(.*)'$/\1/")
          hyprctl hyprpaper preload "$PICTURE_PATH"
          hyprctl hyprpaper wallpaper ",$PICTURE_PATH"
          echo "Wallpaper set to: $PICTURE_PATH"
        '';
        autostart = pkgs.writeShellScriptBin "autostart" ''
          pkill hyprswitch
          hyprswitch init --show-title --size-factor 3.5 --workspaces-per-row 5 &
          pkill hyprsunset
          hyprsunset -t 5000 &
          hyprctl setcursor "Bibata-Original-Ice" 20
          gnome-keyring-daemon --start --components=secrets,ssh
          eval $(ssh-agent)
        '';
      in [
        "${autostart}/bin/autostart"
        "${set_wp}/bin/set_wp"
        "${auto_close}/bin/auto_close"
        "${import ./dynamic-borders.nix {inherit pkgs;}}/bin/auto_borders"
        "[workspace special obsidian silent] obsidian"
        # "[workspace special social silent] whatsapp-for-linux"
        "[workspace special social silent] deltachat"
        # "[workspace special calendar silent] gnome-calendar"
      ];

      bind = [
        # Window controls
        "SUPER,Q,killactive"
        "SUPER SHIFT,Q,forcekillactive"
        # "SUPER SHIFT,Q,killwindow,activewindow"
        "SUPER,g,togglegroup"
        "SUPER,y,changegroupactive"
        "SUPER,m,fullscreen"
        "SUPER,p,pin"
        "SUPER,c,centerwindow"
        "SUPER,l,exec,hyprlock"
        "SUPER,s,togglespecialworkspace,social"
        "SUPER,o,togglespecialworkspace,obsidian"
        "SUPER,k,togglespecialworkspace,calendar"

        # Start programs
        "SUPER,RETURN,exec,kitty /home/septias/coding"
        ",Print,exec,screenshot"
        "SUPER,i,exec,screenshot"
        "SUPER,Print,exec,screenshot-edit"
        "SUPER SHIFT,s,exec,google-chrome-stable"
        "SUPER,space,exec,anyrun"
        "SUPER,e,exec,nautilus"
        "SUPER,f,exec,hyprswitch gui --mod-key super --key tab"
        "SUPER SHIFT,f,togglefloating"
        "SUPER,c,exec, xdg-open https://chatgpt.com"

        # Focus windows
        "SUPER, b, focuswindow, class:google-chrome"

        # Move focus
        "SUPER,r,workspace,-1"
        "SUPER,t,workspace,+1"
        "SUPER,n,cyclenext"
        "SUPER,d,focusmonitor,+1"
        "SUPER SHIFT,d,movewindow,mon:+1"
        "SUPER,z,focuscurrentorlast"

        # Move window
        "SUPER ALT, t, movetoworkspace, +1"
        "SUPER ALT, r, movetoworkspace, -1"

        # Misc
        "SUPER SHIFT, t, exec, hyprpanel t bar-0 & hyprpanel t bar-1"
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
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl prev"
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
