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
      CHATMAIL_DOMAIN = "\"nine.testrun.org\"";
      HANDLER = "copilot";
    };
    extraConfig = ''
      $env.COPILOT_API_KEY = (open ${config.sops.secrets.copilot.path} | str trim)
      source ${pkgs.nix-your-shell.generate-config "nu"}
    '';
    shellAliases = {
      dc-acc = "curl -X POST 'https://testrun.org/new_email?t=1w_96myYfKq1BGjb2Yc&n=oneweek'";
      nd = "nix develop";
      nb = "nix build";
      fu = "nix flake update";
      nc = "hx /home/septias/coding/nixos-config";
      nh = "hx -w /home/septias/coding/nixos-config /home/septias/coding/nixos-config/home-manager/home.nix";
      nrs = "sudo nixos-rebuild switch --flake /home/septias/coding/nixos-config";
      hms = "home-manager switch --flake /home/septias/coding/nixos-config";
      _ = "sudo ";
      pkg = "nix-shell -p";
      pkg-s = "nix search nixpkgs";
      c-fmt = "cargo fmt";
      c-fix = "cargo clippy --fix --allow-staged";
      gaa = "git add *";
      gro = "git reset HEAD~1";
      gc = "git commit -am";
      gu = "git push --force-with-lease";
      gd = "git pull";
      gds = "git stash and git pull and git stash pop";
      nix-clean = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old and nix-collect-garbage -d";
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
    };
  };
}
