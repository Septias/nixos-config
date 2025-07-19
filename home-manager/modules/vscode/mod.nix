{pkgs, ...}: let
  userSettings = {
    git = {
      autofetch = true;
      enableSmartCommit = true;
      confirmSync = false;
      ignoreRebaseWarning = true;
      openRepositoryInParentFolders = "always";
    };
    explorer = {
      confirmDelete = false;
      confirmDragAndDrop = false;
    };
    editor = {
      inlineSuggest.enabled = true;
      unicodeHighlight.invisibleCharacters = false;
      formatOnSave = true;
      minimap.enabled = false;
      fontFamily = "'JetBrains Mono', monospace";
      fontLigatures = true;
    };
    github = {
      copilot.enable = {
        "*" = true;
      };
      copilot.editor.enableAutoCompletions = true;
    };
    security.workspace.trust.untrustedFiles = "open";
    gitlens = {
      currentLine.enabled = false;
      statusBar.enabled = false;
      views.scm.grouped.views = {
        commits = true;
        branches = true;
        remotes = true;
        stashes = true;
        tags = true;
        worktrees = true;
        contributors = true;
        repositories = false;
        searchAndCompare = true;
        launchpad = false;
      };
      graph.minimap.enabled = false;
      views.commitDetails.files.layout = "tree";
    };
    workbench = {
      preferredDarkColorTheme = "Bearded Theme Monokai Black";
      preferredLightColorTheme = "Bearded Theme feat. Mintshake D Raynh";
      layoutControl.enabled = false;
      navigationControl.enabled = false;
    };
    nix = {
      enableLanguageServer = true;
      serverPath = "nil";
      formatterPath = "alejandra";
    };
    diffEditor.ignoreTrimWhitespace = true;
    "[nix]" = {
      editor.insertSpaces = true;
    };
    "[markdown]" = {
      editor.unicodeHighlight.ambiguousCharacters = false;
      editor.unicodeHighlight.invisibleCharacters = false;
      editor.wordWrap = "on";
    };
    githubPullRequests.pullBranch = "never";
    files = {
      insertFinalNewline = true;
      autoSave = "afterDelay";
      readonlyInclude = {
        "**/.cargo/registry/src/**/*.rs" = true;
        "**/.cargo/git/checkouts/**/*.rs" = true;
        "**/lib/rustlib/src/rust/library/**/*.rs" = true;
      };
    };

    "agdaMode.connection.paths" = [
      "/home/septias/.nix-profile/bin/agda"
    ];
    window = {
      autoDetectColorScheme = true;
      commandCenter = false;
      menuBarVisibility = "compact";
    };
  };
  keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
  defaultExtensions = pkgs.nix4vscode.forVscode [
    "mkhl.direnv"
    "fill-labs.dependi"
    "editorconfig.editorconfig"
    "usernamehw.errorlens"
    "github.copilot"
    "gitHub.copilot-chat"
    "eamodio.gitlens"
    "bbenoist.nix"
    "beardedbear.beardedtheme"
    "anthropic.claude-code"
  ];
in {
  home.packages = [
    pkgs.libsecret
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    profiles = {
      vue = {
        inherit userSettings keybindings;
        extensions =
          defaultExtensions
          ++ pkgs.nix4vscode.forVscode [
            "dbaeumer.vscode-eslint"
            "amandeepmittal.pug"
            "syler.sass-indented"
            "antfu.unocss"
            "vue.volar"
          ];
      };
      rust = {
        inherit userSettings keybindings;
        extensions =
          defaultExtensions
          ++ pkgs.nix4vscode.forVscode [
            "rust-lang.rust-analyzer"
          ];
      };
      agda = {
        inherit userSettings keybindings;
        extensions =
          defaultExtensions
          ++ pkgs.nix4vscode.forVscode [
            "banacorn.agda-mode"
          ];
      };
    };
  };
}
