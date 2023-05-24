# Go GUI Sample

This project uses Go and Fyne to build a cross-platform application for managing and converting fonts. It specifically includes a process to download and update the M+ Fonts.

## Requirements
- macOS 10.15+
- Go 1.20+
- Homebrew

## Instructions

### Dependencies

#### macOS
```shell
brew install go
brew install mingw-w64
```

### Prepare development environment

Before you start, you need to prepare your development environment by installing the necessary Go packages and ensuring that the Fyne command-line tool is up to date:

```shell
make prepare
```

### Running the application

To launch the application:

```shell
make run
```

### Building the application

The makefile contains tasks for building the application for Windows and macOS.

To build for Windows:

```shell
make build-win
```

To build for macOS:

```shell
make build-mac
```

### Updating Fonts

To download and update the M+ Fonts:

```shell
make update-fonts
```

### Clean Up

To remove all generated files:

```shell
make clean
```

To remove all downloaded fonts:

```shell
make clean-fonts
```

## License

This project is licensed under the MIT License. See the LICENSE file for more information.