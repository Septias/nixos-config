
## Septias' NixOS Config

> My personal NixOS configuration with Hyprland

### 🖥️ System Components

**Terminal:**
- Terminal: Kitty
- Shell: Nushell
- Prompt: Starship
- History: Atuin
- Search: fzf
- Theme: Catppuccin Frappe

**Editors:**
- Emacs (Spacemacs)
- VSCodium
- Helix

**Desktop Environment:**
- Window Manager: Hyprland
- Bar: Hyprpanel
- Application Launcher: Anyrun
- Idle Manager: hypridle
- Lock Screen: hyprlock
- Night Light: hyprsunset

**File Management:**
- TUI: Yazi
- GUI: Nautilus (GNOME)

**Other:**
- Keyboard Layout: Neo 2.0 with custom compose combinations
- Secrets Management: sops-nix

### 📦 Installation

#### New Device Setup
1. Get the NixOS ISO (mini is fine)
2. Boot from USB
3. Load keyboard: `loadkeys de neo`
4. Follow standard NixOS installation steps
5. Reboot into first generation
6. Configure sops-nix:
   ```bash
   # Generate age key
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   
   # Add public key to .sops.yaml
   # Rebuild sops file
   sops updatekeys secrets/secret.yaml
   ```
7. Select Kitty themes

### ⚠️ Quirks

> Known issues that required manual fixes (may be resolved upstream eventually)

- **XDG Portals**: Had to manually enable portals in `home-manager > xdg.portals` for GNOME `color-scheme` setting
- **SSH Agent**: Required manual environment variable configuration; GNOME keyring doesn't auto-unlock
- **NVIDIA**: Required specific environment variables
- **Sioyek**: PDF viewer needed custom environment variables
