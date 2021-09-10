#!/usr/bin/python3

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time
import datetime
import threading
import os
import math
from pymlab import config

from BRIDGEADC01 import BRIDGEADC01

"""
Show data from TF-AEROSCALE over SPIDEV and I2C on rpi3. 
"""

#### Script Arguments ###############################################

import spidev

class SPIWraper:
    def __init__(self,cs_pin):
        self.spi=spidev.SpiDev()
        self.spi.open(0,cs_pin)

        self.spi.max_speed_hz=400000
        self.spi.mode=1

        self.result=[];

    def SPI_write(self,cs,data):
        '''write data to bus with selected CS pin'''
        tmpresult = self.spi.xfer2(data)
        self.result=[x for x in tmpresult]

    def SPI_read(self,num_bytes):
        '''read result from last transaction'''
        return self.result;



#import numpy as np
#LOGGER = logging.getLogger(__name__)


spi0 = SPIWraper(0)

#Weight scale configuration..
scale1 = BRIDGEADC01(spi0,0,1)
scale1.reset()
freq=scale1.setFilterAC(200)
sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))


f = open("1ScaleCalibration.txt","r")
lines = f.readlines()
f.close()

vals=lines[0].split()
scale1.setChannelOnly(0)
scale1.setOffsetRegister(int(vals[0]))
scale1.setFullScaleRegister(int(vals[1]))
scale1.setUnitCalibrationGain(float(vals[2]))

#logging
home =  os.path.expanduser("~")
path = home + "/TF-Motorscale_logs/"
try:
    os.makedirs(path)
except OSError:
    print("")
else:
    print ("Successfully created the directory %s\n" % path)

log_name = ("TF_aeroscale_log_%s.csv" % (datetime.datetime.utcfromtimestamp(time.time()).isoformat()))
filepath = path + log_name
log_file = open(filepath, "w")
print ("Using logfile %s\n" % filepath)

log_file.write(  "           system_datetime;  freq ;  scale1; \n")
sys.stdout.write("           system_datetime;  freq ;  scale1;  \n")
sys.stdout.flush() 

try:
    scale1.startConntinuousConversion(0)
    lastTime=time.time();
    w1d=False

    while 1:
        w1d=not scale1.isBusy()
        if w1d:
              w1 = scale1.measureWeight()
              currentTime=time.time();
              ts = datetime.datetime.utcfromtimestamp(time.time()).isoformat()
              sys.stdout.write("%s;  %04.1f;  %06.3f;  \r" %(ts, 1/(currentTime-lastTime), w1))
              log_file.write(  "%s;  %04.1f;  %06.3f;  \n" %(ts, 1/(currentTime-lastTime), w1))
              sys.stdout.flush()
              lastTime=currentTime
              w1d=False

except KeyboardInterrupt:
    log_file.close()
    sys.exit(0)
