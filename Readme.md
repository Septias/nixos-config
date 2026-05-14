<img width="1914" height="1188" alt="image" src="https://github.com/user-attachments/assets/dc51d118-00ba-4bda-9e4b-de09c12f00a4" />

## Septias' nixos config

- Terminal: Kitty
   - Search: fzf
   - Shell: nu
   - Prompt: starship
   - History: atuin
   - Theme: catppuccin frappe
- Editor:
   - helix
   - vscode (vscodium)
- Bar: Hyprpanel
   - theme: catppuccin frappe
- Window Manager: Hyprland
   - hypridle
   - hyprsunset
   - hyprlock
   - hyprpicker
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

## Quirks
> Things that should work but had to be fixed manually. Eventually, these might be fixed by upstream.

- Portals for setting gnome `color-scheme` had to be enabled manually in `home-manager > xdg.portals`
- For the SSH agent, some environment variables had to be set.
   - The gnome keyring would not unlock automatically.
- For NVIDIA, some env-vars had to be set.
- Sioyek had to add some env variables.
