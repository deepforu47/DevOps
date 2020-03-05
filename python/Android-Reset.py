__author__ = "Kuldeep Sharma"
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Kuldeep Sharma"
__email__ = "kuldeep.sharma@publicissaient.com"
__description__ = "Script to Reset the Android Emulator Data"

import subprocess

def subprocess_cmd(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
    proc_stdout = process.communicate()[0].strip()
    print(proc_stdout)


subprocess_cmd('device_name=$($ANDROID_HOME/emulator/emulator -avd -list-avds | grep -w Pixel_2_API_27); \
echo $device_name; $ANDROID_HOME/emulator/emulator -avd $device_name -wipe-data -netdelay none -netspeed full ')

#args = 'adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done'
#print(args)
#subprocess.call(args, shell=True)
