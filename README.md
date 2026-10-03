# Fedora KDE Black Theme - Sergio

Configuración personalizada de KDE Plasma para Fedora KDE basada en una apariencia oscura/negra, Kvantum, Papirus Dark y carpetas Teal.

Diseñada originalmente para mi instalación personal de Fedora KDE.

---

## Resumen

Configuración principal:

| Componente | Configuración |
|---|---|
| KDE Colors | `CatppuccinMacchiatoBlack_sergio` |
| Plasma Style | Breeze Dark |
| Window Decoration | Breeze |
| Qt / Kvantum | `catppuccin-macchiato-black-sergio` |
| Icon Theme | Papirus-Dark |
| Folder Color | Teal |
| Terminal | Kitty |

El objetivo del tema es mantener una interfaz muy oscura y neutral, conservando los acentos Teal de Catppuccin.

---

## Captura del esquema de colores

Los colores principales utilizados por Black Sergio son:

### Dolphin / View

```text
BackgroundNormal    #111216
BackgroundAlternate #0D0E11
```

### Window

```text
BackgroundNormal    #0D0E11
BackgroundAlternate #0A0B0E
```

### Kvantum

```text
window.color   #111216
base.color     #0D0E11
alt.base.color #0D0E11
```

---

## Estructura del repositorio

```text
fedora-kde-black-theme-sergio/
├── README.md
├── install.sh
├── kde/
│   └── colors/
│       └── CatppuccinMacchiatoBlack_sergio.colors
├── kvantum/
│   └── catppuccin-macchiato-black-sergio/
│       ├── catppuccin-macchiato-black-sergio.kvconfig
│       └── catppuccin-macchiato-black-sergio.svg
└── kitty/
    ├── kitty.conf
    └── current-theme.conf
```

---

# Requisitos

Antes de ejecutar `install.sh` deben estar instalados:

- KDE Plasma
- Kvantum
- Kitty
- Papirus Icon Theme
- Papirus Folders

En Fedora, las herramientas principales de KDE ya están disponibles normalmente con Plasma.

El instalador comprueba los requisitos antes de modificar la configuración.

---

# Instalar Papirus Icon Theme desde GitHub

Repositorio oficial:

https://github.com/PapirusDevelopmentTeam/papirus-icon-theme

Papirus proporciona un instalador independiente de la distribución.

Para KDE, la documentación oficial permite instalar los iconos directamente dentro del directorio del usuario:

```bash
wget -qO- https://git.io/papirus-icon-theme-install | \
  env DESTDIR="$HOME/.local/share/icons" sh
```

Esto instala las variantes de Papirus dentro de:

```text
~/.local/share/icons/
```

Entre ellas:

```text
Papirus
Papirus-Dark
Papirus-Light
```

Este proyecto utiliza:

```text
Papirus-Dark
```

Para comprobarlo:

```bash
ls ~/.local/share/icons/Papirus-Dark
```

## Actualizar Papirus

Según la documentación oficial de Papirus, se utiliza exactamente el mismo comando empleado durante la instalación:

```bash
wget -qO- https://git.io/papirus-icon-theme-install | \
  env DESTDIR="$HOME/.local/share/icons" sh
```

---

# Instalar Papirus Folders desde GitHub

Papirus Folders permite modificar el color de las carpetas de Papirus.

Repositorio oficial:

https://github.com/PapirusDevelopmentTeam/papirus-folders

Para instalarlo localmente para el usuario:

```bash
wget -qO- https://git.io/papirus-folders-install | \
  env PREFIX="$HOME/.local" sh
```

El ejecutable quedará normalmente en:

```text
~/.local/bin/papirus-folders
```

Asegúrate de que `~/.local/bin` se encuentre en `$PATH`.

En Zsh se puede agregar a `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Después:

```bash
exec zsh
```

Verificar:

```bash
command -v papirus-folders
```

Debe devolver algo similar a:

```text
/home/usuario/.local/bin/papirus-folders
```

---

## Ver colores disponibles

```bash
papirus-folders -l --theme Papirus-Dark
```

Black Sergio utiliza:

```text
teal
```

Para aplicarlo manualmente:

```bash
papirus-folders -C teal --theme Papirus-Dark
```

Para restaurar el color predeterminado de Papirus-Dark:

```bash
papirus-folders -D --theme Papirus-Dark
```

---

# Instalación de Black Sergio

Clonar el repositorio:

```bash
git clone <URL-DEL-REPOSITORIO>
```

Entrar al directorio:

```bash
cd fedora-kde-black-theme-sergio
```

Dar permisos al instalador:

```bash
chmod +x install.sh
```

Ejecutar:

```bash
./install.sh
```

El script comprobará primero que todos los requisitos estén disponibles.

---

# Qué realiza `install.sh`

El instalador:

1. Comprueba las dependencias.
2. Comprueba que Papirus-Dark esté instalado.
3. Comprueba que `papirus-folders` esté disponible.
4. Crea un backup de la configuración actual.
5. Instala el esquema de colores Black Sergio.
6. Instala el tema Kvantum Black Sergio.
7. Instala la configuración de Kitty.
8. Selecciona Breeze Dark como Plasma Style.
9. Selecciona Breeze como Window Decoration.
10. Selecciona Black Sergio como KDE Color Scheme.
11. Selecciona Black Sergio en Kvantum.
12. Selecciona Papirus-Dark.
13. Cambia las carpetas de Papirus-Dark a Teal.
14. Actualiza las cachés de KDE e iconos.

---

# Backups

Antes de realizar cambios, `install.sh` crea automáticamente un backup.

Los backups se almacenan en:

```text
~/.local/share/fedora-kde-black-theme-sergio/backups/
```

Cada ejecución utiliza un directorio diferente basado en fecha y hora.

Ejemplo:

```text
~/.local/share/fedora-kde-black-theme-sergio/backups/20261003-190000/
```

---

# Después de instalar

Para asegurarse de que Plasma recargue completamente:

1. Cierra la sesión de KDE Plasma.
2. Vuelve a iniciar sesión.

Después debería estar activo:

```text
KDE Colors         CatppuccinMacchiatoBlack_sergio
Plasma Style       Breeze Dark
Window Decoration  Breeze
Kvantum            catppuccin-macchiato-black-sergio
Icons              Papirus-Dark
Folder Color       Teal
```

---

# Nota

Este repositorio contiene únicamente la configuración **Black Sergio**.

El tema original **Teal Sergio** se mantiene como proyecto independiente y no es modificado por este instalador.

---

## Autor

Configuración solicitada por Sergio.

Documentación e instalador preparados con ChatGPT.

Fecha de creación: 3 de octubre de 2026.
