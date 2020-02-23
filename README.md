# yapman

YAPMAN (Yet Another AUR Package Manager) is AUR helper. It is not like any other AUR helper it is much more simple.

## Usage

```bash
yapman init [YapmanPackagesPath]
```

Above command initializes a directory where your git clone's go...
The default value of YapmanPackagesPath is "**~/ext/**".

```bash
yapman -Cu
```

This **c**hecks **u**pdates previously installed aur packages or currently stored in **$YapmanPackagesPath**.

```bash
yapman -I <AUR_URI>
```

Installs the given aur.

```bash
yapman -Ic <AUR_URI>
```

Installs and removes the installed unnecessary dependencies (install time dependencies).

```bash
yapman -Icc <AUR_URI>
```

Installs and removes from **$YapmanPackagesPath** and also clears install-time dependencies.

```bash
yapman -R <package>
```

Removes only folder.


```bash
yapman -Rc <package>
```

Removes the package only.

```bash
yapman -Rcc <package>
```

Removes the package with its dependencies completely.
