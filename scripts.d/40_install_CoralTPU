#!/bin/bash

# Downloading and unpacking files
wget https://dl.google.com/coral/edgetpu_api/edgetpu_api_latest.tar.gz -O edgetpu_api.tar.gz
tar xzf edgetpu_api.tar.gz
cd edgetpu_api || exit 1

# Substituting the install script with a preconfigured install script for Raspberyy Pi
rm -f install.sh
touch install.sh

cat > install.sh << 'EOF'
#!/bin/bash
#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Modified for use on Raspberry pi with Treehouses image
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   
  LIBEDGETPU_SUFFIX=arm32
  HOST_GNU_TYPE=arm-linux-gnueabihf
  LIBEDGETPU_SRC="${SCRIPT_DIR}/libedgetpu/libedgetpu_${LIBEDGETPU_SUFFIX}.so"
  LIBEDGETPU_DST="/usr/lib/${HOST_GNU_TYPE}/libedgetpu.so.1.0"

# Install dependent libraries.
echo "Installing library dependencies..."
sudo apt-get install -y \
  libusb-1.0-0 \
  python3-pip \
  python3-pil \
  python3-numpy \
  libc++1 \
  libc++abi1 \
  libunwind8 \
  libgcc1

# Device rule file.
UDEV_RULE_PATH="/etc/udev/rules.d/99-edgetpu-accelerator.rules"
echo "Installing device rule file [${UDEV_RULE_PATH}]..."

if [[ -f "${UDEV_RULE_PATH}" ]]; then
  warn "File already exists. Replacing it..."
  sudo rm -f "${UDEV_RULE_PATH}"
fi

sudo cp -p "${SCRIPT_DIR}/99-edgetpu-accelerator.rules" "${UDEV_RULE_PATH}"
sudo udevadm control --reload-rules && udevadm trigger
echo "Done."

# Runtime library.
info "Installing Edge TPU runtime library [${LIBEDGETPU_DST}]..."
if [[ -f "${LIBEDGETPU_DST}" ]]; then
  echo "File already exists. Replacing it..."
  sudo rm -f "${LIBEDGETPU_DST}"
fi

sudo cp -p "${LIBEDGETPU_SRC}" "${LIBEDGETPU_DST}"
sudo ldconfig
echo "Done."

# Python API.
WHEEL=$(ls ${SCRIPT_DIR}/edgetpu-*-py3-none-any.whl 2>/dev/null)
if [[ $? == 0 ]]; then
  info "Installing Edge TPU Python API..."
  sudo python3 -m pip install --no-deps "${WHEEL}"
  echo "Done."
fi
EOF

# Run install script
chmod +x ./install.sh
./install.sh || exit 1

# Remove installation files
cd .. && rm -rf edgetpu_api && rm -f edgetpu_api.tar.gz || exit 1
echo "Removed Coral TPU installation files"

# Workaround for python functionality in Buster
cd /usr/local/lib/python3.7/dist-packages/edgetpu/swig/ || exit 1     
cp _edgetpu_cpp_wrapper.cpython-35m-arm-linux-gnueabihf.so _edgetpu_cpp_wrapper.cpython-37m-arm-linux-gnueabihf.so
echo "Performed workaround for Coral TPU functionality in python 3.7"
exit 0
