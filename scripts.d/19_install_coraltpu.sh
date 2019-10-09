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

# As modified for use in treehouses

# Downloading and unpacking files
wget https://dl.google.com/coral/edgetpu_api/edgetpu_api_latest.tar.gz -O edgetpu_api.tar.gz
tar xzf edgetpu_api.tar.gz
cd edgetpu_api || exit 1

# Defining variables
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBEDGETPU_SRC="$PWD/libedgetpu/libedgetpu_arm32.so"
LIBEDGETPU_DST="/usr/lib/arm-linux-gnueabihf/libedgetpu.so.1.0"
UDEV_RULE_PATH="/etc/udev/rules.d/99-edgetpu-accelerator.rules"

# Installing device rule file 

if [[ -f "${UDEV_RULE_PATH}" ]]; then
  rm -f "${UDEV_RULE_PATH}"
fi

cp -p "$PWD/99-edgetpu-accelerator.rules" "${UDEV_RULE_PATH}"
udevadm control --reload-rules && udevadm trigger
echo "Updated rules"

# Installing Edge TPU runtime library
if [[ -f "${LIBEDGETPU_DST}" ]]; then
  echo "File already exists. Replacing it..."
  rm -f "${LIBEDGETPU_DST}"
fi

mkdir /usr/lib/arm-linux-gnueabihf
echo "Created arm-linux-gnueabihf directory"
cp -p "${LIBEDGETPU_SRC}" "${LIBEDGETPU_DST}"
echo "Copied EdgeTPU files"
ldconfig
echo "Updated libraries"

# Python API.
WHEEL="$(ls "$PWD/edgetpu-*-py3-none-any.whl" 2>/dev/null)"
if [ $? = 0 ]; then
  python3 -m pip install --no-deps "${WHEEL}"
  echo "Installed Python API"
fi

cd .. && rm -rf edgetpu_api && rm -f edgetpu_api.tar.gz || exit 1
echo "Leaving directory and removing files"
