#!/bin/sh
source lib.sh

echo "Installing OpenCV and NumPy on a virtual envirnonment"
_op _chroot wget -N https://bootstrap.pypa.io/get-pip.py
_op _chroot python get-pip.py
_op _chroot python3 get-pip.py
_op _chroot rm -rf ~/.cache/pip
_op _chroot python3 -m pip install virtualenv
_op _chroot python3 -m pip install virtualenvwrapper

echo "# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libatomic.so.1.2.0
source /usr/local/bin/virtualenvwrapper.sh" >> mnt/img_root/root/.bashrc

_op _chroot source mnt/img_root/root/.bashrc

_op _chroot bash -c 'source /usr/local/bin/virtualenvwrapper.sh;mkvirtualenv cv -p python3;source /root/.virtualenvs/cv/bin/activate'

_op _chroot pip3 install "picamera[array]"
_op _chroot pip3 install opencv-python
_op _chroot pip3 install opencv-contrib-python
_op _chroot pip3 install --upgrade imutils
_op _chroot deactivate
_op _chroot wget -N https://github.com/opencv/opencv/tree/master/data/haarcascades/haarcascade_frontalface_default.xml


echo "# Enable Camera"
_op _chroot raspi-config nonint do_camera 0

echo "Verify your install worked by the following commands:"
echo ""
echo "cd ~"
echo "source /usr/local/bin/virtualenvwrapper.sh"
echo "mkvirtualenv cv -p python3"
echo "source ~/.virtualenvs/cv/bin/activate"
echo "python3"
echo "import cv2"
echo "cv2.__version__"
echo ""
echo "You should see \"4.1.1\" or higher if it worked."
echo "If installation is successful, you'll need to restart to get the camera working."
echo "Upon reboot, run the following to verify the camera works: "
echo ""
echo "sudo raspistill -e png -n -o /home/pi/Pictures/activation_test.png"