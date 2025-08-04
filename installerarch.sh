#!/bin/bash
# -----------------------------------------------------------------------------
# This script is intended to install the latest stable MiniZinc bundle for Arch-based systems.
# It downloads and installs the latest stable MiniZinc bundle for Linux
# It also sets up a wrapper to ensure correct shared libraries are used
# Author: Hosein Hadipour <hsn.hadipour@gmail.com>
# -----------------------------------------------------------------------------

set -e

# Step 1: Install required packages
echo "[1/5] Installing dependencies..."
pacman -Sy --noconfirm \
    wget \
    curl \
    tar \
    coreutils

# Step 2: Install Python environment and packages
echo "[2/5] Installing Python environment and MiniZinc Python package..."
# Install system dependencies
pacman -S --noconfirm python python-pip python-virtualenv git

# Create a Python virtual environment
python3 -m venv "$HOME/minizinc-venv"
source "$HOME/minizinc-venv/bin/activate"
# Install Python packages
pip install --upgrade pip
pip install minizinc

# Step 3: Download the latest MiniZinc bundle
echo "[3/5] Downloading MiniZinc bundle..."
cd /opt
LATEST_MINIZINC_VERSION=$(curl -s https://api.github.com/repos/MiniZinc/MiniZincIDE/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
wget "https://github.com/MiniZinc/MiniZincIDE/releases/download/$LATEST_MINIZINC_VERSION/MiniZincIDE-$LATEST_MINIZINC_VERSION-bundle-linux-x86_64.tgz"

# Step 4: Extract to /opt/MiniZinc
echo "[4/5] Extracting MiniZinc..."
mkdir -p /opt/MiniZinc
tar -xzf MiniZincIDE-$LATEST_MINIZINC_VERSION-bundle-linux-x86_64.tgz -C /opt/MiniZinc --strip-components=1
rm MiniZincIDE-$LATEST_MINIZINC_VERSION-bundle-linux-x86_64.tgz

# Step 5: Create wrapper for correct LD_LIBRARY_PATH and symlink
echo "[5/5] Setting up wrapper script..."
echo -e '#!/bin/bash\nexec env LD_LIBRARY_PATH=/opt/MiniZinc/lib:$LD_LIBRARY_PATH /opt/MiniZinc/bin/minizinc "$@"' > /usr/local/bin/minizinc
chmod +x /usr/local/bin/minizinc

# Step 6: Verify installation
echo "[+] MiniZinc $LATEST_MINIZINC_VERSION installed successfully!"
minizinc --version

