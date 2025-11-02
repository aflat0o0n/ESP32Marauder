# Button Pin Assignment Changes - Critical WiFi Compatibility Fix

## Issue History

### Issue 1: Display Interference (Fixed)
The original button pins (GPIO34, 35, 36, 39) were ADC-sensitive and triggered falsely due to display SPI interference.

### Issue 2: WiFi Incompatibility (CRITICAL - Current Fix)
The second attempt used GPIO25-27, 32-33, but **GPIO25-27 are ADC2 pins that are completely disabled when WiFi is active**. Since ESP32 Marauder uses WiFi extensively, these pins don't work as inputs.

## Root Cause - ADC2 and WiFi Conflict
**CRITICAL ISSUE:** ESP32's ADC2 module shares hardware with the WiFi module. When WiFi is enabled, **all ADC2 pins become unusable** - not just for analog reading, but also for digital input!

**ADC2 Pins (Cannot use with WiFi):**
- GPIO0, GPIO2, GPIO4, GPIO12-15, **GPIO25-27**

This is why only GPIO33 (DOWN) and GPIO26 (CENTER) worked initially - they were tested before WiFi started, but failed once WiFi was active.

## Solution - WiFi-Compatible Pins
Selected pins that:
- **NOT ADC2** - work regardless of WiFi state
- **NOT ADC1** (34-39) - avoid noise sensitivity
- **NOT boot-critical** - reliable startup
- **Support INPUT_PULLUP** - proper button operation
- **Available** - not used by display or SD card

## Current Pin Assignments (WiFi-Safe)

### Button Pin Evolution
| Button  | V1 (Noise) | V2 (WiFi Fail) | V3 (Final) | Status |
|---------|-----------|----------------|------------|--------|
| Up      | GPIO36    | GPIO27 ❌      | **GPIO14** | ✅ Works |
| Down    | GPIO35    | GPIO33 ✅      | **GPIO33** | ✅ Works |
| Left    | GPIO13    | GPIO25 ❌      | **GPIO13** | ✅ Works |
| Right   | GPIO39    | GPIO32 ❌      | **GPIO21** | ✅ Works |
| Center  | GPIO34    | GPIO26 ❌      | **GPIO22** | ✅ Works |

❌ = ADC2 pin, disabled with WiFi  
✅ = Safe GPIO, WiFi-compatible

### Display Backlight
| Function  | V1  | V2  | V3 (Final) | Status |
|-----------|-----|-----|------------|--------|
| Backlight | GPIO32 | GPIO4 | **GPIO25** | ✅ Works (output only) |

*Note: GPIO25 is ADC2 but safe for OUTPUT (only INPUT is affected by WiFi)*

### Display SPI (Unchanged)
- MOSI: GPIO23
- MISO: GPIO19
- SCK: GPIO18
- CS: GPIO17
- DC: GPIO16
- RST: GPIO5

## Why Final Pins Work With WiFi

### Safe Button Pins
1. **GPIO13** (LEFT) - Not ADC, not boot-critical (on pullup)
2. **GPIO14** (UP) - Not ADC, general purpose
3. **GPIO21** (RIGHT) - Not ADC, I2C SDA but works as GPIO
4. **GPIO22** (CENTER) - Not ADC, I2C SCL but works as GPIO  
5. **GPIO33** (DOWN) - Not ADC2, RTC domain, WiFi-safe

### Why Previous Pins Failed
- **GPIO25, 26, 27** - ADC2 channel pins
- **ADC2 hardware conflict** - Shares silicon with WiFi radio
- **Complete input disable** - Not just analog, but digital input too
- **Only affects INPUT mode** - OUTPUT still works (backlight OK on GPIO25)

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
