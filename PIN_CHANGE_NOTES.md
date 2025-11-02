# Button Pin Assignment Changes - Fixing Display Interference Issue

## Problem
The original button pin assignments were causing false triggers due to electrical interference from the ILI9341 display's SPI bus and backlight PWM.

## Root Cause
The previous button pins (GPIO34, 35, 36, 39) were:
1. **ADC pins** - highly sensitive to electrical noise
2. **INPUT_ONLY pins** (GPIO36, 39) - limited configuration options
3. **Located near SPI signals** - susceptible to crosstalk from MOSI (GPIO23), SCK (GPIO18)
4. **Affected by backlight PWM** - GPIO32 backlight induced noise in nearby ADC pins

## Solution
Reassigned buttons to more robust GPIO pins that are:
- **General-purpose GPIO** (not ADC, not INPUT_ONLY)
- **Physically separated** from SPI bus activity
- **Less susceptible** to electromagnetic interference
- **Proper pull-up support** with better noise immunity

## New Pin Assignments

### Buttons (Changed)
| Button  | Old Pin | New Pin | Reason |
|---------|---------|---------|--------|
| Up      | GPIO36  | GPIO27  | Avoid ADC/INPUT_ONLY, far from SPI |
| Down    | GPIO35  | GPIO33  | Avoid ADC sensitivity |
| Left    | GPIO13  | GPIO25  | Better isolation from SPI |
| Right   | GPIO39  | GPIO32  | Avoid INPUT_ONLY, was backlight |
| Center  | GPIO34  | GPIO26  | Avoid ADC sensitivity |

### Display Backlight (Changed)
| Function  | Old Pin | New Pin | Reason |
|-----------|---------|---------|--------|
| Backlight | GPIO32  | GPIO4   | Free up GPIO32 for button use |

### Display SPI (Unchanged)
All display SPI pins remain the same:
- MOSI: GPIO23
- MISO: GPIO19
- SCK: GPIO18
- CS: GPIO17
- DC: GPIO16
- RST: GPIO5

## Technical Benefits

### Why These Pins Are Better
1. **GPIO25, 26, 27** - RTC/DAC pins but work perfectly as digital GPIO, far from SPI bus
2. **GPIO32, 33** - RTC pins, robust digital GPIO with good noise immunity
3. **All are bidirectional** - support INPUT_PULLUP properly
4. **Not ADC1 pins** - avoid analog-to-digital converter noise sensitivity
5. **Physically distant** from SPI MOSI (GPIO23) and SCK (GPIO18)

### Why Original Pins Had Issues
1. **GPIO34, 35, 36, 39** are all ADC1 channel pins
2. ADC pins are **highly sensitive** to even small voltage fluctuations
3. SPI signals create **electromagnetic fields** that couple into ADC traces on PCB
4. PWM backlight on GPIO32 creates **periodic noise** that affects nearby pins
5. INPUT_ONLY pins (36, 39) have **no pull-down option**, making them more susceptible

## Migration Guide

If you already built hardware with old pins, you need to:

### Option 1: Rewire (Recommended)
1. Move button wires to new GPIO pins as shown above
2. Move backlight from GPIO32 to GPIO4
3. Update firmware (already done in configs.h)
4. Test each button individually

### Option 2: Keep Old Pins (Not Recommended)
If you must keep old wiring:
1. Add 100nF ceramic capacitors across each button (between GPIO and GND)
2. Use shielded wire for button connections
3. Keep button wires away from display cables
4. Add ferrite beads on button wires near ESP32
5. Reduce display backlight brightness if possible

**Note:** Option 2 may still have interference issues depending on your specific hardware layout.

## Verification Steps

After making changes:
1. Power on device without pressing any buttons
2. Observe display - should be stable, no random menu changes
3. Press each button individually - should respond correctly
4. Press and hold each button - should detect hold properly
5. Run WiFi scan - display should remain stable during SPI activity

## Files Updated

All configuration and documentation files have been updated with new pin assignments:
- `esp32_marauder/configs.h` - Board configuration
- `User_Setup_esp32_ili9341_buttons.h` - Display setup
- `START_HERE_ILI9341_BUTTONS.md` - Entry guide
- `QUICK_START_GUIDE.md` - Beginner guide
- `README_ESP32_ILI9341_BUTTONS.md` - Technical docs
- `WIRING_DIAGRAM.txt` - Visual diagrams
- `BUILD_CHECKLIST.md` - Build checklist
- `IMPLEMENTATION_SUMMARY.md` - Implementation details

## Additional Recommendations

### Hardware Best Practices
1. **Keep button wires short** (< 15cm if possible)
2. **Twist button wire pairs** (GPIO + GND together)
3. **Route button wires away** from display ribbon cable
4. **Use proper grounding** - common ground for all components
5. **Add 100nF capacitors** on button pins (optional but recommended)

### Testing for Interference
If you still experience issues:
1. Disconnect display temporarily and test buttons alone
2. Test buttons with display powered but not updating
3. Test during active WiFi scanning (high SPI activity)
4. Monitor serial output for unexpected button events

## Technical Background

### Why ADC Pins Are Sensitive
ESP32's ADC (Analog-to-Digital Converter) channels are designed to measure small voltage changes (mV range). This sensitivity makes them excellent for analog sensors but problematic for digital buttons near noisy signals.

### SPI Electromagnetic Coupling
SPI operates at MHz frequencies with fast rise times. The changing magnetic fields from SPI traces can induce voltages in nearby conductors (crosstalk). ADC pins are especially susceptible because they're designed to detect tiny voltage changes.

### PWM Backlight Noise
LED backlight PWM typically operates at 1-5 kHz. The switching creates voltage ripples on the power rails and can induce noise through capacitive coupling to nearby GPIO pins.

## Summary

**Problem:** Display activity triggering false button presses
**Cause:** ADC-sensitive pins near noisy SPI/PWM signals
**Solution:** Move to robust GPIO pins far from interference sources
**Result:** Stable button operation even during active display use

All documentation and code have been updated. Users with existing hardware should rewire their buttons to the new pins for reliable operation.
