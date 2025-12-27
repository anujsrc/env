# env
> **Journey:** Ubuntu → Debian → macOS  
> After years of working primarily on Linux (Ubuntu first, then Debian), I’ve now fully settled on **macOS (Tahoe)** as my daily development environment.  
> This setup reflects a balance of **Unix familiarity**, **performance**, and **developer ergonomics** without sacrificing control.

## Philosophy

- Declarative over imperative
- One tool over many
- Explicit signals over magic
- Local-first AI

# macOS (Tahoe)
This document captures **what I installed, why I installed it, and how everything fits together**, so the environment is:
- Reproducible
- Minimal yet powerful
- Language-agnostic
- Friendly to polyglot + AI-assisted workflows

## System Overview

- **OS**: macOS Tahoe  
- **Architecture**: Apple Silicon (ARM64)  
- **Shell**: Zsh  
- **Package Manager**: Homebrew  
- **Version Manager**: Mise  
- **Containers & Docker**: OrbStack  
- **Prompt Engine**: Oh My Posh  
- **Fonts**: JetBrains Mono Nerd Font  
- **AI Runtime**: Ollama (Metal / GPU)

## Homebrew (Foundation)

Homebrew is the base package manager for everything else.

### Post-Install Highlights

- `/opt/homebrew/bin` added to PATH via `/etc/paths.d`
- Portable Ruby installed
- Homebrew analytics enabled (aggregate only)

### Shell Setup

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Docs: https://docs.brew.sh

## Git

```bash
brew install git
```

## OrbStack (Containers & Docker) 

```bash
brew install orbstack
```

Features:
- Fast Docker & Kubernetes
- Native macOS integration
- Low resource usage
- CLI tools: `orb`, `orbctl`

## Mise (Unified Toolchain Manager)

```bash
brew install mise
eval "$(mise activate zsh)"
```

### Cleanup
```bash
mise prune --tools
mise cache prune
```

Docs: https://betterstack.com/community/guides/scaling-nodejs/mise-vs-asdf/

## Fonts & Terminal

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Terminal:
- Font: JetBrains Mono Nerd Font
- Size: 12

## Prompt - Oh My Posh (Custom Peru Theme)

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

### Upgrade
```bash
brew upgrade jandedobbeleer/oh-my-posh/oh-my-posh
brew cleanup
```

### Theme - Peru Custom
<details>
<summary>Peru Theme Configuration (Customized)</summary>
```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "foreground": "#26C6DA",
          "style": "plain",
          "template": "{{ if .WSL }}WSL at {{ end }}{{.Icon}} ",
          "type": "os"
        },
        {
          "foreground": "#26C6DA",
          "style": "diamond",
          "template": "{{ .UserName }}@{{ .HostName }} ",
          "type": "session"
        },
        {
          "foreground": "#FFE700",
          "foreground_templates": [
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#FFCC80{{ end }}",
            "{{ if gt .Ahead 0 }}#16c60c{{ end }}",
            "{{ if gt .Behind 0 }}#f450de{{ end }}"
          ],
          "properties": {
            "fetch_status": true,
            "fetch_upstream_icon": true
          },
          "style": "plain",
          "template": "{{ .UpstreamIcon }} {{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} ",
          "type": "git"
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "right",
      "segments": [
        {
          "background": "#4c1f5e",
          "foreground": "#ffffff",
          "leading_diamond": " \ue0b6",
          "style": "diamond",
          "template": "\ue738 {{ .Full }} ",
          "trailing_diamond": "\ue0b4",
          "type": "java"
        },
        {
          "background": "#5881d8",
          "foreground": "#ffffff",
          "leading_diamond": " \ue0b6",
          "style": "diamond",
          "template": "\uE768 {{ .Full }} ",
          "trailing_diamond": "\ue0b4",
          "type": "clojure"
        },
        {
          "background": "#06aad5",
          "foreground": "#fffff",
          "leading_diamond": " \ue0b6",
          "style": "diamond",
          "template": "\ue626 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
          "trailing_diamond": "\ue0b4",
          "type": "go"
        },
        {
          "background": "#52a736",
          "foreground": "#ffffff",
          "leading_diamond": " \ue0b6",
          "style": "diamond",
          "template": "\ue235 ({{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Major }}.{{ .Minor }}{{ end }}) ",
          "trailing_diamond": "\ue0b4",
          "type": "python"
        },
        {
          "background": "#6CA35E",
          "foreground": "#ffffff",
          "leading_diamond": " \ue0b6",
          "style": "diamond",
          "template": "\ue718 {{ .Full }} ",
          "trailing_diamond": "\ue0b4",
          "type": "node"
        },
        {
          "properties": {
            "always_enabled": true
          },
          "style": "plain",
          "template": " {{ if gt .Code 0 }}<#ff0000>\uf00d</>{{ else }}<#23d18b>\uf42e</>{{ end }} ",
          "type": "status"
        },
        {
          "foreground": "#bab02a",
          "properties": {
            "threshold": 10
          },
          "style": "plain",
          "template": "took \uf252 {{ .FormattedMs }} ",
          "type": "executiontime"
        },
        {
          "foreground": "#00C5C7",
          "properties": {
            "time_format": "15:04:05"
          },
          "style": "plain",
          "template": " {{ .CurrentDate | date .Format }} \uf017 ",
          "type": "time"
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "foreground": "#77E4F7",
          "properties": {
            "style": "full"
          },
          "style": "plain",
          "template": "{{ .Path }} ",
          "type": "path"
        },
        {
          "foreground": "#43D426",
          "style": "plain",
          "template": "\u276f ",
          "type": "text"
        }
      ],
      "type": "prompt"
    }
  ],
  "version": 3
}
```
</details>

### Initialize with `.zshrc`:
```bash
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/peru-custom.json)"
```

## Ollama (Local AI Runtime)

Installed via DMG from the official website.

- Uses Metal API
- Runs LLMs locally
- No Docker required

## Java (via Mise)

```bash
mise use -g java@21
```

### macOS Integration
```bash
sudo mkdir /Library/Java/JavaVirtualMachines/21.0.2.jdk
sudo ln -s ~/.local/share/mise/installs/java/21.0.2/Contents \
  /Library/Java/JavaVirtualMachines/21.0.2.jdk/Contents
```

## Clojure

```bash
mise use -g clojure@1.12.4
```

## Node.js

```bash
mise use -g node@24.12.0
```

## Python + UV

```bash
mise use -g python@3.14.2
mise use -g uv@latest
```

### Optional Mise Setting
```toml
[settings]
# python.uv_venv_auto = true
```

### Python Environment Awareness (Zsh Hook)

```bash
autoload -Uz add-zsh-hook

_check_python_env_state() {
  if [[ "$PWD" == */.venv/* ]]; then
    return
  fi

  if [[ (-f pyproject.toml || -f requirements.txt) && ! -d .venv ]]; then
    printf "[!] Python project detected, virtual environment (.venv) not found\n"
    printf "[>] Create one with: uv venv --seed\n"
    return
  fi

  if [[ -d .venv ]]; then
    if [[ -z "$VIRTUAL_ENV" ]]; then
      printf "[!] Python virtual environment exists but is NOT active\n"
      printf "[>] Activate with: source .venv/bin/activate\n"
    elif [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]]; then
      printf "[!] A different Python virtual environment is active\n"
      printf "[>] Active venv  : %s\n" "$VIRTUAL_ENV"
      printf "[>] Project venv : %s\n" "$PWD/.venv"
      printf "[>] Fix: deactivate && source .venv/bin/activate\n"
    fi
  fi
}

add-zsh-hook chpwd _check_python_env_state
```

### Project-Level Mise Config

```toml
[tools]
python = "3.14.2"
```

The file must be trusted for activation.

### Consolidated .zshrc
Default location: ```~/.zshrc```
```bash
### Homebrew ###
eval "$(/opt/homebrew/bin/brew shellenv)"

### mise ###
eval "$(mise activate zsh)"

### Oh My Posh ###
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/peru-custom.json)"

# Added by Antigravity
export PATH="/Users/anuj/.antigravity/antigravity/bin:$PATH"

# Alias
alias gst="git status"

# Hooks
autoload -Uz add-zsh-hook

_check_python_env_state() {
  ## Check for existing venv directory - do nothing
  if [[ "$PWD" == */.venv/* ]]; then
    return
  fi

  ## Case 1: Python project but no venv
  if [[ (-f pyproject.toml || -f requirements.txt) && ! -d .venv && "$PWD" != */.venv/* ]]; then
    printf "[\u0021] Python project detected, virtual environment (.venv) not found\n"
    printf "[\u003E] Create one with: uv venv --seed\n"
    return
  fi

  ## Case 2: venv exists but not active (VIRTUAL_ENV-based only)
  if [[ -d .venv ]]; then
    if [[ -z "$VIRTUAL_ENV" ]]; then
      printf "[\u0021] Python virtual environment exists but is NOT active\n"
      printf "[\u003E] Activate with: source .venv/bin/activate\n"
    elif [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]]; then
      printf "[\u0021] A different Python virtual environment is active\n"
      printf "[\u003E] Active venv  : %s\n" "$VIRTUAL_ENV"
      printf "[\u003E] Project venv : %s\n" "$PWD/.venv"
      printf "[\u003E] Fix: deactivate && source .venv/bin/activate\n"
    fi
  fi
}

### Add the hook
add-zsh-hook chpwd _check_python_env_state
```

### Consolidated Mise Config
Default location: ```~/.config/mise/config.toml```
```bash
[tools]
clojure = "1.12.4"
go = "1.25.5"
java = "21"
node = "24.12.0"
python = "3.14.2"
uv = "latest"

[settings]
# Let Mise detect and automatically use the venv that uv creates
# Requires trusted project level mise.toml
# Might get clingy if you want to deactivate
# python.uv_venv_auto = true

[env]
GIT_AK = "/Users/anuj/data/workspace/git/anujsrc"
```

# Ubuntu (2024 and earlier)
Dev Environment for Ubuntu that sets up these tools-

* [zsh](https://github.com/robbyrussell/oh-my-zsh)
* Liquid Prompt
* [vim](http://www.vim.org/)
  - All the base Vim plug-ins for Clojure
* [emacs-25](https://www.gnu.org/software/emacs/)
* [Screen](https://www.gnu.org/software/screen/)
* [Solarized Theme](https://github.com/Anthony25/gnome-terminal-colors-solarized)
* Inconsolata and Hermit fonts

## Usage
Run [setup.sh](https://github.com/anujsrc/env/blob/master/setup.sh)

## Disk Partitions
A typical single HDD partitions can be done as shown below-

![Disk Partitions](https://github.com/anujsrc/env/blob/master/references/disk-partitions.png "Disk Partitions")

## Utilities
Here are some of the utilities-

* [Setup Docker](https://github.com/anujsrc/env/blob/master/setup-docker.sh)
* [Setup Virtualbox](https://github.com/anujsrc/env/blob/master/setup-virtualbox.sh)
* [Setup Vagrant](https://github.com/anujsrc/env/blob/master/setup-vagrant.sh)
* [Setup Nvidia-Prime-Bumblebee](https://github.com/anujsrc/env/blob/master/setup-graphics.sh)
* [Setup Tensorflow](https://github.com/anujsrc/env/blob/master/setup-tensorflow.sh)
* [Build Emacs25](https://github.com/anujsrc/env/blob/master/setup-emacs.sh)
* [Restart Network](https://github.com/anujsrc/env/blob/master/restart-network.sh)

## Checklists and Cheatsheets
Here are some of the checklists and references that are always handy-

* [Ubuntu-16.04 Installation Notes](https://github.com/anujsrc/env/blob/master/checklists/config.txt)
* [Emacs Quick Reference](https://github.com/anujsrc/env/blob/master/references/emacsup.txt)
* [Docker/Vagrant/VirtualBox Quick Reference](https://github.com/anujsrc/env/blob/master/checklists/container.txt)

### Secure boot and VirtualBox Component Signing
VirtualBox requires the components to be signed and key to be enrolled with to
work with Secureboot. To do so, first generate the keys using the command-

```
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=Descriptive name/"
```
Above command will generate two files ``MOK.priv`` and ``MOK.der``. To sign
VirtualBox components execute the script
[sign-vboxmods.sh](https://github.com/anujsrc/env/blob/master/sign-vboxmods.sh)
in the same folder where the ``MOK.*`` files have been generated. Once you have
signed the components, you need to enroll the key (only once) as shown below-

```
sudo mokutil --import MOK.der
```
Now, reboot the machine, enrol the key from the manager screen and probe the
component as shown below-

```
sudo modprobe vboxdrv
```

### Kernel Upgrades and DKMS Key Issues
If you update your kernel, you need to make sure that all your DKMS modules are installed.
Run ``build-dkms-modules.sh`` to fix one of these issues-

```
% dkms status
bbswitch, 0.8, 4.4.0-59-generic, x86_64: installed
bbswitch, 0.8, 4.4.0-62-generic, x86_64: installed (WARNING! Diff between built
and installed module!)
bbswitch, 0.8, 4.4.0-64-generic, x86_64: installed (WARNING! Diff between built
and installed module!)
nvidia-375, 375.39, 4.4.0-59-generic, x86_64: installed
nvidia-375, 375.39, 4.4.0-62-generic, x86_64: installed (WARNING! Diff between
built and installed module!) (WARNING! Diff between built and installed module!)
(WARNING! Diff between built and installed module!) (WARNING! Diff between built
and installed module!)
nvidia-375, 375.39, 4.4.0-64-generic, x86_64: installed (WARNING! Diff between
built and installed module!) (WARNING! Diff between built and installed module!)
(WARNING! Diff between built and installed module!) (WARNING! Diff between built
and installed module!)
```

### Nvidia and Secure Boot with Debian-12 (Bookworm)
Follow the steps mentioned in the following wiki pages to setup signed Nvidia drivers and CUDA with Secure Boot:
* [Nvidia Graphics Driver](https://wiki.debian.org/NvidiaGraphicsDrivers#bookworm-525)
* [Sign Modules with Your Keys](https://wiki.debian.org/SecureBoot#Using_your_key_to_sign_modules)
