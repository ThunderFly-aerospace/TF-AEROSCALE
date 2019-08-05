#! usr/bin/python

from ConfigParser import SafeConfigParser
import I2CSPI_BRIDGEADC01
import datetime
import time
import os
import sys

cfg_file = "config.ini"

config = SafeConfigParser()
config.read(cfg_file)

zero_calibration_1 = 0 - I2CSPI_BRIDGEADC01.get_data1()
zero_calibration_2 = 0 - I2CSPI_BRIDGEADC01.get_data2()

def channel_1():
    return I2CSPI_BRIDGEADC01.get_data1() + zero_calibration_1

def channel_2():
    return I2CSPI_BRIDGEADC01.get_data2() + zero_calibration_2

now = datetime.datetime.now()
filename = str(now.year)+"-"+str(now.month)+"-"+str(now.day)+"T"+str(now.hour)+":"+str(now.minute)+".csv"


file = open(filename, "w")
file.close()
os.chmod(filename, 0o777)

print("Start logging into "+filename)

try:
    while True:
        with open(filename, "a") as file:
            channel1 = channel_1()
            channel2 = channel_2()

            print(str(channel1)+"   "+str(channel2))

            file.write(str(time.time())+","+str(channel1)+","+str(channel2)+"\r\n")

except KeyboardInterrupt:
    sys.exit(0)
