#!/bin/bash
exit 0 
source lib.sh

_op _chroot pip3 install opencv-python==4.1.0.25 opencv-contrib-python==4.1.0.25
_op _chroot pip3 install --upgrade imutils

echo "Verify your install worked by the following commands:"
echo
echo "python3"
echo "import cv2"
echo "cv2.__version__"
echo ""
echo "You should see \"4.1.0\" or higher if it worked."
echo "If installation is successful, you'll need to restart to get the camera working."
echo "Upon reboot, run the following to verify the camera works: "
echo "sudo raspistill -e png -n -o /home/pi/Pictures/activation_test.png"
echo
echo "Trained classifiers for detecting objects can be found at https://github.com/opencv/opencv/tree/master/data/haarcascades"
