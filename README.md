# CloudPane Prototype

CloudPane Prototype is a Qt 6 tray-style showcase for macOS. It uses a small C++ backend for demo state and QML for the visual presentation, with a GitHub Actions macOS workflow as the primary build path.

## What the prototype includes

- A real menu bar / tray entry on macOS
- A frameless popup-style window inspired by the reference tray UI
- Two views: overview and sync activity
- Deterministic mock sync progress driven by C++ models and timers
- A GitHub Actions build that produces a zipped `.app` artifact

## Build strategy

The intended path is GitHub-first:

1. Push this repository to GitHub.
2. Let the `Build macOS Prototype` workflow run on a macOS runner.
3. Download the `CloudPanePrototype-macos` artifact from the workflow run.
4. Unzip the artifact on your Mac and open `CloudPane Prototype.app`.

This avoids installing Qt locally on your Mac.

## Running the GitHub-built artifact

GitHub Actions will produce an unsigned prototype app. On first launch, macOS may block it because it is not signed or notarized yet.

If Finder blocks the app:

- Right-click the app and choose `Open`
- Or remove quarantine after unzipping:

```bash
xattr -dr com.apple.quarantine "CloudPane Prototype.app"
```

Signing and notarization are intentionally out of scope for this prototype.

## GitHub Actions workflow

The workflow file is at [`.github/workflows/build-macos.yml`](/Users/Rello/Downloads/docker/QMLApp/.github/workflows/build-macos.yml).

It will:

- run on `macos-latest`
- provision Qt 6.7.3 with SVG support
- build the app through [`scripts/build-macos.sh`](/Users/Rello/Downloads/docker/QMLApp/scripts/build-macos.sh)
- zip the resulting `.app`
- upload the zip as a workflow artifact

## Optional local build

If you later want a local build, you need:

- Xcode command line tools or full Xcode
- CMake
- Qt 6 with `Core`, `Gui`, `Qml`, `Quick`, `QuickControls2`, `Svg`, and `Widgets`

Then run:

```bash
chmod +x scripts/build-macos.sh
./scripts/build-macos.sh
```

If Qt is not in a standard `~/Qt/...` location, export `QT_ROOT_DIR` first.

## Project layout

- [`CMakeLists.txt`](/Users/Rello/Downloads/docker/QMLApp/CMakeLists.txt): Qt/CMake project definition
- [`src/appcontroller.h`](/Users/Rello/Downloads/docker/QMLApp/src/appcontroller.h): popup state and routing controller
- [`src/syncactivitymodel.h`](/Users/Rello/Downloads/docker/QMLApp/src/syncactivitymodel.h): C++ sync activity model
- [`qml/Main.qml`](/Users/Rello/Downloads/docker/QMLApp/qml/Main.qml): root tray popup UI
- [`scripts/build-macos.sh`](/Users/Rello/Downloads/docker/QMLApp/scripts/build-macos.sh): local and CI bootstrap build script
- [`.github/workflows/build-macos.yml`](/Users/Rello/Downloads/docker/QMLApp/.github/workflows/build-macos.yml): GitHub macOS build pipeline
