# ESP32 Marauder - ILI9341 with Physical Buttons Configuration

This configuration adds physical button support for ESP32 WROOM with ILI9341 display (without touch functionality).

## Hardware Requirements

### ESP32 WROOM 48-pin
- Standard ESP32 WROOM module with 48 pins
- Support for hardware SPI

### ILI9341 Display (240x320)
- Standard ILI9341 TFT LCD display
- No touch screen IC required (using physical buttons instead)

### Physical Buttons (5 buttons)
- 5x momentary push buttons
- Pull-up resistors (optional - internal pull-ups are used)

### Optional
- MicroSD card module (for logging features)
- External LED (GPIO2 or any available GPIO)

## Pin Configuration

### Display Connections (ILI9341)
```
ESP32 GPIO  →  ILI9341 Pin
──────────────────────────
GPIO23      →  MOSI (SDI)
GPIO19      →  MISO (SDO)
GPIO18      →  SCK (CLK)
GPIO17      →  CS
GPIO16      →  DC (D/C)
GPIO5       →  RESET (RST)
GPIO4       →  LED (Backlight)
3.3V        →  VCC
GND         →  GND
```

### Button Connections
```
Button      ESP32 GPIO  Function
──────────────────────────────────
Up          GPIO14      Navigate Up
Down        GPIO33      Navigate Down
Left        GPIO13      Navigate Left / Back
Right       GPIO32      Navigate Right
Center      GPIO26      Select / Confirm
```

**Note**: All buttons use internal pull-up resistors. Connect one side of each button to the specified GPIO and the other side to GND.

### SD Card Connections (Optional)
```
ESP32 GPIO  →  SD Card Pin
──────────────────────────
GPIO23      →  MOSI (shared with display)
GPIO19      →  MISO (shared with display)
GPIO18      →  SCK (shared with display)
GPIO12      →  CS
3.3V        →  VCC
GND         →  GND
```

## Wiring Diagram

```
                           ESP32 WROOM
                        ┌───────────────┐
                        │               │
     [Up Button]────────┤ GPIO14        │
   [Down Button]────────┤ GPIO33        │
   [Left Button]────────┤ GPIO13        │
  [Right Button]────────┤ GPIO21        │
 [Center Button]────────┤ GPIO22        │
                        │               │
  ILI9341 MOSI ─────────┤ GPIO23        │
  ILI9341 MISO ─────────┤ GPIO19        │
  ILI9341 SCK ──────────┤ GPIO18        │
  ILI9341 CS ───────────┤ GPIO17        │
  ILI9341 DC ───────────┤ GPIO16        │
  ILI9341 RST ──────────┤ GPIO5         │
  ILI9341 LED ──────────┤ GPIO25        │
                        │               │
  SD Card CS ───────────┤ GPIO12        │
                        │               │
                        │   GND   3.3V  │
                        └───┬───────┬───┘
                            │       │
                           GND     VCC
```

## Button Layout Recommendations

### Horizontal Layout (Recommended)
```
┌────┐  ┌────┐  ┌────┐  ┌────┐  ┌────┐
│ UP │  │LEFT│  │CNTR│  │RGHT│  │DOWN│
└────┘  └────┘  └────┘  └────┘  └────┘
```

### D-Pad + Center Layout (Alternative)
```
        ┌────┐
        │ UP │
        └────┘
┌────┐  ┌────┐  ┌────┐
│LEFT│  │CNTR│  │RGHT│
└────┘  └────┘  └────┘
        ┌────┐
        │DOWN│
        └────┘
```

## Building the Firmware

### Method 1: Using the Build Script (Recommended)

1. Navigate to the repository root:
   ```bash
   cd ESP32Marauder
   ```

2. Run the build script:
   ```bash
   ./build_esp32_ili9341_buttons.sh
   ```

3. The firmware will be compiled and placed in `build/esp32_ili9341_buttons/`

### Method 2: Manual Build with Arduino IDE

1. Open Arduino IDE
2. Install ESP32 board support (version 2.0.11)
3. Open `esp32_marauder/esp32_marauder.ino`
4. Edit `esp32_marauder/configs.h`:
   - Comment out all other board defines
   - Uncomment `#define ESP32_ILI9341_BUTTONS`
5. Edit `User_Setup_Select.h`:
   - Comment out all other includes
   - Uncomment `#include <User_Setup_esp32_ili9341_buttons.h>`
6. Select board: `LOLIN D32` or `ESP32 Dev Module`
7. Set partition scheme: `Minimal SPIFFS (1.9MB APP with OTA/190KB SPIFFS)`
8. Click Compile/Upload

### Method 3: Arduino CLI

```bash
# Install dependencies first
arduino-cli core install esp32:esp32@2.0.11

# Compile
arduino-cli compile \
  --fqbn esp32:esp32:d32:PartitionScheme=min_spiffs \
  --build-property "build.extra_flags=-DESP32_ILI9341_BUTTONS" \
  esp32_marauder/esp32_marauder.ino
```

## Flashing the Firmware

### Using esptool.py

1. Install esptool:
   ```bash
   pip install esptool
   ```

2. Connect your ESP32 via USB and identify the port:
   - Linux: Usually `/dev/ttyUSB0` or `/dev/ttyACM0`
   - Windows: Usually `COM3`, `COM4`, etc.
   - macOS: Usually `/dev/cu.usbserial-*`

3. Flash the firmware (replace `/dev/ttyUSB0` with your port):
   ```bash
   esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 921600 \
     --before default_reset --after hard_reset write_flash -z \
     --flash_mode dio --flash_freq 80m --flash_size detect \
     0x1000 build/esp32_ili9341_buttons/esp32_marauder.ino.bootloader.bin \
     0x8000 build/esp32_ili9341_buttons/esp32_marauder.ino.partitions.bin \
     0xe000 ~/.arduino15/packages/esp32/hardware/esp32/2.0.11/tools/partitions/boot_app0.bin \
     0x10000 build/esp32_ili9341_buttons/esp32_marauder.ino.bin
   ```

### Using Arduino IDE
1. Open the sketch
2. Select the correct port under Tools → Port
3. Click Upload

## Usage

### Button Controls

Once the firmware is running, you can use the buttons to navigate the menu:

- **UP**: Move cursor up in menus
- **DOWN**: Move cursor down in menus
- **LEFT**: Go back / Previous menu
- **RIGHT**: Navigate right / Submenu
- **CENTER**: Select / Confirm action

### Initial Setup

1. Power on the device
2. The display should show the ESP32 Marauder splash screen
3. Use UP/DOWN buttons to navigate the main menu
4. Press CENTER to select an option

### Features

All standard ESP32 Marauder features are available:
- WiFi scanning and monitoring
- Packet sniffing
- Deauth attacks
- Evil portal
- Bluetooth scanning
- SD card logging (if SD card is installed)

## Troubleshooting

### Display Issues

**Problem**: Display shows white/black screen or garbage
- **Solution 1**: Check all display connections, especially CS, DC, and RST pins
- **Solution 2**: Verify SPI pins (MOSI, MISO, SCLK) are correctly connected
- **Solution 3**: Try adjusting `SPI_FREQUENCY` in `User_Setup_esp32_ili9341_buttons.h` (reduce to 20MHz)

**Problem**: Display is inverted or colors are wrong
- **Solution**: Add or remove `#define TFT_INVERSION_ON` in User_Setup file

**Problem**: Backlight doesn't turn on
- **Solution**: Check GPIO32 connection to LED pin, ensure proper voltage (3.3V)

### Button Issues

**Problem**: Buttons don't respond
- **Solution 1**: Verify button connections to correct GPIO pins
- **Solution 2**: Ensure buttons are connecting GPIO to GND when pressed
- **Solution 3**: Test with multimeter - check continuity when button is pressed

**Problem**: Button presses are detected multiple times (bounce)
- **Solution**: The software includes debounce handling. If issues persist, add 100nF capacitor across each button

**Problem**: Random button presses without pressing
- **Solution**: Ensure good connections and avoid long wires for buttons

### Build Issues

**Problem**: Compilation errors about missing libraries
- **Solution**: Run the build script which automatically installs dependencies

**Problem**: `ESP32_ILI9341_BUTTONS` not recognized
- **Solution**: Ensure you've edited `configs.h` to uncomment the define

**Problem**: Multiple definitions error
- **Solution**: Ensure only one board type is defined in `configs.h`

## Configuration Customization

### Changing Button Pins

Edit `esp32_marauder/configs.h` in the `ESP32_ILI9341_BUTTONS` section:

```c
#ifdef ESP32_ILI9341_BUTTONS
  #define L_BTN 13    // Left button pin
  #define C_BTN 34    // Center button pin
  #define U_BTN 36    // Up button pin
  #define R_BTN 39    // Right button pin
  #define D_BTN 35    // Down button pin
  // ...
#endif
```

**Note**: Choose GPIO pins that:
- Are not used by the display or SD card
- Support INPUT mode
- Avoid boot-critical pins (GPIO0, GPIO2, GPIO12, GPIO15)

### Changing Display Pins

Edit `User_Setup_esp32_ili9341_buttons.h`:

```c
#define TFT_MISO 19
#define TFT_MOSI 23
#define TFT_SCLK 18
#define TFT_CS   17
#define TFT_DC   16
#define TFT_RST   5
#define TFT_BL   32
```

### Adjusting Display Settings

In the same file, you can adjust:
- `SPI_FREQUENCY` - Display SPI speed (default: 27MHz)
- `TFT_INVERSION_ON/OFF` - If colors are inverted

## Technical Specifications

- **MCU**: ESP32 WROOM (Dual-core Xtensa LX6)
- **Flash**: 4MB
- **RAM**: 520KB
- **Display**: ILI9341 240x320 TFT
- **Interface**: Hardware SPI
- **Buttons**: 5x GPIO with internal pull-ups
- **Power**: 3.3V @ ~200-300mA (typical)
- **WiFi**: 802.11 b/g/n
- **Bluetooth**: BLE 4.2

## Credits

- ESP32 Marauder by justcallmekoko
- Configuration and button support added for generic ESP32 + ILI9341

## License

This project follows the ESP32 Marauder license. See the main LICENSE file for details.

## Support

For issues specific to this configuration, please check:
1. Hardware connections match the pinout above
2. All required libraries are installed
3. Correct board configuration is selected

For general ESP32 Marauder support, visit:
- GitHub: https://github.com/justcallmekoko/ESP32Marauder
- Documentation: https://github.com/justcallmekoko/ESP32Marauder/wiki
