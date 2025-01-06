# Alpine Kiosk System

This repository contains the files and scripts to automate the creation of a lightweight Linux image based on Alpine Linux. The system is designed to serve as a diskless, kiosk-style environment, optimized for running a Chromium-based browser in kiosk mode. The project utilizes iPXE for network booting and supports OverlayFS for ephemeral or persistent changes.

## Features

- **Lightweight System**: Based on Alpine Linux, ensuring a minimal footprint.
- **Chromium Browser**: Pre-configured for kiosk mode with features like full-screen browsing and session resilience.
- **Network Booting**: Compatible with iPXE for diskless deployment.
- **OverlayFS Support**: Allows the base system to remain read-only while enabling temporary or persistent changes.
- **Automation**: Includes GitHub Actions workflow for automated builds.

## System Requirements

- **Hardware**:
  - x86_64 architecture
  - Minimum 1GB RAM
  - Network interface supporting PXE

- **Software**:
  - iPXE boot environment
  - Server for hosting boot files (e.g., HTTP, TFTP)

## File Structure

- `build_image.sh`: Script to create the Alpine Linux image.
- `vmlinuz`: Kernel file.
- `initramfs`: Initial RAM filesystem with OverlayFS support.
- `alpine-kiosk.squashfs`: SquashFS image of the base system.
- `.github/workflows/build.yml`: GitHub Actions workflow for automated builds.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/LuizPlatt/alpine-kiosk.git
   cd alpine-kiosk
   ```

2. Run the build script to generate the necessary boot files:
   ```bash
   chmod +x build_image.sh
   ./build_image.sh
   ```

3. Upload the generated files (`vmlinuz`, `initramfs`, `alpine-kiosk.squashfs`) to a web server or GitHub.

4. Configure iPXE with the following script:
   ```
   #!ipxe
   dhcp
   set base-url https://raw.githubusercontent.com/LuizPlatt/alpine-kiosk/main
   kernel ${base-url}/vmlinuz initrd=initramfs root=/dev/ram0 init=/init
   initrd ${base-url}/initramfs
   imgargs vmlinuz root=/dev/ram0 init=/init quiet
   boot
   ```

## Usage

1. Boot the target machine via network with the configured iPXE script.
2. The machine will load the Alpine Linux kiosk system and start Chromium in full-screen mode.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue if you have suggestions, bug reports, or improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
