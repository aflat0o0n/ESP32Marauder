# ESP32 Marauder ILI9341 + Buttons - Build Checklist

Use this checklist to track your build progress and ensure nothing is missed.

## Hardware Assembly

### Components Checklist
- [ ] ESP32 WROOM 48-pin development board
- [ ] ILI9341 TFT display (240x320 pixels)
- [ ] 5× push buttons (momentary, normally open)
- [ ] Jumper wires (Male-to-Female, Male-to-Male)
- [ ] Breadboard OR custom PCB
- [ ] USB cable (data + power capable)
- [ ] Optional: MicroSD card (FAT32 formatted, 32GB max recommended)
- [ ] Optional: MicroSD card module/reader
- [ ] Optional: 100Ω resistor for backlight
- [ ] Optional: 5× 100nF capacitors (for button debouncing)

### Display Wiring
- [ ] VCC → 3.3V (⚠️ NOT 5V!)
- [ ] GND → GND
- [ ] CS → GPIO17
- [ ] RESET → GPIO5
- [ ] DC → GPIO16
- [ ] MOSI → GPIO23
- [ ] SCK → GPIO18
- [ ] LED → GPIO32 (via 100Ω resistor)
- [ ] MISO → GPIO19 (optional but recommended)

### Button Wiring
- [ ] Up button → GPIO14 to GND
- [ ] Down button → GPIO33 to GND
- [ ] Left button → GPIO13 to GND
- [ ] Right button → GPIO21 to GND
- [ ] Center button → GPIO22 to GND
- [ ] Verify all buttons are normally open (not closed)

### SD Card Wiring (Optional)
- [ ] CS → GPIO12
- [ ] MOSI → GPIO23 (shared with display)
- [ ] MISO → GPIO19 (shared with display)
- [ ] SCK → GPIO18 (shared with display)
- [ ] VCC → 3.3V
- [ ] GND → GND

### Hardware Testing
- [ ] Check all connections with multimeter (continuity test)
- [ ] Verify 3.3V on display VCC pin
- [ ] Test each button for proper continuity (closed when pressed)
- [ ] No shorts between adjacent GPIO pins
- [ ] USB connection recognized by computer

## Software Setup

### Prerequisites
- [ ] Arduino IDE installed (version 1.8.19 or 2.x)
- [ ] ESP32 board support installed (version 2.0.11)
- [ ] Git installed (for cloning repository)
- [ ] USB drivers installed (CH340/CP2102 if needed)

### Repository Setup
- [ ] Repository cloned: `git clone https://github.com/aflat0o0n/ESP32Marauder.git`
- [ ] Navigated to repository folder
- [ ] Repository structure verified (esp32_marauder folder exists)

### Library Installation
Install these libraries via Arduino Library Manager:
- [ ] NimBLE-Arduino (version 1.3.8)
- [ ] ESP32Ping (version 1.6)
- [ ] MicroNMEA (version 2.0.6)
- [ ] AsyncTCP (by dvarrel)
- [ ] ESPAsyncWebServer (by lacamera)

### Configuration Files
- [ ] Opened `esp32_marauder/configs.h`
- [ ] Verified line ~32: `#define ESP32_ILI9341_BUTTONS` is uncommented
- [ ] Verified all other board defines are commented out
- [ ] Opened `User_Setup_Select.h`
- [ ] Verified `#include <User_Setup_esp32_ili9341_buttons.h>` is uncommented
- [ ] Verified all other User_Setup includes are commented out

### Arduino IDE Settings
- [ ] Board selected: "LOLIN D32" or "ESP32 Dev Module"
- [ ] Upload Speed: 921600
- [ ] Flash Frequency: 80MHz
- [ ] Flash Mode: DIO
- [ ] Flash Size: 4MB (32Mb)
- [ ] Partition Scheme: "Minimal SPIFFS (1.9MB APP with OTA/190KB SPIFFS)"
- [ ] Core Debug Level: None
- [ ] Port selected (e.g., COM3, /dev/ttyUSB0)

### Compilation
- [ ] Opened `esp32_marauder/esp32_marauder.ino`
- [ ] Click Verify (checkmark icon) - should compile without errors
- [ ] Compilation time: 5-10 minutes (normal for first build)
- [ ] No errors in console output
- [ ] Note any warnings (some are normal)

### Upload
- [ ] ESP32 connected via USB
- [ ] Correct port selected in Tools → Port
- [ ] Click Upload (right arrow icon)
- [ ] Upload progress shows in console
- [ ] "Hard resetting via RTS pin" message appears
- [ ] Upload completes successfully

## First Boot & Testing

### Initial Power-On
- [ ] ESP32 powered on (USB or external)
- [ ] Display backlight turns on
- [ ] ESP32 Marauder logo appears on screen
- [ ] No smoke, unusual sounds, or excessive heat

### Display Testing
- [ ] Logo is visible and colors are correct
- [ ] Text is readable (not garbled)
- [ ] Display orientation is correct (portrait mode)
- [ ] Backlight brightness is acceptable
- [ ] No flickering or artifacts

### Button Testing
Test each button individually:
- [ ] UP button: Menu cursor moves up
- [ ] DOWN button: Menu cursor moves down
- [ ] LEFT button: Goes back to previous menu
- [ ] RIGHT button: Navigates to submenu (if applicable)
- [ ] CENTER button: Selects current menu item
- [ ] No double-presses (good debouncing)
- [ ] No stuck or unresponsive buttons

### Feature Testing
- [ ] Main menu navigable
- [ ] WiFi Scanner functional
- [ ] Serial console accessible (115200 baud)
- [ ] Command line responds to "help" command
- [ ] Settings menu accessible
- [ ] Optional: SD card detected (if installed)
- [ ] Optional: SD card read/write test

### Performance Testing
- [ ] WiFi scanning completes successfully
- [ ] No unexpected reboots or crashes
- [ ] Menu navigation is smooth
- [ ] Screen updates without lag
- [ ] Battery/power consumption acceptable

## Troubleshooting (if issues found)

### Display Issues
If display problems occur:
- [ ] Rechecked all display connections
- [ ] Verified 3.3V power supply
- [ ] Tried different SPI_FREQUENCY value
- [ ] Added TFT_INVERSION_ON to User_Setup file
- [ ] Tested with example TFT_eSPI sketch

### Button Issues
If button problems occur:
- [ ] Rechecked button GPIO connections
- [ ] Verified buttons connect to GND when pressed
- [ ] Tested each button with multimeter
- [ ] Added 100nF capacitors for debouncing
- [ ] Swapped suspected faulty button

### Compilation Issues
If build fails:
- [ ] Verified ESP32 board support version (2.0.11)
- [ ] Reinstalled missing libraries
- [ ] Cleaned build files (Arduino IDE → Sketch → Clean)
- [ ] Restarted Arduino IDE
- [ ] Checked for syntax errors in configs.h

### Upload Issues
If upload fails:
- [ ] Verified USB cable supports data transfer
- [ ] Installed/updated USB drivers
- [ ] Selected correct COM port
- [ ] Held BOOT button during upload
- [ ] Tried lower upload speed (115200)
- [ ] Reset ESP32 before upload

## Documentation

### Build Documentation (Recommended)
- [ ] Took photos of wiring
- [ ] Documented any pin changes made
- [ ] Noted any issues encountered and solutions
- [ ] Created wiring diagram for future reference
- [ ] Documented custom modifications

### Files to Keep
- [ ] Copy of modified configs.h (if customized)
- [ ] Copy of modified User_Setup file (if customized)
- [ ] Backup of compiled .bin files
- [ ] Photos of hardware assembly

## Next Steps

### Enhancement Options
- [ ] Add external antenna for better WiFi range
- [ ] Install battery for portable operation
- [ ] Design and print custom enclosure
- [ ] Add additional LEDs for status indication
- [ ] Create custom PCB for permanent installation
- [ ] Add heat sinks if ESP32 runs hot during heavy use

### Learning & Usage
- [ ] Read full documentation (README_ESP32_ILI9341_BUTTONS.md)
- [ ] Experiment with WiFi scanning features
- [ ] Test Bluetooth scanning capabilities
- [ ] Explore Evil Portal feature
- [ ] Try command line interface
- [ ] Join ESP32 Marauder community

### Maintenance
- [ ] Bookmark GitHub repository for updates
- [ ] Check for firmware updates monthly
- [ ] Keep spare buttons and wires on hand
- [ ] Document any issues for future troubleshooting

## Quick Reference

### Pin Summary (Print & Keep)
```
Display:  CS=17, DC=16, RST=5, BL=32
          MOSI=23, MISO=19, SCK=18
Buttons:  Up=36, Down=35, Left=13, Right=39, Center=34
SD Card:  CS=12 (optional)
```

### Serial Console Access
```
Port: /dev/ttyUSB0 (Linux) or COM# (Windows)
Baud: 115200
Command: help
```

### Flash Command (esptool)
```bash
esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 921600 \
  --before default_reset --after hard_reset write_flash -z \
  --flash_mode dio --flash_freq 80m --flash_size detect \
  0x1000 bootloader.bin \
  0x8000 partitions.bin \
  0xe000 boot_app0.bin \
  0x10000 firmware.bin
```

## Status Summary

Date: _______________

Build Status: ○ Not Started  ○ In Progress  ○ Complete  ○ Issues Found

Hardware Status: ○ Not Started  ○ Assembly Done  ○ Tested  ○ Working

Software Status: ○ Not Started  ○ Compiled  ○ Uploaded  ○ Working

Overall Status: ○ Success  ○ Partial Success  ○ Needs Work

Notes:
_____________________________________________________________________________
_____________________________________________________________________________
_____________________________________________________________________________

## Resources

- **Quick Start Guide**: QUICK_START_GUIDE.md
- **Wiring Diagram**: WIRING_DIAGRAM.txt
- **Full Documentation**: README_ESP32_ILI9341_BUTTONS.md
- **Build Script**: build_esp32_ili9341_buttons.sh
- **Main Project**: https://github.com/justcallmekoko/ESP32Marauder
- **This Fork**: https://github.com/aflat0o0n/ESP32Marauder

---

**Good luck with your build!** 🚀

Remember: Take your time, double-check connections, and don't hesitate to ask for help in the community if you encounter issues.
