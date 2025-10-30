{
  config,
  pkgs,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    environmentVariables = {
      CHATMAIL_DOMAIN = "\"ci-chatmail.testrun.org\"";
      HANDLER = "copilot";
    };
    extraConfig = ''
      $env.COPILOT_API_KEY = (open ${config.sops.secrets.copilot.path} | str trim)
      $env.CACHIX_AUTH_TOKEN = (open ${config.sops.secrets.cachix.path} | str trim)
      $env.OPENROUTER_API_KEY = (open ${config.sops.secrets.openrouter.path} | str trim)
      $env.OPENAI_API_KEY = (open ${config.sops.secrets.openai.path} | str trim)
      source ${pkgs.nix-your-shell.generate-config "nu"}
    '';
    shellAliases = {
      # Nix development shortcuts
      nd = "nix develop";
      nb = "nix build";
      fu = "nix flake update";
      nh = "hx -w ${homeDir}/coding/nixos-config ${homeDir}/coding/nixos-config/home-manager/home.nix";
      nrs = "sudo nixos-rebuild switch --flake ${homeDir}/coding/nixos-config";
      hms = "home-manager switch --flake ${homeDir}/coding/nixos-config";
      pkg = "nix-shell -p";
      pkg-s = "nix search nixpkgs";
      
      # Rust/Cargo shortcuts
      c-fmt = "cargo fmt";
      c-fix = "cargo clippy --fix --allow-staged";
      cr = "cargo run";
      
      # Git shortcuts
      gaa = "git add *";
      gro = "git reset HEAD~1";
      gc = "git commit -am";
      gu = "git push";
      gd = "git pull";
      lg = "lazygit";
      
      # General utilities
      o = "xdg-open";
      emacs = "emacs -nw";
      
      # Personal directories
      life = "cd ${homeDir}/life";
      read = "yazi ${homeDir}/life/Areas/Studium/Research";
      
      # System monitoring and control
      governor = "cpupower frequency-info";
      power = "sudo cpupower frequency-set -g performance";
      powersave = "sudo cpupower frequency-set -g powersave";
      charge = "sudo tlp chargeonce BAT0";
      
      # Log viewing
      "log:helix" = "tail --follow ~/.cache/helix/helix.log";
      "log:hyprland" = ''
        do {
          let hypr_dir = $env.XDG_RUNTIME_DIR | path join 'hypr'
          let latest = ls $hypr_dir | sort-by modified -r | get name | first
          let log_path = $hypr_dir | path join $latest | path join 'hyprland.log'
          open $log_path | hx
        }
      '';
      "log:hyprland_rolling" = ''hyprctl rollinglog -f'';
    };
  };
}
