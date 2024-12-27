{
  config,
  pkgs,
  lib,
  ...
}: let
  scripts = {
    bluetooth-control = pkgs.writeShellApplication {
      name = "bluetooth-control.sh";
      text = builtins.readFile ./scripts/bluetooth-control.sh;
    };
    brightnesscontrol = pkgs.writeShellApplication {
      name = "brighthness-control.sh";
      text = builtins.readFile ./scripts/brighthness-contorl.sh;
    };
    logout-menu = pkgs.writeShellApplication {
      name = "logout-menu.sh";
      runtimeInputs = with pkgs; [wlogout];
      text = builtins.readFile ./scripts/logout-menu.sh;
    };
    media-player = pkgs.writeShellApplication {
      name = "media-player.sh";
      text = builtins.readFile ./scripts/media-player.sh;
    };
    volume-control = pkgs.writeShellApplication {
      name = "volume-control.sh";
      text = builtins.readFile ./scripts/volume-control.sh;
    };
    wifi-menu = pkgs.writeShellApplication {
      name = "wifi-menu.sh";
      text = builtins.readFile ./scripts/wifi-menu.sh;
    };
    wifi-status = pkgs.writeShellApplication {
      name = "wifi-status.sh";
      text = builtins.readFile ./scripts/wifi-status.sh;
    };
  };
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        battery = {
          format = "{icon} {capacity}%";
          format-charging = "󱘖 {capacity}%";
          format-critical = "󱃍 {capacity}%";
          format-full = "󱃌 {capacity}%";
          format-icons = ["󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂"];
          format-warning = "󰁻 {capacity}%";
          interval = 1;
          max-length = 6;
          min-length = 6;
          states = {
            critical = 15;
            full = 100;
            good = 99;
            warning = 30;
          };
          tooltip-format = "Time to Empty: {time}";
          tooltip-format-charging = "Time to Full: {time}";
        };
        bluetooth = {
          format = "󰂰";
          format-connected = "󰂱";
          format-connected-battery = "󰂱";
          format-disabled = "󰂲";
          max-length = 1;
          min-length = 1;
          on-click = "blueman-manager";
          tooltip-format = "{num_connections} connected";
          tooltip-format-connected = "{num_connections} connected\n{device_enumerate}";
          tooltip-format-disabled = "Bluetooth Disabled";
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery = "{device_alias}: {device_battery_percentage}%";
        };
        "clock#date" = {
          actions = {on-click-right = "mode";};
          calendar = {
            format = {today = "<span color='#f38ba8'><b>{}</b></span>";};
            mode = "month";
            mode-mon-col = 6;
            on-click-right = "mode";
          };
          format = "󰨳 {:%m-%d}";
          max-length = 8;
          min-length = 8;
          tooltip-format = "<tt>{calendar}</tt>";
        };
        "clock#time" = {
          format = "󱑂 {:%H:%M}";
          max-length = 8;
          min-length = 8;
          tooltip = true;
          tooltip-format = "12-hour Format: {:%I:%M %p}";
        };
        "custom/backlight" = {
          # exec = scripts.brightnesscontrol;
          format = "{}";
          interval = 1;
          max-length = 6;
          min-length = 6;
          on-scroll-down = "~/.local/share/bin/brightnesscontrol.sh -o d";
          on-scroll-up = "~/.local/share/bin/brightnesscontrol.sh -o i";
          return-type = "json";
          tooltip = true;
        };
        "custom/cpu" = {
          # exec = scripts.cpuusage;
          interval = 5;
          max-length = 6;
          min-length = 6;
          return-type = "json";
          tooltip = true;
        };
        "custom/cpuinfo" = {
          # exec = scripts.cpuinfo;
          format = "{}";
          interval = 5;
          max-length = 8;
          min-length = 8;
          return-type = "json";
          tooltip = true;
        };
        "custom/left1" = {
          format = "";
          tooltip = false;
        };
        "custom/left2" = {
          format = "";
          tooltip = false;
        };
        "custom/left3" = {
          format = "";
          tooltip = false;
        };
        "custom/left4" = {
          format = "";
          tooltip = false;
        };
        "custom/left5" = {
          format = "";
          tooltip = false;
        };
        "custom/left6" = {
          format = "";
          tooltip = false;
        };
        "custom/left7" = {
          format = "";
          tooltip = false;
        };
        "custom/left8" = {
          format = "";
          tooltip = false;
        };
        "custom/leftin1" = {
          format = "";
          tooltip = false;
        };
        "custom/leftin2" = {
          format = "";
          tooltip = false;
        };
        "custom/media" = {
          # exec = scripts.mediaplayer;
          format = "{}";
          max-length = 35;
          min-length = 5;
          on-click = "playerctl play-pause";
          return-type = "json";
          tooltip = "{tooltip}";
        };
        "custom/paddc" = {
          format = " ";
          tooltip = false;
        };
        "custom/paddw" = {
          format = " ";
          tooltip = false;
        };
        "custom/power" = {
          format = " ";
          on-click = "~/.local/share/bin/logoutlaunch.sh 2";
          on-click-right = "~/.local/share/bin/logoutlaunch.sh 1";
          tooltip = false;
        };
        "custom/right1" = {
          format = "";
          tooltip = false;
        };
        "custom/right2" = {
          format = "";
          tooltip = false;
        };
        "custom/right3" = {
          format = "";
          tooltip = false;
        };
        "custom/right4" = {
          format = "";
          tooltip = false;
        };
        "custom/right5" = {
          format = "";
          tooltip = false;
        };
        "custom/rightin1" = {
          format = "";
          tooltip = false;
        };
        "custom/update" = {
          exec = "~/.local/share/bin/systemupdate.sh";
          format = "{}";
          interval = 60;
          max-length = 1;
          min-length = 1;
          on-click = "hyprctl dispatch exec 'systemupdate.sh up'";
          return-type = "json";
          signal = 20;
          tooltip = true;
        };
        "custom/wifi" = {
          # exec = scripts.wifiinfo;
          format = "{}";
          interval = 1;
          max-length = 1;
          min-length = 1;
          # on-click = scripts.wifimenu;
          on-click-right = "kitty bash -c nmtui";
          return-type = "json";
          tooltip = true;
        };
        "custom/ws" = {
          format = "  ";
          max-length = 3;
          min-length = 3;
          tooltip = false;
        };
        exclusive = true;
        gtk-layer-shell = true;
        "hyland/workspaces" = {
          active-only = false;
          all-outputs = false;
          disable-scroll = false;
          on-click = "activate";
          on-scroll-down = "hyprctl dispatch workspace +1";
          on-scroll-up = "hyprctl dispatch workspace -1";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
          sort-by-number = true;
        };
        "hyprland/window" = {
          format = "{}";
          max-length = 45;
          min-length = 5;
          rewrite = {
            "" = "<span foreground='#89b4fa'> </span> Hyprland";
            "(.*) - Godot Engine" = "<span foreground='#89b4fa'> </span> $1";
            "(.*) - VLC media player" = "<span foreground='#fab387'>󰕼 </span> $1";
            "(.*) - Visual Studio Code" = "<span foreground='#89b4fa'>󰨞 </span> $1";
            "(.*) — Mozilla Firefox" = "<span foreground='#f38ba8'>󰈹 </span> $1";
            "(.*).docx" = "<span foreground='#89b4fa'> </span> $1.docx";
            "(.*).jpg" = "  $1.jpg";
            "(.*).pdf" = "<span foreground='#f38ba8'> </span> $1.pdf";
            "(.*).png" = "  $1.png";
            "(.*).pptx" = "<span foreground='#fab387'> </span> $1.pptx";
            "(.*).svg" = "  $1.svg";
            "(.*).xlsx" = "<span foreground='#a6e3a1'> </span> $1.xlsx";
            "(.*)Discord(.*)" = "<span foreground='#89b4fa'> </span> $1Discord$2";
            "(.*)Mozilla Firefox" = "<span foreground='#f38ba8'>󰈹 </span> Firefox";
            "(.*)Spotify" = "<span foreground='#a6e3a1'> </span> Spotify";
            "(.*)Spotify Premium" = "<span foreground='#a6e3a1'> </span> Spotify Premium";
            "(.*)Visual Studio Code" = "<span foreground='#89b4fa'>󰨞 </span> Visual Studio Code";
            "(.*)sejjy@archlinux:~" = "  Terminal";
            "/" = "  File Manager";
            Authenticate = "  Authenticate";
            "GNU Image Manipulation Program" = "<span foreground='#a6adc8'> </span> GNU Image Manipulation Program";
            Godot = "<span foreground='#89b4fa'> </span> Godot Engine";
            "Godot Engine - (.*)" = "<span foreground='#89b4fa'> </span> $1";
            "OBS(.*)" = "<span foreground='#a6adc8'>󰐌 </span> OBS Studio";
            "ONLYOFFICE Desktop Editors" = "<span foreground='#f38ba8'> </span> OnlyOffice Desktop";
            Timeshift-gtk = "<span foreground='#a6e3a1'> </span> Timeshift";
            "VLC media player" = "<span foreground='#fab387'>󰕼 </span> VLC Media Player";
            kitty = "  Terminal";
            qView = "  qView";
            "sejjy@archlinux:(.*)" = "  Terminal";
            vesktop = "<span foreground='#89b4fa'> </span> Discord";
            zsh = "  Terminal";
            "~" = "  Terminal";
            "• Discord(.*)" = "Discord$1";
          };
          separate-outputs = true;
        };
        idle_inhibitor = {
          format = "󱄅 ";
          start-activated = false;
          timeout = 5;
          tooltip = true;
          tooltip-format-activated = "Presentation Mode";
          tooltip-format-deactivated = "Idle Mode";
        };
        layer = "top";
        memory = {
          format = "󰘚 {percentage}%";
          format-critical = "󰀦 {percentage}%";
          interval = 5;
          max-length = 7;
          min-length = 7;
          states = {
            critical = 90;
            warning = 75;
          };
          tooltip = true;
          tooltip-format = "Memory Used: {used:0.1f} GB / {total:0.1f} GB";
        };
        mode = "dock";
        modules-center = ["custom/paddc" "custom/left2" "custom/cpuinfo" "custom/left3" "memory" "custom/left4" "custom/cpu" "custom/leftin1" "custom/left5" "idle_inhibitor" "custom/right2" "custom/rightin1" "clock#time" "custom/right3" "clock#date" "custom/right4" "custom/wifi" "bluetooth" "custom/update" "custom/right5"];
        modules-left = ["custom/ws" "custom/left1" "hyprland/workspaces" "custom/right1" "custom/paddw" "hyprland/window"];
        modules-right = ["custom/media" "custom/left6" "pulseaudio" "custom/left7" "custom/backlight" "custom/left8" "battery" "custom/leftin2" "custom/power"];
        passthrough = false;
        position = "top";
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾"];
            headphone = "󰋋";
            headset = "󰋋";
          };
          format-muted = "󰝟 {volume}%";
          max-length = 6;
          min-length = 6;
          on-click = "~/.local/share/bin/volumecontrol.sh -o m";
          on-scroll-down = "~/.local/share/bin/volumecontrol.sh -o d";
          on-scroll-up = "~/.local/share/bin/volumecontrol.sh -o i";
          tooltip = true;
          tooltip-format = "Device: {desc}";
        };
        reload_style_on_change = true;
      };
    };
  };
  xdg.configFile = {
    "waybar/theme.css".source = ./theme.css;
  };
}
