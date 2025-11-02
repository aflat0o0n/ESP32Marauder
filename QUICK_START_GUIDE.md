# Quick Start Guide - ESP32 WROOM with ILI9341 and Physical Buttons

This guide will help you quickly set up and flash your ESP32 WROOM with ILI9341 display and physical buttons for ESP32 Marauder.

## Prerequisites

Before you begin, ensure you have:
- ESP32 WROOM (48-pin module)
- ILI9341 TFT Display (240x320)
- 5 push buttons
- Jumper wires and breadboard (or custom PCB)
- USB cable to connect ESP32 to your computer
- Computer with:
  - Arduino IDE (recommended) OR
  - Arduino CLI OR
  - PlatformIO

## Hardware Setup

### Step 1: Wire the Display

Connect your ILI9341 display to ESP32:

| ILI9341 Pin | ESP32 GPIO | Notes |
|-------------|------------|-------|
| VCC | 3.3V | Power supply |
| GND | GND | Ground |
| CS | GPIO17 | Chip Select |
| RESET | GPIO5 | Reset |
| DC | GPIO16 | Data/Command |
| MOSI | GPIO23 | SPI Master Out |
| SCK | GPIO18 | SPI Clock |
| LED | GPIO4 | Backlight (via 100Ω resistor) |
| MISO | GPIO19 | SPI Master In (optional) |

### Step 2: Wire the Buttons

Connect 5 push buttons (one side to GND, other side to GPIO):

| Button | ESP32 GPIO | Function |
|--------|------------|----------|
| Up | GPIO27 | Navigate up |
| Down | GPIO33 | Navigate down |
| Left | GPIO25 | Go back |
| Right | GPIO32 | Navigate right |
| Center | GPIO26 | Select/Confirm |

**Important:** No external pull-up resistors needed - the firmware uses internal pull-ups.

### Step 3: Optional - Wire SD Card

If you want logging capabilities:

| SD Card Pin | ESP32 GPIO | Notes |
|-------------|------------|-------|
| CS | GPIO12 | Chip Select |
| MOSI | GPIO23 | Shared with display |
| MISO | GPIO19 | Shared with display |
| SCK | GPIO18 | Shared with display |
| VCC | 3.3V | Power |
| GND | GND | Ground |

## Software Setup

### Option A: Using Arduino IDE (Easiest for Beginners)

1. **Install Arduino IDE**
   - Download from: https://www.arduino.cc/en/software
   - Install version 1.8.19 or 2.x

2. **Install ESP32 Board Support**
   - Open Arduino IDE
   - Go to `File → Preferences`
   - Add this URL to "Additional Board Manager URLs":
     ```
     https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
     ```
   - Go to `Tools → Board → Boards Manager`
   - Search for "esp32"
   - Install "esp32 by Espressif Systems" version **2.0.11**

3. **Install Required Libraries**
   - Go to `Tools → Manage Libraries`
   - Search and install each:
     - `NimBLE-Arduino` version 1.3.8
     - `ESP32Ping` version 1.6
     - `MicroNMEA` version 2.0.6
     - `AsyncTCP` by dvarrel
     - `ESPAsyncWebServer` by lacamera

4. **Clone This Repository**
   ```bash
   git clone https://github.com/aflat0o0n/ESP32Marauder.git
   cd ESP32Marauder
   ```

5. **Configure the Build**
   
   **Edit configs.h:**
   - Open `esp32_marauder/configs.h`
   - Find line ~32 and uncomment `ESP32_ILI9341_BUTTONS` (remove the `//` before it):
     ```c
     #define ESP32_ILI9341_BUTTONS  // Remove // from start of line
     ```
   - Ensure all other board definitions are commented out (have `//` before them)

   **Edit User_Setup_Select.h:**
   - Open `User_Setup_Select.h` (in the root folder)
   - Find and uncomment (~line 39):
     ```c
     #include <User_Setup_esp32_ili9341_buttons.h>
     ```
   - Comment out all other `#include <User_Setup_*.h>` lines

6. **Select Board Settings**
   - Go to `Tools → Board → ESP32 Arduino`
   - Select: **"LOLIN D32"** or **"ESP32 Dev Module"**
   - Set these options:
     - Upload Speed: `921600`
     - Flash Frequency: `80MHz`
     - Flash Mode: `DIO`
     - Flash Size: `4MB (32Mb)`
     - Partition Scheme: **"Minimal SPIFFS (1.9MB APP with OTA/190KB SPIFFS)"**
     - Core Debug Level: `None`

7. **Open the Sketch**
   - Open `esp32_marauder/esp32_marauder.ino`

8. **Compile and Upload**
   - Connect your ESP32 via USB
   - Select the correct port: `Tools → Port → (your ESP32 port)`
   - Click the **Upload** button (right arrow icon)
   - Wait for compilation and upload (this takes 5-10 minutes first time)

### Option B: Using the Build Script (Linux/Mac)

1. **Clone the Repository**
   ```bash
   git clone https://github.com/aflat0o0n/ESP32Marauder.git
   cd ESP32Marauder
   ```

2. **Run the Build Script**
   ```bash
   chmod +x build_esp32_ili9341_buttons.sh
   ./build_esp32_ili9341_buttons.sh
   ```

3. **Flash the Firmware**
   ```bash
   # Install esptool if needed
   pip install esptool

   # Flash (replace /dev/ttyUSB0 with your port)
   esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 921600 \
     --before default_reset --after hard_reset write_flash -z \
     --flash_mode dio --flash_freq 80m --flash_size detect \
     0x1000 build/esp32_ili9341_buttons/esp32_marauder.ino.bootloader.bin \
     0x8000 build/esp32_ili9341_buttons/esp32_marauder.ino.partitions.bin \
     0xe000 ~/.arduino15/packages/esp32/hardware/esp32/2.0.11/tools/partitions/boot_app0.bin \
     0x10000 build/esp32_ili9341_buttons/esp32_marauder.ino.bin
   ```

### Option C: Pre-compiled Binary (Coming Soon)

Check the [Releases](https://github.com/aflat0o0n/ESP32Marauder/releases) page for pre-compiled binaries.

## First Boot

1. **Power On**
   - Connect ESP32 to power (via USB or external power)
   - The display should show the ESP32 Marauder logo

2. **Test Buttons**
   - Press **CENTER** button - should see a response
   - Use **UP/DOWN** to navigate menu
   - Press **LEFT** to go back
   - Press **CENTER** to select

3. **Verify Display**
   - If display is blank: Check connections
   - If colors are wrong: See troubleshooting below
   - If backlight is off: Check GPIO32 connection

## Basic Usage

### Navigating Menus
- **UP/DOWN**: Move through menu items
- **CENTER**: Select current item
- **LEFT**: Go back to previous menu

### Main Features
1. **WiFi Scanner** - Scan for WiFi networks
2. **Packet Monitor** - Monitor WiFi packets
3. **Bluetooth Scanner** - Scan for BLE devices
4. **Evil Portal** - Captive portal attack
5. **Settings** - Configure device

### Command Line Access
Connect via serial monitor (115200 baud) for CLI access:
```bash
# Using screen (Linux/Mac)
screen /dev/ttyUSB0 115200

# Using Arduino IDE
Tools → Serial Monitor → Set to 115200 baud
```

Type `help` to see available commands.

## Troubleshooting

### Display Not Working

**White/Black screen:**
1. Check all connections, especially CS, DC, RST
2. Verify 3.3V power supply
3. Try swapping MOSI/MISO if using wrong labels

**Wrong colors or inverted:**
1. Edit `User_Setup_esp32_ili9341_buttons.h`
2. Try adding: `#define TFT_INVERSION_ON`
3. Or try: `#define TFT_RGB_ORDER TFT_BGR`

**Garbled display:**
1. Reduce SPI speed in `User_Setup_esp32_ili9341_buttons.h`:
   ```c
   #define SPI_FREQUENCY 20000000  // Was 27000000
   ```

### Buttons Not Working

**No response:**
1. Verify GPIO connections
2. Test with multimeter - should show continuity to GND when pressed
3. Check button wiring - one side to GPIO, other to GND

**Multiple presses:**
1. Clean button contacts
2. Add 100nF capacitor across button terminals

**Stuck button:**
1. Check for short circuits
2. Verify button is not mechanically stuck

### Compilation Errors

**Library not found:**
```
Install missing library through Arduino Library Manager
```

**Multiple definitions:**
```
Ensure only ESP32_ILI9341_BUTTONS is defined in configs.h
```

**ESP32 board not found:**
```
Reinstall ESP32 board support (version 2.0.11)
```

### Upload Errors

**Port not found:**
1. Install CH340/CP2102 USB drivers for your OS
2. Check cable supports data (not just power)

**Brownout detector:**
```
Use external 5V power supply during upload
Add 100uF capacitor on 3.3V rail
```

**Timeout during upload:**
1. Hold BOOT button on ESP32 while uploading
2. Press RESET button before upload starts

## Advanced Configuration

### Changing Button Pins

Edit `esp32_marauder/configs.h`, find `ESP32_ILI9341_BUTTONS` section:
```c
#ifdef ESP32_ILI9341_BUTTONS
  #define L_BTN 13    // Change this
  #define C_BTN 34    // Change this
  #define U_BTN 36    // Change this
  #define R_BTN 39    // Change this
  #define D_BTN 35    // Change this
```

### Changing Display Pins

Edit `User_Setup_esp32_ili9341_buttons.h`:
```c
#define TFT_MISO 19  // Change as needed
#define TFT_MOSI 23
#define TFT_SCLK 18
#define TFT_CS   17
#define TFT_DC   16
#define TFT_RST   5
#define TFT_BL   32
```

## Getting Help

- **Full Documentation**: See `README_ESP32_ILI9341_BUTTONS.md`
- **Original Project**: https://github.com/justcallmekoko/ESP32Marauder
- **Issues**: Report hardware/button-specific issues on this fork
- **General ESP32 Marauder**: Visit the main project for general features

## Safety Warning

⚠️ **Legal Notice**: This tool is for educational and authorized testing purposes only. Ensure you have permission before testing on any networks or devices you don't own. Unauthorized access to computer networks is illegal in most jurisdictions.

## What's Next?

1. **Insert SD Card** (formatted as FAT32) for logging
2. **Explore Features** - Try WiFi scanning
3. **Update Firmware** - Check for updates regularly
4. **Join Community** - Follow development on GitHub

## Pin Reference Card

Print and keep this handy:

```
╔════════════════════════════════════════╗
║   ESP32 Marauder - ILI9341 + Buttons  ║
╠════════════════════════════════════════╣
║ DISPLAY (ILI9341)                      ║
║  CS:  GPIO17    DC:   GPIO16          ║
║  RST: GPIO5     BL:   GPIO32          ║
║  MOSI:GPIO23    MISO: GPIO19          ║
║  SCK: GPIO18                           ║
╠════════════════════════════════════════╣
║ BUTTONS                                ║
║  Up:    GPIO27  Down:  GPIO33         ║
║  Left:  GPIO25  Right: GPIO32         ║
║  Center:GPIO26                         ║
╠════════════════════════════════════════╣
║ SD CARD (Optional)                     ║
║  CS: GPIO12  (Shares SPI with display) ║
╚════════════════════════════════════════╝
```

Happy Hacking! 🎯
