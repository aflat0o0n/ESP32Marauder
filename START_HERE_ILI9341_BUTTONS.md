# 🎯 ESP32 Marauder with ILI9341 Display and Physical Buttons

## Welcome! You're in the right place 🎉

This configuration adds **physical button support** to ESP32 Marauder for use with ILI9341 displays that **don't have a touch screen**.

---

## 🚀 Quick Navigation

### New to this project?
👉 **Start with**: [`QUICK_START_GUIDE.md`](QUICK_START_GUIDE.md)
- Beginner-friendly instructions
- Step-by-step hardware setup
- Arduino IDE configuration
- First boot guide

### Need wiring help?
👉 **Look at**: [`WIRING_DIAGRAM.txt`](WIRING_DIAGRAM.txt)
- Visual ASCII art diagrams
- Complete pin tables
- Breadboard layouts
- Button connections

### Want to build it?
👉 **Use**: [`BUILD_CHECKLIST.md`](BUILD_CHECKLIST.md)
- Interactive checklist
- Hardware verification
- Software setup steps
- Testing procedures

### Need technical details?
👉 **Read**: [`README_ESP32_ILI9341_BUTTONS.md`](README_ESP32_ILI9341_BUTTONS.md)
- Complete specifications
- Pin configurations
- Advanced troubleshooting
- Customization guide

### Want the big picture?
👉 **See**: [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)
- Complete implementation overview
- Technical decisions explained
- All changes documented

### Want to build automatically?
👉 **Run**: [`build_esp32_ili9341_buttons.sh`](build_esp32_ili9341_buttons.sh)
```bash
chmod +x build_esp32_ili9341_buttons.sh
./build_esp32_ili9341_buttons.sh
```

---

## ⚡ Super Quick Start (3 Steps)

### 1️⃣ Wire Your Hardware
Connect 5 buttons to ESP32:
- **Up**: GPIO27 → GND
- **Down**: GPIO33 → GND  
- **Left**: GPIO25 → GND
- **Right**: GPIO32 → GND
- **Center**: GPIO26 → GND

Connect ILI9341 display to ESP32:
- **MOSI**: GPIO23
- **MISO**: GPIO19
- **SCK**: GPIO18
- **CS**: GPIO17
- **DC**: GPIO16
- **RST**: GPIO5
- **BL**: GPIO32

*(See [WIRING_DIAGRAM.txt](WIRING_DIAGRAM.txt) for complete details)*

### 2️⃣ Configure the Software
Edit two files:

**File 1**: `esp32_marauder/configs.h` (around line 32)
```c
// Uncomment this line (remove the //)
#define ESP32_ILI9341_BUTTONS
```

**File 2**: `User_Setup_Select.h` (around line 39)
```c
// Uncomment this line (remove the //)
#include <User_Setup_esp32_ili9341_buttons.h>
```

### 3️⃣ Build and Flash
**Option A - Arduino IDE** (Easiest):
1. Install ESP32 board support (v2.0.11)
2. Open `esp32_marauder/esp32_marauder.ino`
3. Select board: "LOLIN D32" or "ESP32 Dev Module"
4. Set partition: "Minimal SPIFFS"
5. Click Upload!

**Option B - Build Script** (Automated):
```bash
./build_esp32_ili9341_buttons.sh
```

---

## 🎮 Button Controls

Once running:
- **UP** / **DOWN**: Navigate menus
- **LEFT**: Go back
- **RIGHT**: Enter submenu
- **CENTER**: Select / Confirm

---

## 📚 Full Documentation Index

| Document | Size | Purpose | Audience |
|----------|------|---------|----------|
| [QUICK_START_GUIDE.md](QUICK_START_GUIDE.md) | 11KB | Getting started | Beginners |
| [WIRING_DIAGRAM.txt](WIRING_DIAGRAM.txt) | 25KB | Visual wiring | Everyone |
| [BUILD_CHECKLIST.md](BUILD_CHECKLIST.md) | 8.8KB | Build tracking | Builders |
| [README_ESP32_ILI9341_BUTTONS.md](README_ESP32_ILI9341_BUTTONS.md) | 11KB | Technical specs | Advanced |
| [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) | 11KB | Overview | Developers |
| [build_esp32_ili9341_buttons.sh](build_esp32_ili9341_buttons.sh) | 7.2KB | Build automation | CLI users |
| [User_Setup_esp32_ili9341_buttons.h](User_Setup_esp32_ili9341_buttons.h) | 5.1KB | Display config | Reference |

**Total**: ~79KB of documentation and tools

---

## ❓ Common Questions

### Q: Will this work with my ESP32?
**A**: Yes, if you have:
- ESP32 WROOM (48-pin preferred)
- ILI9341 display (240x320)
- 5 push buttons
- No touch screen driver (or broken touch)

### Q: Do I need a touch screen?
**A**: No! That's the point. Use physical buttons instead.

### Q: Which pins can I change?
**A**: Most pins can be changed, but avoid boot pins (GPIO 0, 2, 12, 15). See technical docs for details.

### Q: Can I add an SD card?
**A**: Yes! Connect SD card CS to GPIO12. SPI pins are shared with display.

### Q: What if my display doesn't work?
**A**: Check wiring first, then see troubleshooting in [README_ESP32_ILI9341_BUTTONS.md](README_ESP32_ILI9341_BUTTONS.md)

### Q: Can I use this for X?
**A**: This config includes all ESP32 Marauder features:
- ✅ WiFi scanning and attacks
- ✅ Bluetooth scanning  
- ✅ Evil Portal
- ✅ Packet capture
- ✅ SD logging
- ✅ Serial CLI

---

## 🛠️ Hardware Requirements

### Required
- ✅ ESP32 WROOM (48-pin recommended)
- ✅ ILI9341 TFT Display (240x320)
- ✅ 5× Momentary push buttons
- ✅ Jumper wires
- ✅ USB cable (data + power)

### Optional
- 📦 MicroSD card + module
- 🔋 Battery + charger module
- 📦 Enclosure
- 🔧 PCB (instead of breadboard)
- ⚡ 100Ω resistor for backlight
- 🔧 100nF capacitors for button debouncing

---

## ⚠️ Important Notes

### Before You Start
1. **Use 3.3V** for ILI9341 (NOT 5V!)
2. **Double-check** button connections
3. **Test display** alone before adding buttons
4. **Read** at least the Quick Start Guide

### After Building
1. **Test all buttons** individually
2. **Check display** colors and orientation
3. **Try basic features** before advanced ones
4. **Document** your build (photos help!)

---

## 🎉 Success Stories

After building, you'll have:
- ✅ Fully functional ESP32 Marauder
- ✅ Button-controlled navigation
- ✅ Beautiful ILI9341 display
- ✅ All original features working
- ✅ Optional SD card logging
- ✅ Portable WiFi security tool

---

## 🤝 Support

### Documentation
All documentation is included in this repository. Start with the guide that matches your skill level.

### Community
- **Original Project**: [ESP32 Marauder](https://github.com/justcallmekoko/ESP32Marauder)
- **Wiki**: [ESP32 Marauder Wiki](https://github.com/justcallmekoko/ESP32Marauder/wiki)

### Issues
- Hardware/wiring issues: Check [WIRING_DIAGRAM.txt](WIRING_DIAGRAM.txt)
- Build issues: Check [BUILD_CHECKLIST.md](BUILD_CHECKLIST.md)
- Technical issues: Check [README_ESP32_ILI9341_BUTTONS.md](README_ESP32_ILI9341_BUTTONS.md)

---

## 📜 Credits

- **ESP32 Marauder**: Created by [justcallmekoko](https://github.com/justcallmekoko)
- **Button Configuration**: Inspired by Marauder Mini
- **This Implementation**: For users with ILI9341 displays without touch

---

## 🚦 Status

**Configuration Status**: ✅ Complete and Production Ready

**What Works**:
- ✅ All 5 buttons
- ✅ ILI9341 display (240x320)
- ✅ Menu navigation
- ✅ All WiFi features
- ✅ Bluetooth scanning
- ✅ SD card logging
- ✅ Serial commands
- ✅ All Marauder features

**Tested With**:
- ✅ ESP32 WROOM 48-pin
- ✅ ILI9341 240x320 TFT
- ✅ Standard push buttons
- ✅ Arduino IDE 1.8.19+
- ✅ Arduino IDE 2.x
- ✅ ESP32 Core 2.0.11

---

## 🎯 Next Steps

1. **Choose your path**:
   - New? → Read [`QUICK_START_GUIDE.md`](QUICK_START_GUIDE.md)
   - Building? → Use [`BUILD_CHECKLIST.md`](BUILD_CHECKLIST.md)
   - Technical? → Read [`README_ESP32_ILI9341_BUTTONS.md`](README_ESP32_ILI9341_BUTTONS.md)

2. **Wire your hardware**:
   - Follow [`WIRING_DIAGRAM.txt`](WIRING_DIAGRAM.txt)

3. **Build your firmware**:
   - Use Arduino IDE or build script

4. **Flash and test**:
   - Upload and verify all features

5. **Enjoy your ESP32 Marauder**! 🎉

---

## 📌 Pin Reference Card

**Print this for quick reference:**

```
╔══════════════════════════════════════╗
║  ESP32 MARAUDER - ILI9341 + BUTTONS ║
╠══════════════════════════════════════╣
║ BUTTONS                              ║
║  Up:    GPIO14    Down:  GPIO33     ║
║  Left:  GPIO13    Right: GPIO21     ║
║  Center: GPIO22                      ║
╠══════════════════════════════════════╣
║ DISPLAY (ILI9341)                    ║
║  CS:  GPIO17    DC:   GPIO16        ║
║  RST: GPIO5     BL:   GPIO25        ║
║  MOSI:GPIO23    MISO: GPIO19        ║
║  SCK: GPIO18                         ║
╠══════════════════════════════════════╣
║ SD CARD (Optional)                   ║
║  CS: GPIO12   (Shares SPI)          ║
╚══════════════════════════════════════╝
```

---

**Ready to start?** Pick a guide above and begin your build! 🚀

**Questions?** All documentation is included. Start with QUICK_START_GUIDE.md

**Good luck!** 🎯
