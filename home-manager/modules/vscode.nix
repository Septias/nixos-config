{pkgs, ...}: let
  defaultSettings = {
    explorer.confirmDelete = false;
    git = {
      autofetch = true;
      enableSmartCommit = true;
      confirmSync = false;
      ignoreRebaseWarning = true;
    };
    explorer.confirmDragAndDrop = false;
    editor.inlineSuggest.enabled = true;
    github.copilot.enable = {
      "*" = true;
    };
    editor.unicodeHighlight.invisibleCharacters = false;
    security.workspace.trust.untrustedFiles = "open";
    editor.formatOnSave = true;
    editor.minimap.enabled = false;
    gitlens.currentLine.enabled = false;
    gitlens.statusBar.enabled = false;
    cSpell.userWords = ["firestore" "Klähn" "pinia" "webxdc"];
    window.autoDetectColorScheme = true;
    workbench.preferredDarkColorTheme = "Sapphire (Dim)";
    workbench.preferredLightColorTheme = "Atom One Light";
    editor.fontFamily = "'JetBrains Mono', monospace";
    editor.fontLigatures = true;
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
    files.insertFinalNewline = true;
    github.copilot.editor.enableAutoCompletions = true;
    agdaMode.connection.paths = [
      "/home/septias/.nix-profile/bin/agda"
    ];
    gitlens.views.scm.grouped.views = {
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
    gitlens.graph.minimap.enabled = false;
    gitlens.views.commitDetails.files.layout = "tree";
    workbench.layoutControl.enabled = false;
    workbench.navigationControl.enabled = false;
    window.commandCenter = false;
    window.menuBarVisibility = "compact";
  };
  defaultExtensions = with pkgs.vscode-extensions; [
    mkhl.direnv
    fill-labs.dependi
    editorconfig.editorconfig
    usernamehw.errorlens
    github.copilot
    eamodio.gitlens
    bbenoist.nix
  ];
in {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    # profiles = {
    #   vue = {
    #     extensions =
    #       defaultExtensions
    #       ++ (with pkgs.vscode-extensions; [
    #         dbaeumer.vscode-eslint
    #         # amandeepmittal.pug
    #         # syler.sass-indented
    #         # antfu.unocss
    #         vue.volar
    #       ]);
    #     userSettings = defaultSettings;
    #   };
    # };
  };
}
