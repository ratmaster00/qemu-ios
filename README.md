# iPod Touch 1st Generation (iPhoneOS 1.0) QEMU Emulator

An experimental QEMU environment tailored for emulating the 1st Generation iPod Touch (`n45ap` / Samsung S5L8900 SoC). 

This repository contains custom S5L8900 machine definitions, peripheral emulation, pre-patched source files, and launch configurations required to boot into iPhoneOS 1.0.

---

## 📌 Features & Boot Status

* **Target Device:** iPod Touch 1st Gen (`iPod1,1` / `n45ap`)
* **SoC:** Samsung S5L8900 (ARM1176JZF-S)
* **Emulated Peripherals:** Interrupt controller, timers, UART, AES, SHA1, NOR, and multi-bank NAND flash controllers.
* **Boot Sequence:** SecureROM ➔ iBoot ➔ XNU Kernel ➔ SpringBoard (iPhoneOS Graphical Desktop).

---

## 🛠 Prerequisites

Install the required build tools and dependencies for your Linux distribution:

### Arch Linux / EndeavourOS
```bash
sudo pacman -S glib2 pixman ninja python python-setuptools sdl2 openssl base-devel libslirp git wget unzip

```

### Fedora

```bash
sudo dnf install gcc gcc-c++ make ninja-build python3 python3-setuptools glib2-devel pixman-devel \
  SDL2-devel openssl-devel libslirp-devel git wget unzip

```

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install build-essential ninja-build python3 python3-setuptools pkg-config \
  libglib2.0-dev libpixman-1-dev libsdl2-dev libssl-dev libslirp-dev git wget unzip

```

---

## 🚀 Building the Emulator

### 1. Clone the Repository

```bash
git clone https://github.com/ratmaster00/qemu-ios.git --branch ipod_touch_1g
cd qemu-ios

```

### 2. Configure & Build

Run the build script configuration from the repository root:

```bash
mkdir build && cd build

../configure \
  --target-list=arm-softmmu \
  --enable-sdl \
  --disable-xkbcommon \
  --disable-install-blobs \
  --disable-guest-agent \
  --disable-libnfs \
  --disable-bpf \
  --disable-libusb \
  --disable-smartcard \
  --disable-opengl \
  --disable-virglrenderer \
  --disable-curses \
  --disable-gtk \
  --disable-vte \
  --disable-vnc \
  --disable-spice \
  --disable-docs \
  --extra-cflags="-Wno-error" \
  --extra-ldflags="-lcrypto"

ninja qemu-system-arm
cd ..
```

haven't tested, you might also need to run `make -j$(nproc)` and let it error out, before running ninja. 
*Note: The build process takes roughly 5–15 minutes depending on your CPU. Compiling warnings are normal.*

---

## 📦 Firmware Files Setup

The emulator requires firmware binaries (`bootrom`, `iboot`, `nor`, and unpacked `nand` dumps).

If they are not present in your repository root, fetch them from the upstream release assets:

```bash
wget https://github.com/devos50/qemu-ios/releases/download/n45ap_v1/bootrom_s5l8900
wget https://github.com/devos50/qemu-ios/releases/download/n45ap_v1/iboot_204_n45ap.bin
wget https://github.com/devos50/qemu-ios/releases/download/n45ap_v1/nor_n45ap.bin
wget https://github.com/devos50/qemu-ios/releases/download/n45ap_v1/nand_n45ap.zip
unzip nand_n45ap.zip
```

Verify that you have a `nand/` directory containing `bank0` through `bank7` in the repository root.

---

## 🎮 Launching & Controls

### Launch

Use this QEMU command:

```bash
build/qemu-system-arm \
    -M iPod-Touch,bootrom=bootrom_s5l8900,iboot=iboot_204_n45ap.bin,nand=nand \
    -serial mon:stdio \
    -cpu max \
    -m 1G \
    -d unimp \
    -drive file=nor_n45ap.bin,format=raw,if=pflash
```

### Emulator Controls

| Key / Input | Action |
| --- | --- |
| **H** | Home Button |
| **P** | Power Button |
| **Mouse Click** | Touchscreen Input |

---

## 🔍 Troubleshooting

* **Unimplemented Hardware Warnings (`unimp`):** Normal behavior in stdout. The emulator logs unimplemented register hits while proceeding with boot.
* **Stuck on Black Screen:** The display may remain black for 1–2 minutes while the XNU Kernel initializes before SpringBoard renders.
* **Dropped to iBoot prompt (`]`):** If dropped into recovery mode, type `fsboot` in the terminal prompt to continue booting into the filesystem.
* **Missing `libslirp.so.0`:** Install `libslirp` via your package manager.

---

## 📜 License & Credits

* Based on the original QEMU iOS reverse-engineering work by **devos50**.
* Distributed under the GNU General Public License v2 (GPLv2).
* For any issues, contact `.regedit.exe` on Discord, or email me, I might be able to help. 

```
