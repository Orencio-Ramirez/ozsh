# ozsh

Configuración modular de **Zsh** orientada a administradores de sistemas, ingenieros DevOps y usuarios avanzados de Linux.

El objetivo de **ozsh** es proporcionar un entorno de trabajo rápido, mantenible y predecible, evitando frameworks pesados y manteniendo una arquitectura sencilla basada en módulos independientes.

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Shell](https://img.shields.io/badge/shell-zsh-green.svg)
![Platform](https://img.shields.io/badge/platform-Debian%2013%2B-red.svg)

---

## 🚀 Características

### Prompt

* Diseño limpio de dos líneas.
* Fecha y hora.
* Tiempo de ejecución del último comando.
* Código de salida visible.
* Indicador de sesión SSH.
* Detección de usuario root.
* Rama y estado de Git.
* Entorno virtual de Python.
* Detección de proyectos Docker.

### Experiencia de uso

* Autocompletado avanzado.
* Autosuggestions estilo Fish.
* Syntax Highlighting en tiempo real.
* Integración con FZF.
* Navegación inteligente mediante Zoxide.
* Integración automática con Direnv.
* Sustitución moderna de `ls` mediante Eza.
* Visualización mejorada de archivos mediante Bat.

---

## 🧠 Filosofía

ozsh sigue tres principios fundamentales:

* **El prompt nunca calcula información.**
* **El estado se actualiza mediante hooks.**
* **Cada módulo tiene una única responsabilidad.**

Esto permite mantener un prompt rápido y sencillo de mantener.

---

## ❓ ¿Por qué ozsh?

Existen excelentes frameworks como Oh My Zsh, Prezto, Zinit o Antidote.

ozsh adopta un enfoque diferente.

En lugar de proporcionar cientos de plugins y capas de abstracción, se centra en ofrecer una configuración pequeña, modular y completamente explícita.

Cada archivo tiene una única responsabilidad y todo el código puede entenderse fácilmente sin necesidad de conocer un framework.

---

## 📋 Requisitos

Actualmente el proyecto soporta oficialmente:

* Debian 13 o superior.
* Conexión a Internet durante la instalación.

El soporte para Fedora está previsto en futuras versiones.

---

## 🔤 Fuente recomendada

ozsh utiliza iconos de **Nerd Fonts** para representar el estado del sistema y mejorar la legibilidad del prompt.

Se recomienda utilizar:

* **JetBrainsMono Nerd Font**

Sin una Nerd Font instalada, la configuración seguirá funcionando correctamente, pero algunos iconos aparecerán como caracteres Unicode sin representar.

---

## ⚙️ Instalación

```bash
git clone https://github.com/Orencio-Ramirez/ozsh.git "$HOME/ozsh"

cd "$HOME/ozsh"

chmod +x install.sh

./install.sh
```

El instalador:

* Detecta automáticamente el sistema operativo.
* Instala las dependencias necesarias.
* Descarga o actualiza los plugins externos.
* Genera un `.zshrc` limpio.
* Configura Zsh como shell por defecto.
* Puede ejecutarse varias veces de forma segura.

Al finalizar la instalación es recomendable cerrar la sesión e iniciarla de nuevo.

---

## 📦 Dependencias

### Instaladas mediante el gestor de paquetes

* zsh
* git
* curl
* fzf
* eza
* bat
* direnv
* zoxide

### Plugins externos

* zsh-completions
* zsh-autosuggestions
* zsh-syntax-highlighting
* zsh-history-substring-search

---

## 📁 Estructura del proyecto

```text
ozsh/

├── core/          # Configuración base
├── modules/       # Módulos del prompt
├── plugins/       # Integración con herramientas
├── externos/      # Plugins descargados automáticamente
├── install.sh
├── LICENSE
├── README.md
└── VERSION
```

---

## ⚡ Rendimiento

El objetivo principal de ozsh es mantener un prompt rápido y con un coste constante.

Valores habituales en Debian 13:

* Inicio de Zsh: ~70 ms.
* Sin consultas a Git durante el renderizado.
* Estado precalculado mediante hooks.
* Sin lógica compleja dentro del prompt.

---

## 🏗️ Diseño

### Se evita

* Frameworks pesados.
* Lógica dentro del prompt.
* Consultas a Git durante cada renderizado.
* Código monolítico.
* Dependencias innecesarias.

### Se prioriza

* Modularidad.
* Simplicidad.
* Legibilidad.
* Bajo consumo de recursos.
* Mantenimiento a largo plazo.

---

## 🎨 Personalización

Los principales elementos visuales pueden modificarse desde:

```text
core/colors.zsh
core/icons.zsh
```

La configuración está organizada por responsabilidad, por lo que resulta sencillo añadir, eliminar o modificar módulos.

---

## 🖥️ Vista previa

```text
󰥔 2026-06-28 22:41:12   ⏱ 1.24s   ✘127   󰌘 SSH

user ~/projects/homelab   main*  🐍 venv  🐳
❯
```

> **Próximamente:** captura de pantalla del prompt utilizando JetBrainsMono Nerd Font.

---

## 📌 Estado del proyecto

ozsh se encuentra en desarrollo activo.

Los objetivos principales del proyecto son:

* Rapidez.
* Modularidad.
* Reproducibilidad.
* Código sencillo de mantener.
* Entorno de trabajo orientado a administración de sistemas y DevOps.

---

## 📄 Licencia

Este proyecto se distribuye bajo los términos de la **GNU General Public License v3.0 (GPL-3.0)**.
