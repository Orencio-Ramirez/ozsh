# ozsh

Configuración modular de **Zsh para Linux**. ozsh reúne un prompt informativo, navegación de terminal, historial, atajos y pequeñas integraciones para el trabajo diario con Git, Python, Docker y Terraform.

No es un framework ni una distribución independiente: es un conjunto de archivos `.zsh` que el instalador carga desde `~/.zshrc`.

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Shell](https://img.shields.io/badge/shell-zsh-green.svg)
![Platform](https://img.shields.io/badge/platform-Debian%2013%2B%20%7C%20Fedora%2042%2B-red.svg)
![Version](https://img.shields.io/badge/version-0.4-orange.svg)

🌐 **Idiomas:** Español | [English](README.en.md)

## 🤖 Desarrollo y traducción

ozsh se encuentra en desarrollo y se construye con ayuda de herramientas de inteligencia artificial. Las decisiones técnicas, la revisión y la validación del código forman parte del proceso de desarrollo.

La traducción completa del proyecto al inglés está contemplada y se incorporará progresivamente. `README.en.md` es la referencia paralela disponible actualmente.

---

## 🚀 Qué incluye

### Prompt

El prompt se muestra en dos líneas e incluye, cuando corresponde:

* Fecha y hora.
* Código de salida del último comando si no es cero.
* Tiempo de ejecución del comando anterior.
* Usuario, host abreviado y directorio actual.
* Indicador de sesión SSH.
* Rama y estado modificado de Git.
* Entorno virtual de Python o Conda.
* Detección por archivos de proyectos Docker y Terraform.
* Diferenciación visual del usuario root.

La detección de Docker y Terraform no conecta con sus servicios ni ejecuta esas herramientas: busca archivos característicos en el directorio actual.

### Terminal

* Autocompletado mediante `zsh-completions`.
* Autosuggestions y resaltado de sintaxis.
* Historial compartido, inmediato y con hasta 100000 entradas.
* Búsqueda del historial con `Ctrl+R`.
* Búsqueda de archivos con `Ctrl+T`.
* Búsqueda de directorios con `Alt+C`.
* Navegación por coincidencia parcial con las flechas arriba y abajo.
* Navegación inteligente mediante Zoxide.
* Hook automático de Direnv.

### Comandos y alias

* `ls`, `l`, `ll`, `la`, `lt`, `ltt` y `lsd`: vistas de Eza.
* `cat` y `ccat`: visualización mediante Bat.
* `cd`: navegación mediante Zoxide.
* `zd`: `cd` tradicional de Zsh.
* `zf`: selección interactiva entre directorios conocidos por Zoxide.

Los alias `cat`, `ls` y `cd` cambian su comportamiento habitual en la sesión interactiva.

---

## 🧹 Limpieza masiva de nombres

El archivo `plugins/zmv.zsh` incluye la función `limpiar-nombres`, basada en `zmv`, para renombrar archivos de forma masiva.

La función puede:

* Eliminar una cadena de texto literal.
* Eliminar contenido entre paréntesis `()` y corchetes `[]`.
* Reducir espacios repetidos y eliminar espacios sobrantes.
* Quitar un número determinado de caracteres al principio o al final.
* Eliminar el texto anterior a la primera cifra.
* Completar con ceros los números de una o dos cifras hasta tres posiciones.
* Sustituir el espacio posterior a una cifra por ` - `.

La extensión se conserva separada de las transformaciones. Solo se procesan archivos regulares y `zmv` muestra las operaciones realizadas.

Para habilitarla en una sesión:

```zsh
source plugins/zmv.zsh
limpiar-nombres --ayuda
```

Se recomienda probar siempre con `--simular` antes de renombrar:

```zsh
limpiar-nombres --simular '*.jpg'
limpiar-nombres --simular --eliminar 'copia' --prefijo --guion '*.mp4'
```

Sin `--simular`, la función aplica los cambios directamente. El patrón por defecto es `*`; los archivos ocultos no se incluyen salvo que el patrón los especifique o se active `glob_dots`.

---

## 📋 Requisitos

El instalador detecta familias de distribución mediante `/etc/os-release` y tiene rutas específicas para:

* Debian, Ubuntu y derivados que declaren correctamente su familia.
* Fedora y derivados que declaren correctamente su familia.

Antes de ejecutarlo también se necesita:

* Una instalación existente en `$HOME/ozsh`.
* `curl` disponible para comprobar el acceso a GitHub.
* Privilegios `sudo`.
* Una conexión a Internet.
* Una locale `es_ES.UTF-8`, establecida por la configuración generada.

No hay una matriz de versiones probadas. El instalador no admite directamente Arch, openSUSE, Alpine, Gentoo, macOS, BSD ni Windows.

---

## ⚙️ Instalación

```bash
git clone https://github.com/Orencio-Ramirez/ozsh.git "$HOME/ozsh"
cd "$HOME/ozsh"
chmod +x install.sh
./install.sh
```

El instalador:

1. Comprueba el repositorio y lee la versión desde `VERSION`.
2. Verifica la conexión con GitHub y solicita privilegios.
3. Instala `zsh`, `git`, `curl`, `bat`, `eza`, `fzf`, `direnv` y `zoxide` mediante `apt` o `dnf`.
4. Clona o actualiza cuatro plugins externos en `externos/`.
5. Guarda una copia temporal de `~/.zshrc`, si existe.
6. Genera un nuevo `~/.zshrc` y configura Zsh como shell predeterminada.

El registro de instalación se guarda en `~/ozsh-install.log`. Cada ejecución vuelve a generar `~/.zshrc`; revisa la copia de seguridad antes de reinstalar si tienes configuración propia. Las actualizaciones de plugins externos usan `git reset --hard` y descartan cambios locales en esos clones.

Después de instalar, cierra la sesión y vuelve a iniciarla para usar Zsh como shell predeterminada.

---

## 📦 Componentes

### Dependencias instaladas

```text
zsh  git  curl  bat  eza  fzf  direnv  zoxide
```

El nombre del ejecutable de Bat puede ser `batcat` en Debian/Ubuntu; la configuración contempla ambas variantes.

### Plugins externos

El instalador obtiene estos repositorios:

* `zsh-users/zsh-completions`
* `zsh-users/zsh-autosuggestions`
* `zsh-users/zsh-syntax-highlighting`
* `zsh-users/zsh-history-substring-search`

### Estructura

```text
core/       Opciones, variables, colores, iconos, historial, hooks, prompt y teclas
modules/    Git, Docker, Python, SSH, root, temporizador, Terraform y hostname
plugins/    Integraciones y alias para FZF, Bat, Eza, Zoxide, Direnv y Zsh
externos/   Clones de plugins externos
media/      Recursos gráficos
install.sh  Instalador y generador de .zshrc
VERSION     Versión del proyecto
```

La instalación predeterminada carga todos los archivos de `core`, siete módulos y nueve plugins. `modules/hostname.zsh` y `plugins/zmv.zsh` existen, pero no se cargan automáticamente.

---

## 🎨 Personalización

Puntos de entrada principales:

```text
core/colors.zsh       Colores
core/icons.zsh        Iconos
core/options.zsh      Opciones de Zsh
core/history.zsh      Historial
core/keybindings.zsh  Atajos de teclado
plugins/*.zsh         Integraciones y alias
```

La configuración generada establece `EDITOR` y `VISUAL` en `nano`, además de `LANG` y `LC_ALL` en `es_ES.UTF-8`. Si necesitas otros valores, modifícalos después de la instalación o ajusta el generador de `~/.zshrc`.

---

## 🖥️ Vista previa

![Prompt de ozsh con JetBrainsMono Nerd Font](media/ozsh.jpg)

Los iconos del prompt requieren una fuente con glifos compatibles, como **JetBrainsMono Nerd Font**. Sin ella, la configuración puede mostrar símbolos ausentes o ilegibles.

---

## 📌 Estado del proyecto

Versión actual: `0.4`.

ozsh sigue evolucionando. No hay pruebas automatizadas para la instalación, la compatibilidad entre distribuciones ni el renderizado del prompt; las capacidades y la configuración pueden cambiar entre versiones.

---

## 📄 Licencia

Distribuido bajo la **GNU General Public License v3.0 (GPL-3.0)**.
