#!/bin/bash
# -----------------------------------------------------------------------------
# This script is intended to install the latest stable MiniZinc bundle for Debian-based systems.
# It downloads and installs the latest stable MiniZinc bundle for Linux
# It also sets up a wrapper to ensure correct shared libraries are used
# Author: Hosein Hadipour <hsn.hadipour@gmail.com>
# -----------------------------------------------------------------------------

set -e

# ------------------------------
# Install required dependencies
# ------------------------------
echo "[+] Installing prerequisites..."
apt-get update
apt-get install -y wget tar curl

# ------------------------------
# Download latest MiniZinc bundle
# ------------------------------
echo "[+] Fetching latest MiniZinc release version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/MiniZinc/MiniZincIDE/releases/latest | grep -oP '"tag_name": "\K[^"]+')
BUNDLE_NAME="MiniZincIDE-${LATEST_VERSION}-bundle-linux-x86_64.tgz"
DOWNLOAD_URL="https://github.com/MiniZinc/MiniZincIDE/releases/download/${LATEST_VERSION}/${BUNDLE_NAME}"

echo "[+] Downloading MiniZinc ${LATEST_VERSION} bundle..."
wget -q "$DOWNLOAD_URL" -O "$BUNDLE_NAME"

# ------------------------------
# Extract and install MiniZinc
# ------------------------------
echo "[+] Extracting MiniZinc..."
mkdir -p /opt/minizinc
tar -xzf "$BUNDLE_NAME" -C /opt/minizinc --strip-components=1
rm "$BUNDLE_NAME"

# ------------------------------
# Create a wrapper to fix shared library path
# ------------------------------
echo "[+] Creating wrapper script to fix LD_LIBRARY_PATH..."
cat << 'EOF' > /usr/local/bin/minizinc
#!/bin/bash
export LD_LIBRARY_PATH="/opt/minizinc/lib:$LD_LIBRARY_PATH"
/opt/minizinc/bin/minizinc "$@"
EOF
chmod +x /usr/local/bin/minizinc

# ------------------------------
# Verify installation
# ------------------------------
echo "[+] Verifying MiniZinc installation..."
minizinc --version

