#!/bin/bash
# -----------------------------------------------------------------------------
# This script is intended to install the latest stable MiniZinc bundle for Arch-based systems.
# It downloads and installs the latest stable MiniZinc bundle for Linux
# It also sets up a wrapper to ensure correct shared libraries are used
# Author: Hosein Hadipour <hsn.hadipour@gmail.com>
# -----------------------------------------------------------------------------

set -e

# Step 1: Install required packages
echo "[1/4] Installing dependencies..."
pacman -Sy --noconfirm \
    wget \
    curl \
    tar \
    coreutils

# Step 2: Download the latest MiniZinc bundle
echo "[2/4] Downloading MiniZinc bundle..."
cd /opt
LATEST_MINIZINC_VERSION=$(curl -s https://api.github.com/repos/MiniZinc/MiniZincIDE/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
wget "https://github.com/MiniZinc/MiniZincIDE/releases/download/$LATEST_MINIZINC_VERSION/MiniZincIDE-$LATEST_MINIZINC_VERSION-bundle-linux-x86_64.tgz"

# Step 3: Extract to /opt/MiniZinc
echo "[3/4] Extracting MiniZinc..."
mkdir -p /opt/MiniZinc
tar -xzf MiniZincIDE-$LATEST_MINIZINC_VERSION-bundle-linux-x86_64.tgz -C /opt/MiniZinc --strip-components=1
rm MiniZincIDE-$LATEST_MINIZINC_VERSION-bundle-linux-x86_64.tgz

# Step 4: Create wrapper for correct LD_LIBRARY_PATH and symlink
echo -e '#!/bin/bash\nexec env LD_LIBRARY_PATH=/opt/MiniZinc/lib:$LD_LIBRARY_PATH /opt/MiniZinc/bin/minizinc "$@"' > /usr/local/bin/minizinc
chmod +x /usr/local/bin/minizinc

# Step 5: Verify installation
echo "[+] MiniZinc $LATEST_MINIZINC_VERSION installed successfully!"
minizinc --version

