#! usr/bin/python

import I2CSPI_BRIDGEADC01
import datetime
import time
import os
import sys

now = datetime.datetime.now()
filename = str(now.year)+"-"+str(now.month)+"-"+str(now.day)+"T"+str(now.hour)+":"+str(now.minute)+".csv"

file = open(filename, "w")
file.close()
os.chmod(filename, 0o777)

try:
    while True:
        with open(filename, "a") as file:
            channel_1 = I2CSPI_BRIDGEADC01.get_data1()
            channel_2 = I2CSPI_BRIDGEADC01.get_data2()

            file.write(str(time.time())+","+str(channel_1)+","+str(channel_2)+"\r\n")
                
except KeyboardInterrupt:
    sys.exit(0)