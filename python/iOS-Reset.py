__author__ = "Kuldeep Sharma"
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Kuldeep Sharma"
__email__ = "kuldeep.sharma@publicissaient.com"
__description__ = "Script to Reset the iOS Emulator Data"

import re
import subprocess

ios_device = subprocess.getoutput("xcrun simctl list | egrep -w \"iPhone X.*[0-1]\"")
print("Full Device Details : "+str(ios_device))

r = re.compile("([a-zA-Z ]+[\(])([0-9a-zA-Z].*)([\)].*[0-9a-zA-Z].*)")
m = r.match(ios_device)
uid = m.group(2)
print("Device Name: "+ str(uid))

args = 'xcrun simctl erase ' + uid
print(args)
subprocess.call(args, shell=True)

