sudo modprobe -r v4l2loopback
sudo modprobe v4l2loopback video_nr=2 card_label="webcam" exclusive_caps=1
#
# sudo modprobe v4l2loopback video_nr=2 card_label="webcam" exclusive_caps=1 width=2336 height=1080
# ./scrcpy --capture-orientation=270 --v4l2-sink=/dev/video2 --v4l2-buffer=300
adb shell am start -a android.media.action.STILL_IMAGE_CAMERA
# /home/thiago/Documents/_Projetos/WEBCAM/scrcpy-linux-x86_64-v3.1/scrcpy --capture-orientation=270 --v4l2-sink=/dev/video2 --v4l2-buffer=300

/home/thiago/Documents/_Projetos/WEBCAM/scrcpy-linux-x86_64-v3.1/scrcpy --v4l2-sink=/dev/video2 --v4l2-buffer=100

# /home/thiago/Documents/_Projetos/WEBCAM/scrcpy-linux-x86_64-v3.1/scrcpy \
#    --capture-orientation=270 \
#    --v4l2-sink=/dev/video2 \
#    --v4l2-buffer=300 \
#    --max-size=1280 \
#    --video-bit-rate=2M \
#    --max-fps=30