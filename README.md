# MiniZinc Installer for Linux (Bundle Version)

This repository provides a simple and safe script to install the latest **MiniZinc** bundle release on a fresh Debian-based or Arch-based Linux system.

## Why This Script?

MiniZinc's recent versions bundle OR-Tools as a shared library, which can lead to errors like:

```
error while loading shared libraries: libabsl_flags_parse.so...
```

This happens because the required shared libraries are not found by default. The script solves this problem by wrapping the `minizinc` binary in a script that correctly sets the `LD_LIBRARY_PATH`. This avoids polluting the global environment and keeps the fix local to MiniZinc.

## Background and References

For more context on this problem and the recommended solution, see:
- [Issue #895](https://github.com/MiniZinc/libminizinc/issues/895)
- [Issue #889](https://github.com/MiniZinc/libminizinc/issues/889)
- [Issue #945](https://github.com/MiniZinc/libminizinc/issues/945)

## Usage

Depending on your Linux distribution, you can use one of the following scripts:

### For Debian-based Systems
```bash
bash ./installer-debian.sh
```
### For Arch-based Systems
```bash
bash ./installer-arch.sh
```

This will:
- Download the latest MiniZinc bundle for Linux
- Extract it to `/opt/MiniZinc`
- Set up a `minizinc` command in `/usr/local/bin` with a wrapper for the library path

## License

This project is licensed under the GNU General Public License v3.0 (GPLv3).
