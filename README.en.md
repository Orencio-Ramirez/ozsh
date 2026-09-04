# ozsh

Modular **Zsh configuration for Linux**. ozsh combines an informative prompt, terminal navigation, history, keybindings, and small integrations for daily work with Git, Python, Docker, and Terraform.

It is not a framework or a standalone distribution: it is a collection of `.zsh` files loaded from `~/.zshrc` by the installer.

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Shell](https://img.shields.io/badge/shell-zsh-green.svg)
![Platform](https://img.shields.io/badge/platform-Debian%2013%2B%20%7C%20Fedora%2042%2B-red.svg)
![Version](https://img.shields.io/badge/version-0.4-orange.svg)


🌐 **Languages:** [Español](README.md) | English

## 🤖 Development and translation

ozsh is under active development and is being built with the assistance of artificial intelligence tools. Technical decisions, code review, and validation remain part of the project's development process.

A complete English translation of the project is being considered and will be introduced progressively. `README.en.md` is currently the available parallel reference.

---

## 🚀 What it includes

### Prompt

The prompt is displayed over two lines and includes, when applicable:

* Date and time.
* The last command's exit code when it is not zero.
* The previous command's execution time.
* User, shortened host name, and current directory.
* SSH session indicator.
* Git branch and modified status.
* Python or Conda virtual environment.
* File-based detection of Docker and Terraform projects.
* Visual distinction for the root user.

Docker and Terraform detection does not connect to their services or execute those tools: it looks for characteristic files in the current directory.

### Terminal

* Completion through `zsh-completions`.
* Autosuggestions and syntax highlighting.
* Shared, immediate history with up to 100,000 entries.
* History search with `Ctrl+R`.
* File search with `Ctrl+T`.
* Directory search with `Alt+C`.
* Substring history search with the up and down arrows.
* Smart navigation through Zoxide.
* Automatic Direnv hook.

### Commands and aliases

* `ls`, `l`, `ll`, `la`, `lt`, `ltt`, and `lsd`: Eza views.
* `cat` and `ccat`: Bat-based file viewing.
* `cd`: navigation through Zoxide.
* `zd`: Zsh's traditional `cd`.
* `zf`: interactive selection among directories known by Zoxide.

The `cat`, `ls`, and `cd` aliases change their usual behavior in the interactive session.

---

## 🧹 Bulk filename cleanup

The `plugins/zmv.zsh` file includes `limpiar-nombres`, a function built on `zmv` for bulk file renaming.

The function can:

* Remove a literal text string.
* Remove content inside parentheses `()` and square brackets `[]`.
* Collapse repeated spaces and trim extra spaces.
* Remove a specified number of characters from the beginning or end.
* Remove text before the first digit.
* Pad one- or two-digit numbers with zeroes to three positions.
* Replace the space after a digit with ` - `.

The file extension is kept separate from these transformations. Only regular files are processed, and `zmv` displays the operations it performs.

Enable it in the current session with:

```zsh
source plugins/zmv.zsh
limpiar-nombres --ayuda
```

Always test with `--simular` before applying a rename:

```zsh
limpiar-nombres --simular '*.jpg'
limpiar-nombres --simular --eliminar 'copy' --prefijo --guion '*.mp4'
```

Without `--simular`, the function applies the changes immediately. The default pattern is `*`; hidden files are excluded unless the pattern names them explicitly or `glob_dots` is enabled.

---

## 📋 Requirements

The installer detects distribution families through `/etc/os-release` and has explicit paths for:

* Debian, Ubuntu, and derivatives that correctly declare their family.
* Fedora and derivatives that correctly declare their family.

You also need:

* An existing checkout at `$HOME/ozsh`.
* `curl` available to check access to GitHub.
* `sudo` privileges.
* An Internet connection.
* An `es_ES.UTF-8` locale, which is set by the generated configuration.

There is no tested version matrix. The installer does not directly support Arch, openSUSE, Alpine, Gentoo, macOS, BSD, or Windows.

---

## ⚙️ Installation

```bash
git clone https://github.com/Orencio-Ramirez/ozsh.git "$HOME/ozsh"
cd "$HOME/ozsh"
chmod +x install.sh
./install.sh
```

The installer:

1. Checks the repository and reads the version from `VERSION`.
2. Checks the connection to GitHub and requests privileges.
3. Installs `zsh`, `git`, `curl`, `bat`, `eza`, `fzf`, `direnv`, and `zoxide` through `apt` or `dnf`.
4. Clones or updates four external plugins under `externos/`.
5. Backs up the existing `~/.zshrc`, if present.
6. Generates a new `~/.zshrc` and sets Zsh as the default shell.

The installation log is stored at `~/ozsh-install.log`. Each run regenerates `~/.zshrc`; review the backup before reinstalling if you have custom configuration. External plugin updates use `git reset --hard` and discard local changes in those clones.

After installation, log out and back in to use Zsh as the default shell.

---

## 📦 Components

### Installed dependencies

```text
zsh  git  curl  bat  eza  fzf  direnv  zoxide
```

On Debian/Ubuntu, Bat's executable may be named `batcat`; the configuration supports both variants.

### External plugins

The installer obtains these repositories:

* `zsh-users/zsh-completions`
* `zsh-users/zsh-autosuggestions`
* `zsh-users/zsh-syntax-highlighting`
* `zsh-users/zsh-history-substring-search`

### Structure

```text
core/       Options, variables, colors, icons, history, hooks, prompt, and keys
modules/    Git, Docker, Python, SSH, root, timer, Terraform, and hostname
plugins/    FZF, Bat, Eza, Zoxide, Direnv, and Zsh integrations and aliases
externos/   Cloned external plugins
media/      Graphic assets
install.sh  Installer and .zshrc generator
VERSION     Project version
```

The default installation loads every file in `core`, seven modules, and nine plugins. `modules/hostname.zsh` and `plugins/zmv.zsh` exist but are not loaded automatically.

---

## 🎨 Customization

Main customization points:

```text
core/colors.zsh       Colors
core/icons.zsh        Icons
core/options.zsh      Zsh options
core/history.zsh      History
core/keybindings.zsh  Keyboard shortcuts
plugins/*.zsh         Integrations and aliases
```

The generated configuration sets `EDITOR` and `VISUAL` to `nano`, as well as `LANG` and `LC_ALL` to `es_ES.UTF-8`. Change them after installation if needed, or adjust the `.zshrc` generator.

---

## 🖥️ Preview

![ozsh prompt with JetBrainsMono Nerd Font](media/ozsh.jpg)

Prompt icons require a font with compatible glyphs, such as **JetBrainsMono Nerd Font**. Without one, the configuration may display missing or unreadable symbols.

---

## 📌 Project status

Current version: `0.4`.

ozsh is still evolving. There are no automated tests for installation, distribution compatibility, or prompt rendering; capabilities and configuration may change between versions.

---

## 📄 License

Distributed under the **GNU General Public License v3.0 (GPL-3.0)**.
