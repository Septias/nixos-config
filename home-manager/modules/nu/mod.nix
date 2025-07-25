{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.carapace];
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
      nd = "nix develop";
      nb = "nix build";
      fu = "nix flake update";
      nh = "hx -w /home/septias/coding/nixos-config /home/septias/coding/nixos-config/home-manager/home.nix";
      nrs = "sudo nixos-rebuild switch --flake /home/septias/coding/nixos-config";
      hms = "home-manager switch --flake /home/septias/coding/nixos-config";
      pkg = "nix-shell -p";
      pkg-s = "nix search nixpkgs";
      c-fmt = "cargo fmt";
      c-fix = "cargo clippy --fix --allow-staged";
      gaa = "git add *";
      gro = "git reset HEAD~1";
      gc = "git commit -am";
      gu = "git push --force-with-lease";
      gd = "git pull";
      lg = "lazygit";
      o = "xdg-open";
      debug_h = "tail --follow ~/.cache/helix/helix.log";
      hlog = ''        do {
               let hypr_dir = $env.XDG_RUNTIME_DIR | path join 'hypr'
               let latest = ls $hypr_dir | sort-by modified -r | get name | first
               let log_path = $hypr_dir | path join $latest | path join 'hyprland.log'
               open $log_path | hx
             }
      '';
      hlogr = ''hyprctl rollinglog -f'';
      emacs = "emacs -nw";
      dark = "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"";
      light = "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-light'\"";
      "c." = "codium .";
    };
  };
}
