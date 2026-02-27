#!/usr/bin/env bash
set -euo pipefail

# Delta — GitHub-like side-by-side diff with Cursor Dark syntax highlighting
# https://github.com/dandavison/delta

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing delta diff tool configuration..."

# 1. Install delta and bat via Homebrew
if ! command -v delta &>/dev/null; then
  echo "Installing git-delta..."
  brew install git-delta
else
  echo "delta already installed: $(delta --version)"
fi

if ! command -v bat &>/dev/null; then
  echo "Installing bat (needed for custom themes/syntaxes)..."
  brew install bat
else
  echo "bat already installed: $(bat --version)"
fi

# 2. Install custom theme and syntax grammar
BAT_CONFIG_DIR="$(bat --config-dir)"
mkdir -p "$BAT_CONFIG_DIR/themes" "$BAT_CONFIG_DIR/syntaxes"

cp "$SCRIPT_DIR/themes/CursorDark.tmTheme" "$BAT_CONFIG_DIR/themes/"
echo "Installed CursorDark.tmTheme"

cp "$SCRIPT_DIR/syntaxes/RustEnhanced.sublime-syntax" "$BAT_CONFIG_DIR/syntaxes/"
echo "Installed RustEnhanced.sublime-syntax"

bat cache --build
echo "Rebuilt bat/delta cache"

# 3. Configure git to use delta as pager
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'

# 4. Delta layout — side-by-side with line numbers, GitHub-like card separators
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global delta.line-numbers true
git config --global delta.features decorations

# 5. Syntax theme — Cursor Dark (VS Code Dark Modern + Dark+ token colors)
git config --global delta.syntax-theme CursorDark

# 6. File headers — bold with grey box underline
git config --global delta.file-style bold
git config --global delta.file-decoration-style '"#6e6e78" box ul'
git config --global delta.hunk-header-decoration-style '"#6e6e78" box ul'
git config --global delta.hunk-header-style omit

# 7. Line numbers — no vertical separator bars, grey background for unchanged
git config --global delta.line-numbers-left-format '{nm:^4} '
git config --global delta.line-numbers-right-format '{np:^4} '
git config --global delta.line-numbers-left-style '"#d4d4d4"'
git config --global delta.line-numbers-right-style '"#d4d4d4"'
git config --global delta.line-numbers-zero-style '"#d4d4d4" "#2d2d30"'

# 8. Line number backgrounds match diff backgrounds (green/red extend into gutter)
git config --global delta.line-numbers-minus-style '"#d4d4d4" "#3D2020"'
git config --global delta.line-numbers-plus-style '"#d4d4d4" "#283D28"'

# 9. Diff backgrounds — VS Code-matching subtle tints (20% opacity blended on dark bg)
git config --global delta.minus-style 'syntax "#3D2020"'
git config --global delta.plus-style 'syntax "#283D28"'
git config --global delta.minus-emph-style 'syntax "#5C2B2B"'
git config --global delta.plus-emph-style 'syntax "#2E4D2E"'

echo ""
echo "Done! Try: git log -1 -p"
