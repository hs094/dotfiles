# 🚀 My Terminal Config

A curated collection of dotfiles and tools for a productive, terminal-based development environment. This setup prioritizes speed, efficiency, and a cohesive TUI experience across all development tasks.

## 🎯 Philosophy

> **Terminal-First**: Everything accessible from the command line  
> **Performance-Focused**: Fast, lightweight alternatives to GUI tools  
> **Developer-Optimized**: Tools that enhance productivity and reduce context switching

---

## 📋 Table of Contents

- [🔧 Core Terminal Tools](#-core-terminal-tools)
- [💻 Development Environment](#-development-environment)
- [📁 File & System Management](#-file--system-management)
- [🌐 Language & Runtime Management](#-language--runtime-management)
- [🐳 DevOps & Infrastructure](#-devops--infrastructure)
- [🔍 Network & Monitoring](#-network--monitoring)
- [📊 Data & Analysis Tools](#-data--analysis-tools)
- [🎨 Media & Content Tools](#-media--content-tools)
- [🔐 Security & Privacy](#-security--privacy)
- [⚡ Quick Setup](#-quick-setup)

---

## 🔧 Core Terminal Tools

<details>
<summary>Essential terminal multiplexer and shell enhancements</summary>

### Terminal Management
- **[tmux](https://github.com/tmux/tmux)** - Terminal multiplexer for session management
- **[zsh](https://www.zsh.org/)** with **[oh-my-zsh](https://ohmyz.sh/)** - Enhanced shell experience
- **[starship](https://starship.rs/)** - Cross-shell prompt with Git integration
- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** - Command completion
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** - Syntax highlighting

### Navigation & Search
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter cd command with frecency
- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder for files, commands, history
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Ultra-fast grep alternative
- **[the_silver_searcher](https://github.com/ggreer/the_silver_searcher)** - Fast code search
- **[fd](https://github.com/sharkdp/fd)** - Simple, fast alternative to find

</details>

---

## 💻 Development Environment

<details>
<summary>Code editors, version control, and development utilities</summary>

### Editors & IDEs
- **[neovim](https://neovim.io/)** - Hyperextensible Vim-based text editor
- **[tree-sitter](https://tree-sitter.github.io/tree-sitter/)** - Syntax highlighting and code parsing

### Version Control
- **[git](https://git-scm.com/)** - Distributed version control system
- **[git-delta](https://github.com/dandavison/delta)** - Enhanced diff viewer with syntax highlighting
- **[lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for git commands
- **[git-lfs](https://git-lfs.github.io/)** - Large file storage for Git
- **[gitleaks](https://github.com/gitleaks/gitleaks)** - Secret detection in git repos
- **[forgit](https://github.com/wfxr/forgit)** - Interactive git commands with fzf
- **[difftastic](https://github.com/Wilfred/difftastic)** - Structural diff tool

### Development Utilities
- **[direnv](https://direnv.net/)** - Environment variable management per directory
- **[entr](https://eradman.com/entrproject/)** - File watcher for automatic command execution
- **[tldr](https://tldr.sh/)** - Simplified man pages with practical examples
- **[thefuck](https://github.com/nvbn/thefuck)** - Command correction tool

### Worktrunk Worktree Management
- **[worktrunk](https://worktrunk.dev)** (`brew install worktrunk`) - Git worktree management with hooks and aliases
  - `ws` / `wsc` / `wsx` - Switch / create / create+execute worktrees
  - `wch` - Manually copy hidden files (`.env`, `.envrc`, `.python-version`) from primary worktree
  - `wscp <branch>` - Create worktree + auto-copy hidden files via post-start hook
  - `wl` / `wlf` - List worktrees / full detail
  - `wm` / `wr` - Merge / remove worktrees
  - **post-start hook** auto-copies `.env*` and `.python-version` on new worktree creation

</details>

---

## 📁 File & System Management

<details>
<summary>File managers, system monitors, and disk utilities</summary>

### File Management
- **[yazi](https://github.com/sxyazi/yazi)** - Blazing fast terminal file manager
- **[eza](https://github.com/eza-community/eza)** - Modern replacement for ls with colors and icons
- **[tree](https://gitlab.com/OldManProgrammer/unix-tree)** - Directory structure visualization

### System Monitoring
- **[btop](https://github.com/aristocratos/btop)** - Resource monitor with modern interface
- **[bottom](https://github.com/ClementTsang/bottom)** - Cross-platform system monitor
- **[ctop](https://github.com/bcicen/ctop)** - Container metrics and monitoring

### Disk & Storage
- **[ncdu](https://dev.yorhel.nl/ncdu)** - Disk usage analyzer with ncurses interface
- **[dua-cli](https://github.com/Byron/dua-cli)** - Disk usage analyzer and file manager
- **[gdu](https://github.com/dundee/gdu)** - Fast disk usage analyzer
- **[dust](https://github.com/bootandy/dust)** - Intuitive du replacement

</details>

---

## 🌐 Language & Runtime Management

<details>
<summary>Programming language runtimes and package managers</summary>

### Node.js Ecosystem
- **[nvm](https://github.com/nvm-sh/nvm)** - Node Version Manager (npm uninstalled by design)
- **[bun](https://bun.sh/)** - Fast JavaScript runtime and package manager
- **[deno](https://deno.land/)** - Secure JavaScript/TypeScript runtime
- **[pnpm](https://pnpm.io/)** - Efficient package manager
- **[yarn](https://yarnpkg.com/)** - Package manager for JavaScript

### Python
- **[uv](https://github.com/astral-sh/uv)** - Ultra-fast Python package installer and resolver
- **[poetry](https://python-poetry.org/)** - Python dependency management and packaging

### Java & Scala
- **[openjdk](https://openjdk.org/)** & **[openjdk@21](https://openjdk.org/)** - Java Development Kit
- **[sbt](https://www.scala-sbt.org/)** - Scala build tool

### Other Languages
- **[go](https://golang.org/)** - Go programming language
- **[rust](https://www.rust-lang.org/)** - Systems programming language

</details>

---

## 🐳 DevOps & Infrastructure

<details>
<summary>Containerization, orchestration, and cloud tools</summary>

### Containerization
- **[docker](https://www.docker.com/)** & **[docker-compose](https://docs.docker.com/compose/)** - Container platform
- **[podman](https://podman.io/)** - Rootless container engine
- **[podman-compose](https://github.com/containers/podman-compose)** - Docker-compose equivalent for Podman
- **[podman-tui](https://github.com/containers/podman-tui)** - Terminal UI for Podman
- **[lazydocker](https://github.com/jesseduffield/lazydocker)** - Terminal UI for Docker

### Orchestration & Cloud
- **[kubernetes-cli](https://kubernetes.io/docs/reference/kubectl/)** (kubectl) - Kubernetes command-line tool
- **[helm](https://helm.sh/)** - Kubernetes package manager
- **[minikube](https://minikube.sigs.k8s.io/)** - Local Kubernetes development
- **[terraform](https://www.terraform.io/)** - Infrastructure as Code
- **[awscli](https://aws.amazon.com/cli/)** - AWS Command Line Interface
- **[localstack](https://localstack.cloud/)** - Local AWS cloud stack

</details>

---

## 🔍 Network & Monitoring

<details>
<summary>Network analysis, monitoring, and debugging tools</summary>

### Network Tools
- **[nmap](https://nmap.org/)** - Network discovery and security auditing
- **[iperf3](https://iperf.fr/)** - Network performance measurement
- **[tcpdump](https://www.tcpdump.org/)** - Network packet analyzer
- **[telnet](https://www.telnet.org/)** - Network protocol for remote access

### HTTP & APIs
- **[postings](https://github.com/darrenburns/posting)** - Modern TUI alternative to Postman
- **[ngrok](https://ngrok.com/)** - Secure tunneling to localhost

### Process Management
- **[mprocs](https://github.com/pvolok/mprocs)** - Run multiple processes in parallel with TUI

</details>

---

## 📊 Data & Analysis Tools

<details>
<summary>Data processing, analysis, and visualization utilities</summary>

### Data Processing
- **[jq](https://stedolan.github.io/jq/)** - Command-line JSON processor
- **[jless](https://github.com/PaulJuliusMartinez/jless)** - Interactive JSON viewer and explorer
- **[csvlens](https://github.com/YS-L/csvlens)** - Command-line CSV file viewer
- **[dblab](https://github.com/danvergara/dblab)** - Database client with TUI

### File Processing
- **[aria2](https://aria2.github.io/)** - Lightweight download utility
- **[axel](https://github.com/axel-download-accelerator/axel)** - Download accelerator
- **[wget](https://www.gnu.org/software/wget/)** - Non-interactive network downloader
- **[p7zip](https://p7zip.sourceforge.net/)** - File archiver with high compression ratio

</details>

---

## 🎨 Media & Content Tools

<details>
<summary>Media processing, documentation, and content creation</summary>

### Media Processing
- **[ffmpeg](https://ffmpeg.org/)** - Complete multimedia framework
- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** - YouTube downloader and media extractor
- **[imagemagick](https://imagemagick.org/)** - Image manipulation suite

### Documentation & Presentation
- **[pandoc](https://pandoc.org/)** - Universal document converter
- **[silicon](https://github.com/Aloxaf/silicon)** - Create beautiful code screenshots
- **[bat](https://github.com/sharkdp/bat)** - Cat clone with syntax highlighting and Git integration
- **[micro](https://micro-editor.github.io/)** - Modern terminal-based text editor

### Text Processing
- **[tesseract](https://github.com/tesseract-ocr/tesseract)** - OCR engine for text recognition
- **[diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)** - Human-readable diffs

</details>

---

## 🔐 Security & Privacy

<details>
<summary>Encryption, password management, and security tools</summary>

### Encryption & Keys
- **[gnupg](https://gnupg.org/)** - Complete GnuPG implementation
- **[gpg-tui](https://github.com/orhun/gpg-tui)** - Terminal user interface for GnuPG
- **[pass](https://www.passwordstore.org/)** - Unix password manager using GPG

### Security Analysis
- **[cloc](https://github.com/AlDanial/cloc)** - Count lines of code with security insights

### Network Security
- Various SSL/TLS libraries and cryptographic tools included in the stack

</details>

---

## ⚡ Quick Setup

### Prerequisites
```bash
# Install Homebrew (macOS/Linux)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install Everything
All packages are declared in the [`Brewfile`](homebrew/Brewfile) — install them
in one shot with `brew bundle`:

```bash
# From the repo root
brew bundle --file=homebrew/Brewfile
```

> Adding a tool? Put it in `homebrew/Brewfile` and re-run `brew bundle`.
> Run `brew bundle cleanup --file=homebrew/Brewfile` to remove anything not
> listed in the Brewfile.

### Configuration
1. Clone this dotfiles repository
2. Run the setup script to symlink configurations
3. Install NVM and set up Node.js environment
4. Configure tmux, neovim, and shell preferences

---

## 🔄 Maintenance

### Package Management
- **[bbrew](https://github.com/orhun/bbrew)** - Brew management utility for keeping packages updated
- Regular cleanup and optimization scripts included

### Backup & Sync
- Dotfiles version controlled with Git
- Automated backup scripts for configurations
- Cross-machine synchronization setup

---

## 🤝 Contributing

Feel free to explore, fork, and adapt this setup to your needs. If you have suggestions for additional TUI tools or optimizations, please open an issue or submit a pull request.

## 📝 License

This dotfiles collection is open source and available under the [MIT License](LICENSE).

---

*Built with ❤️ for terminal enthusiasts and keyboard-driven development*