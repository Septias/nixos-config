
## Septias' nixos config

> My own cracked up configuration

- Terminal: Kitty
   - Search: fzf
   - Shell: nu
   - Prompt: starship
   - History: atuin
   - Theme: cattpuccin frappe
- Editor:
   - emacs (spacemacs)
   - vscode (vscodium)
   - helix
- Bar: Hyprpanel
   - theme: catppuccin frappe
- Window Manager: Hyprland
   - hypridle
   - hyprsunset
   - hyprlock
- File Explorer
   - yazi
   - nautilus (gnome)
- Input mode (neo2.0)
   - Configured compose combinations
- Application launcher: anyrun
- Secrets: sops

## New Device
1. Get the nix iso (mini is fine)
2. Boot from USB
3. Load keyboard (keyload de neo)
4. Follow install steps
5. Reboot into first generation
6. Add nix-sops
   1. Generate age-key and add to `~/.config/sops/keys.txt`
   2. Add age-key in `.sops.yaml`
   3. Rebuild sops file `sops updatekeys secrets/secret.yaml`
7. Select Kitten themes
