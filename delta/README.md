# Delta — GitHub-like side-by-side diff with Cursor Dark highlighting

Terminal diff viewer configured to look like GitHub's split diff view with syntax highlighting matching Cursor/VS Code Dark Modern theme.

## What you get

- **Side-by-side** split diff layout with line numbers
- **GitHub-like** file separator cards (grey box borders, no hunk headers)
- **Cursor Dark** syntax theme (built from VS Code's `dark_vs.json` + `dark_plus.json` + `dark_modern.json`)
- **Enhanced Rust grammar** via [rust-lang/rust-enhanced](https://github.com/rust-lang/rust-enhanced) — significantly better token coverage than bat's default
- **Subtle diff backgrounds** matching VS Code's 20%-opacity green/red tints
- **Green/red extends into line number gutter** like GitHub
- **No vertical separator bars** around line numbers — clean look

## Prerequisites

- [Homebrew](https://brew.sh) (macOS/Linux)
- A terminal with **true color** support (Ghostty, iTerm2, WezTerm, Kitty, Alacritty, etc.)
- Dark terminal background recommended

## Install

```bash
./install.sh
```

This will:
1. Install `git-delta` and `bat` via Homebrew (if not present)
2. Copy `CursorDark.tmTheme` to bat's themes directory
3. Copy `RustEnhanced.sublime-syntax` to bat's syntaxes directory
4. Rebuild the bat/delta cache
5. Configure `~/.gitconfig` with all delta settings

## Verify

```bash
git log -1 -p        # view last commit diff
git diff              # view working tree changes
git diff --staged     # view staged changes
```

Use `n` / `N` to jump between files (delta navigate mode).

## Files

```
delta/
  themes/
    CursorDark.tmTheme              # VS Code Dark Modern token colors in TextMate format
  syntaxes/
    RustEnhanced.sublime-syntax     # Better Rust grammar from rust-lang/rust-enhanced
  install.sh                        # One-shot installer
  README.md
```

## Rust token color reference

| Token | Color | Hex |
|---|---|---|
| Keywords (`fn`, `let`, `use`, `pub`, `mut`) | Blue | `#569cd6` |
| Control flow (`if`, `else`, `match`, `return`) | Purple | `#C586C0` |
| Functions and macros (`foo()`, `println!`) | Yellow | `#DCDCAA` |
| Types (`String`, `Vec`, struct/enum names) | Teal | `#4EC9B0` |
| Variables and parameters | Light blue | `#9CDCFE` |
| Constants (`MAX_SIZE`) | Bright blue | `#4FC1FF` |
| Strings (`"hello"`) | Orange | `#ce9178` |
| Numbers (`42`, `3.14`) | Light green | `#b5cea8` |
| Comments | Green | `#6A9955` |
| Lifetimes (`'a`, `'static`) | Blue | `#569cd6` |
| Operators and punctuation | Foreground | `#CCCCCC` |

## Limitations

Delta uses regex-based syntax grammars (TextMate/Sublime), not semantic analysis. Some tokens that Cursor/VS Code colors via rust-analyzer (e.g. distinguishing local variables from struct fields, or knowing which identifier is a type vs a module) won't be differentiated in delta. This is a fundamental limitation of terminal diff tools.

## Customization

Theme file: `~/.config/bat/themes/CursorDark.tmTheme`
Syntax file: `~/.config/bat/syntaxes/RustEnhanced.sublime-syntax`

After editing, rebuild the cache:
```bash
bat cache --build
```

Git config entries are under `[delta]` in `~/.gitconfig`.
