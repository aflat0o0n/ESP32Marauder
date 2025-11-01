#!/bin/bash

# ESP32 Marauder Build Script for ESP32 WROOM with ILI9341 and Buttons
# This script builds the firmware for ESP32 with ILI9341 display and physical buttons

set -e  # Exit on error

echo "=========================================="
echo "ESP32 Marauder - ILI9341 with Buttons Build"
echo "=========================================="
echo ""

# Configuration
BOARD_FLAG="ESP32_ILI9341_BUTTONS"
BOARD_FQBN="esp32:esp32:d32:PartitionScheme=min_spiffs"
SKETCH_PATH="esp32_marauder/esp32_marauder.ino"
OUTPUT_DIR="build/esp32_ili9341_buttons"
OUTPUT_NAME="esp32_marauder_ili9341_buttons"
TFT_SETUP_FILE="User_Setup_esp32_ili9341_buttons.h"
ESP32_VERSION="2.0.11"

# Check if Arduino CLI is installed
if ! command -v arduino-cli &> /dev/null; then
    echo "Arduino CLI not found. Installing..."
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
    export PATH=$PATH:./bin
fi

echo "Step 1: Verify Arduino CLI installation..."
arduino-cli version

echo ""
echo "Step 2: Update Arduino core index..."
arduino-cli core update-index --additional-urls "https://github.com/espressif/arduino-esp32/releases/download/${ESP32_VERSION}/package_esp32_dev_index.json"

echo ""
echo "Step 3: Install ESP32 core v${ESP32_VERSION}..."
arduino-cli core install esp32:esp32@${ESP32_VERSION} --additional-urls "https://github.com/espressif/arduino-esp32/releases/download/${ESP32_VERSION}/package_esp32_dev_index.json"

echo ""
echo "Step 4: Installing required libraries..."

# Install ESP32Ping
if [ ! -d "libraries/ESP32Ping" ]; then
    echo "Installing ESP32Ping..."
    git clone -b 1.6 https://github.com/marian-craciunescu/ESP32Ping.git libraries/ESP32Ping
fi

# Install AsyncTCP
if [ ! -d "libraries/AsyncTCP" ]; then
    echo "Installing AsyncTCP..."
    git clone -b v3.4.8 https://github.com/ESP32Async/AsyncTCP.git libraries/AsyncTCP
fi

# Install MicroNMEA
if [ ! -d "libraries/MicroNMEA" ]; then
    echo "Installing MicroNMEA..."
    git clone -b v2.0.6 https://github.com/stevemarple/MicroNMEA.git libraries/MicroNMEA
fi

# Install ESPAsyncWebServer
if [ ! -d "libraries/ESPAsyncWebServer-custom" ]; then
    echo "Installing ESPAsyncWebServer..."
    git clone -b v3.8.1 https://github.com/ESP32Async/ESPAsyncWebServer.git libraries/ESPAsyncWebServer-custom
fi

# Install NimBLE-Arduino
if [ ! -d "libraries/NimBLE-Arduino" ]; then
    echo "Installing NimBLE-Arduino..."
    git clone -b 1.3.8 https://github.com/h2zero/NimBLE-Arduino.git libraries/NimBLE-Arduino
fi

echo ""
echo "Step 5: Configuring build environment..."

# Backup original configs.h and modify it
echo "Updating configs.h with board definition..."
cd esp32_marauder

# Enable the ESP32_ILI9341_BUTTONS define
sed -i 's|//#define ESP32_ILI9341_BUTTONS|#define ESP32_ILI9341_BUTTONS|g' configs.h

# Comment out any other active board defines
sed -i 's|^[[:space:]]*#define MARAUDER_|//#define MARAUDER_|g' configs.h
sed -i 's|^[[:space:]]*#define GENERIC_ESP32|//#define GENERIC_ESP32|g' configs.h

cd ..

# Update User_Setup_Select.h to use the correct setup file
echo "Configuring User_Setup_Select.h..."
sed -i 's|^//#include <User_Setup_esp32_ili9341_buttons.h>|#include <User_Setup_esp32_ili9341_buttons.h>|g' User_Setup_Select.h
# Comment out all other setup includes
sed -i 's|^#include <User_Setup_|//#include <User_Setup_|g' User_Setup_Select.h
# Re-enable our specific one
sed -i 's|^//#include <User_Setup_esp32_ili9341_buttons.h>|#include <User_Setup_esp32_ili9341_buttons.h>|g' User_Setup_Select.h

echo ""
echo "Step 6: Compiling firmware..."
mkdir -p "${OUTPUT_DIR}"

arduino-cli compile \
  --fqbn "${BOARD_FQBN}" \
  --output-dir "${OUTPUT_DIR}" \
  --build-property "build.extra_flags=-DESP32_ILI9341_BUTTONS" \
  "${SKETCH_PATH}"

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Build successful!"
    echo "=========================================="
    echo ""
    echo "Firmware files are located in: ${OUTPUT_DIR}"
    echo ""
    echo "To flash the firmware to your ESP32:"
    echo "1. Connect your ESP32 via USB"
    echo "2. Identify the COM port (e.g., /dev/ttyUSB0 or COM3)"
    echo "3. Run the following command:"
    echo ""
    echo "   esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 921600 \\"
    echo "     --before default_reset --after hard_reset write_flash -z \\"
    echo "     --flash_mode dio --flash_freq 80m --flash_size detect \\"
    echo "     0x1000 ${OUTPUT_DIR}/esp32_marauder.ino.bootloader.bin \\"
    echo "     0x8000 ${OUTPUT_DIR}/esp32_marauder.ino.partitions.bin \\"
    echo "     0xe000 ~/.arduino15/packages/esp32/hardware/esp32/${ESP32_VERSION}/tools/partitions/boot_app0.bin \\"
    echo "     0x10000 ${OUTPUT_DIR}/esp32_marauder.ino.bin"
    echo ""
    echo "Or use Arduino IDE / PlatformIO to upload."
    echo ""
    echo "Button Configuration:"
    echo "  - Up:    GPIO36"
    echo "  - Down:  GPIO35"
    echo "  - Left:  GPIO13"
    echo "  - Right: GPIO39"
    echo "  - Center: GPIO34"
    echo ""
    echo "Display Pins:"
    echo "  - MISO:  GPIO19"
    echo "  - MOSI:  GPIO23"
    echo "  - SCLK:  GPIO18"
    echo "  - CS:    GPIO17"
    echo "  - DC:    GPIO16"
    echo "  - RST:   GPIO5"
    echo "  - BL:    GPIO32"
    echo ""
    echo "SD Card:"
    echo "  - CS:    GPIO12"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "Build failed! Check the errors above."
    echo "=========================================="
    exit 1
fi
