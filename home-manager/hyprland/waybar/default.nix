{
  config,
  pkgs,
  lib,
  ...
}: let
  add_theme = file: pkgs.writeTextFile {
    text = "@theme \"${./rofi/mechabar-theme.rasi}\" \n" + builtins.readFile(file);
    name = "placeholder";
  };
  add_config = conf: script: "config=\"${add_theme conf}\"\n" + (builtins.readFile script);
  scripts = {
    cpu-temp = pkgs.writeShellApplication {
      name = "cpu-temp";
      text = builtins.readFile ./scripts/cpu-temp.sh;
      runtimeInputs = [pkgs.coreutils pkgs.lm_sensors];
    };
    brightness-control = pkgs.writeShellApplication {
      name = "brightness-control";
      text = builtins.readFile ./scripts/brightness-control.sh;
      runtimeInputs = [pkgs.brightnessctl pkgs.libnotify pkgs.coreutils];
    };
    bluetooth-menu = pkgs.writeShellApplication {
      checkPhase = "";
      name = "bluetooth-menu";
      text = add_config ./rofi/bluetooth-menu.rasi ./scripts/bluetooth-menu.sh;
      runtimeInputs = [pkgs.rofi pkgs.libnotify];
    };
    wifi-menu = pkgs.writeShellApplication {
      name = "wifi-menu";
      text = builtins.readFile ./scripts/wifi-menu.sh;
      runtimeInputs = [pkgs.rofi pkgs.libnotify];
    };
    volume-control = pkgs.writeShellApplication {
      checkPhase = "";
      name = "volume-control";
      text = builtins.readFile ./scripts/volume-control.sh;
      runtimeInputs = [pkgs.pulseaudioFull pkgs.libnotify pkgs.playerctl];
    };
    /*
       media-player = pkgs.writeShellApplication {
      name = "media-player";
      text = builtins.readFile ./scripts/media-player.py;
      runtimeInputs = [ pkgs.python3 pkgs.gobject-introspection pkgs.playerctl ];
    };
    */
    logout-menu = pkgs.writeShellApplication {
      checkPhase = "";
      name = "logout-menu";
      text = "config = ${./rofi/power-menu.rasi}" + (builtins.readFile ./scripts/power-menu.sh);
      runtimeInputs = [pkgs.rofi pkgs.hyprland pkgs.systemd];
    };
    cpu-usage = pkgs.writeShellApplication {
      name = "cpu-usage";
      text = builtins.readFile ./scripts/cpu-usage.sh;
      runtimeInputs = [];
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
          tooltip-format = "Discharging: {time}";
          tooltip-format-charging = "Charging: {time}";
        };
        bluetooth = {
          format = "󰂰";
          format-connected = "󰂱";
          format-connected-battery = "󰂱";
          format-disabled = "󰂲";
          interval = 1;
          max-length = 1;
          min-length = 1;
          on-click = "${scripts.bluetooth-menu}/bin/bluetooth-menu";
          on-click-right = "kitty --title '󰂯  Bluetooth TUI' bash -c bluetui";
          tooltip-format = "{num_connections} connected";
          tooltip-format-connected = "{num_connections} connected\n{device_enumerate}";
          tooltip-format-disabled = "Bluetooth Disabled";
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery = "{device_alias}: {device_battery_percentage}%";
        };
        "clock#date" = {
          actions = {
            on-click = "mode";
            on-click-right = "mode";
          };
          calendar = {
            format = {
              months = "<span color='#b4befe'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b>{}</b></span>";
              weekdays = "<span color='#a6adc8' font='7'>{}</span>";
            };
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
          tooltip-format = "Standard Time: {:%I:%M %p}";
        };
        "custom/backlight" = {
          exec = "${scripts.brightness-control}/bin/brightness-control";
          format = "{}";
          interval = 1;
          max-length = 6;
          min-length = 6;
          on-scroll-down = "${scripts.brightness-control}/bin/brightness-control -o d";
          on-scroll-up = "${scripts.brightness-control}/bin/brightness-control -o i";
          return-type = "json";
          tooltip = true;
        };
        "custom/cpu" = {
          exec = "${scripts.cpu-usage}/bin/cpu-usage";
          interval = 5;
          max-length = 6;
          min-length = 6;
          return-type = "json";
          tooltip = true;
        };
        "custom/cpuinfo" = {
          exec = "${scripts.cpu-temp}/bin/cpu-temp";
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
          #exec = "${scripts.media-player}/bin/media-player";
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
          on-click = "${scripts.logout-menu}/bin/logout-menu";
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
        "custom/wifi" = {
          exec = "${scripts.wifi-menu}/bin/wifi-menu";
          format = "{}";
          interval = 1;
          max-length = 1;
          min-length = 1;
          on-click = "${scripts.wifi-menu}/bin/wifi-menu";
          on-click-right = "kitty --title '󰤨  Network Manager TUI' bash -c nmtui";
          return-type = "json";
          tooltip = true;
        };
        "custom/ws" = {
          format = "  ";
          max-length = 3;
          min-length = 3;
          tooltip = false;
        };
        gtk-layer-shell = true;
        "hyprland/window" = {
          format = "{}";
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
        };
        "hyprland/workspaces" = {
          on-scroll-down = "hyprctl dispatch workspace +1";
          on-scroll-up = "hyprctl dispatch workspace -1";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
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
        modules-center = ["custom/paddc" "custom/left2" "custom/cpuinfo" "custom/left3" "memory" "custom/left4" "custom/cpu" "custom/leftin1" "custom/left5" "idle_inhibitor" "custom/right2" "custom/rightin1" "clock#time" "custom/right3" "clock#date" "custom/right4" "custom/wifi" "bluetooth" "custom/right5"];
        modules-left = ["custom/ws" "custom/left1" "hyprland/workspaces" "custom/right1" "custom/paddw" "hyprland/window"];
        modules-right = ["custom/media" "custom/left6" "pulseaudio" "custom/left7" "custom/backlight" "custom/left8" "battery" "custom/leftin2" "custom/power"];
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
          on-click = "${scripts.volume-control}/bin/volume-control -o m";
          on-scroll-down = "${scripts.volume-control}/bin/volume-control -o d";
          on-scroll-up = "${scripts.volume-control}/bin/volume-control -o i";
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
