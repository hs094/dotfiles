# Neovim DAP Debugger Setup Guide

## Installation Steps

1. **Restart Neovim** to load the new DAP plugins:
   ```
   :Lazy sync
   ```

2. **Install Debug Adapters** using Mason:
   ```
   :MasonInstall python codelldb js-debug-adapter java-debug-adapter javadbg
   ```

## Manual Debug Adapter Installation

If you prefer manual installation, here are the commands for each language:

### Python (debugpy)
```bash
pip install debugpy
```

### TypeScript/JavaScript (js-debug-adapter)
```bash
npm install -g js-debug-adapter
```

### C++/Rust (codelldb)
```bash
# macOS
brew install codelldb

# Linux (from GitHub releases)
wget https://github.com/vadimcn/codelldb/releases/download/v1.9.0/codelldb-x86_64-linux.vsix
```

### Java (javadbg)
```bash
# mason will handle this automatically
```

## Keybindings

All debugger commands use `<leader>d` prefix:

| Key | Action | Mnemonic |
|-----|--------|----------|
| `<leader>dc` | Continue | c = continue |
| `<leader>dp` | Pause | p = pause |
| `<leader>dn` | Step Over | n = next |
| `<leader>di` | Step Into | i = into |
| `<leader>do` | Step Out | o = out |
| `<leader>db` | Toggle Breakpoint | b = breakpoint |
| `<leader>dB` | Set Conditional Breakpoint | B = big breakpoint |
| `<leader>dL` | Set Log Point | L = log |
| `<leader>dr` | Open REPL | r = repl |
| `<leader>du` | Toggle DAP UI | u = ui |
| `<leader>dv` | Toggle Virtual Text | v = virtual |
| `<leader>dl` | Run Last Configuration | l = last |
| `<leader>dk` | Move Up Stack Frame | k = up (vim direction) |
| `<leader>dj` | Move Down Stack Frame | j = down (vim direction) |
| `<leader>dH` | Clear All Breakpoints | H = clear |
| `<leader>dx` | Terminate Debug Session | x = exit |
| `<leader>dw` | Evaluate Word Under Cursor | w = word/evaluate |

## Language-Specific Setup

### Python
- Ensure `debugpy` is installed: `pip install debugpy`
- Supports virtual environments automatically

### TypeScript/JavaScript
- Uses `js-debug-adapter` via pwa-node
- Supports source maps and ts-node

### C++/Rust
- Requires `codelldb` or `lldb`
- For Rust: install via `rustup component add rust-src`

### Java
- Requires `jdtls` (already configured in your LSP)
- Uses port 5005 for debugging

## Quick Reference

```
[Control Flow]
  <leader>dc  →  Continue
  <leader>dp  →  Pause
  <leader>dx  →  Terminate

[Step Operations]
  <leader>dn  →  Step Over (next)
  <leader>di  →  Step Into
  <leader>do  →  Step Out

[Breakpoints]
  <leader>db  →  Toggle breakpoint
  <leader>dB  →  Conditional breakpoint
  <leader>dL  →  Log point
  <leader>dH  →  Clear all breakpoints

[Navigation]
  <leader>dk  →  Up stack frame
  <leader>dj  →  Down stack frame
  <leader>dl  →  Run last config

[UI & Evaluation]
  <leader>du  →  Toggle DAP UI
  <leader>dr  →  Open REPL
  <leader>dv  →  Toggle virtual text
  <leader>dw  →  Evaluate word
```

## Troubleshooting

1. **Debug adapter not found**: Run `:Mason` and ensure adapters are installed
2. **Python debug not working**: Ensure `debugpy` is in your virtual environment
3. **C++ debugging issues**: Verify `codelldb` is in your PATH
4. **Java debugging**: Ensure `jdtls` is working first

## Useful Commands

- `:DapUiOpen` - Open DAP UI
- `:DapUiToggle` - Toggle DAP UI
- `:DapInstall python` - Install Python debug adapter
- `:DapList` - List available debug configurations
- `:DapContinue` - Start debugging
