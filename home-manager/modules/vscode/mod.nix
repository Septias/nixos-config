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
      unicodeHighlight = {
        invisibleCharacters = false;
        ambiguousCharacters = false;
      };
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
    window = {
      autoDetectColorScheme = true;
      commandCenter = false;
      menuBarVisibility = "compact";
    };
    chat.disableAIFeatures = false;
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
        inherit keybindings;
        userSettings =
          userSettings
          // {
            editor = {
              gotoLocation.multipleDefinitions = "goto";
              codeActionsOnSave = {
                source.fixAll.eslint = "explicit";
              };
            };
            "editor.formatOnSave" = false;
          };
        languageSnippets = {
          vue = {
            script = {
              body = [
                "<script lang=\"ts\" setup>"
                ""
                "</script>"
              ];
              description = "Ts setup sript";
              prefix = [
                "script"
              ];
            };
            pug = {
              body = [
                "<template lang=\"pug\">"
                ""
                "</template>"
              ];
              description = "A pug html tag";
              prefix = [
                "pug"
              ];
            };
            sass = {
              body = [
                "<style lang=\"sass\" scoped>"
                ""
                "</style>"
              ];
              description = "Scoped Sass";
              prefix = [
                "sass"
              ];
            };
          };
        };
        extensions =
          defaultExtensions
          ++ pkgs.nix4vscode.forVscode [
            "dbaeumer.vscode-eslint"
            "amandeepmittal.pug"
            "syler.sass-indented"
            "csstools.postcss"
            "antfu.goto-alias"
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
      python = {
        inherit userSettings keybindings;
        extensions =
          defaultExtensions
          ++ pkgs.nix4vscode.forVscode [
            "ms-python.python"
            "ms-python.vscode-pylance"
          ];
      };
      agda = {
        inherit keybindings;
        userSettings =
          userSettings
          // {
            agdaMode.connection = {
              downloadPolicy = "No, and don't ask again";
              paths = [
                "/home/septias/.nix-profile/bin/agda"
              ];
            };
            "[agda]" = {
              editor.unicodeHighlight.ambiguousCharacters = false;
            };
            "[lagda]" = {
              editor.unicodeHighlight.ambiguousCharacters = false;
            };
          };
        extensions =
          defaultExtensions
          ++ pkgs.nix4vscode.forVscode [
            "banacorn.agda-mode"
          ];
      };
    };
  };
}
