# Orencio's ZSH Modular Config

Un sistema de configuración de ZSH modular, rápido y completamente basado en diseño por capas.

No es un “dotfiles suelto”. Es un sistema.

---

## 🧠 Filosofía

Este proyecto está construido bajo 3 principios:

- El prompt NO calcula nada
- El estado se actualiza fuera del prompt
- Todo está separado por responsabilidad

---

## ⚡ Características

### Prompt
- 2 líneas
- tiempo de ejecución de comandos
- exit code visible
- SSH indicator
- root detection
- Git branch + dirty state
- Python venv
- Docker project detection

### UX
- autosuggestions estilo Fish
- syntax highlighting en tiempo real
- fzf integrado (historial, archivos, cd)
- navegación inteligente con zoxide
- direnv automático por proyecto
- ls moderno con eza

---

## 🚀 Instalación

```bash
git clone https://github.com/Orencio-Ramirez/ozsh.git
cd $HOME/ozsh
./install.sh
```

---

## 📦 Dependencias

Instaladas automáticamente en Debian:

* zsh
* git
* fzf
* eza
* direnv
* zoxide
* bat
* curl

Descargadas desde git:

* zsh-syntax-highlight
* zsh-completions
* zsh-autosugestions
* zsh-syntax-highlighting

---

## 🧪 Benchmark

El objetivo del sistema es mantener el prompt extremadamente ligero.

Mediciones típicas:

* cold start: ~10–20ms
* prompt render: <1ms (sin lógica externa)

---

## 🧩 Diseño

### ❌ Anti-patterns evitados

* Git ejecutado en cada prompt
* parsing de estado en render
* lógica dentro del prompt
* plugins monolíticos

### ✅ Diseño actual

* estado precalculado
* hooks centralizados
* módulos independientes
* prompt puro

---

## 🎨 Personalización

Colores e iconos se controlan desde:

```
core/colors.zsh
core/icons.zsh
```

---

## 🔧 Tema

Soporte para temas:

* nord
* dracula
* catppuccin
* tokyonight

---

## 🧠 Ejemplo visual

```
󰥔 2026-06-28 22:41:12   ⏱ 1.24s   ✘127   󰌘 SSH

user ~/projects/homelab   main*  🐍 venv  🐳
❯
```

---

## 📌 Estado del proyecto

Este sistema está diseñado para ser:

* mantenible a largo plazo
* extensible
* rápido
* reproducible

---

## 🧭 Objetivo

Crear un entorno de shell que se sienta como un IDE ligero en terminal, sin frameworks pesados ni dependencias ocultas.
