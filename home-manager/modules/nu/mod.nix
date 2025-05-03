{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.carapace];
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    environmentVariables = {
      CHATMAIL_DOMAIN = "\"nine.testrun.org\"";
      HANDLER = "copilot";
    };
    extraConfig = ''
      source ${./carapace.nu}
      $env.COPILOT_API_KEY = (open ${config.sops.secrets.copilot.path} | str trim)'';
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
      emacs = "emacs -nw";
      dark = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'";
      light = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'";
    };
  };
}
