#!/usr/bin/python3

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time
import datetime
import threading
from pymlab import config

from BRIDGEADC01 import BRIDGEADC01

"""
Show data from TF-AEROSCALE over SPIDEV and I2C on rpi3. 
"""

#### Script Arguments ###############################################

if len(sys.argv) != 2:
    sys.stderr.write("Invalid number of arguments.\n")
    sys.stderr.write("Usage: %s I2CPORT\n" % (sys.argv[0], ))
    sys.exit(1)

i2cport    = sys.argv[1]

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

cfg=config.Config(
        i2c = {
            "port": i2cport,
            "device": "smbus",
        },
        bus = [
            {
                "name":        "windgauge",
                "type":        "WINDGAUGE03A",
            },
            {
               "name": "rtc01",
               "type": "rtc01",
               "address": 0x50
            }
        ],
        )



spi0 = SPIWraper(0)
spi1 = SPIWraper(1)

#Weight scale configuration..
scale1 = BRIDGEADC01(spi0,0,1)
scale1.reset()
freq=scale1.setFilterAC(200)
sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))

scale2 = BRIDGEADC01(spi1,1,1)
scale2.reset()
freq=scale2.setFilterAC(200)
sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))
sys.stdout.flush()

f = open("2ScaleCalibration.txt","r")
lines = f.readlines()
f.close()

vals=lines[0].split()
scale1.setChannelOnly(0)
scale1.setOffsetRegister(int(vals[0]))
scale1.setFullScaleRegister(int(vals[1]))
scale1.setUnitCalibrationGain(float(vals[2]))

vals=lines[1].split()
scale2.setChannelOnly(0)
scale2.setOffsetRegister(int(vals[0]))
scale2.setFullScaleRegister(int(vals[1]))
scale2.setUnitCalibrationGain(float(vals[2]))

#RPM reading
counter = cfg.get_device("rtc01")
counter.set_config(counter.FUNCT_MODE_count)
counter.reset_counter()
signalPerRound=16
time.sleep(0.1)

#Diff Preasure reading
windgauge = cfg.get_device("windgauge")
windgauge.reset()
windgauge.initialize()
time.sleep(0.1)


rpm=0
dp=0.0
windgauge_spd=0.0
temp=0.0

#rpm_accuracny=0
running=1
def i2cThreadFunc():
    global rpm
    global dp
    global windgauge_spd
    global temp
    global running
    lastTime=time.time()
    lastCount=0
    while running==1:
        currentTime=time.time()
        currentCount=counter.get_count()
        rpm=(currentCount-lastCount)*60/signalPerRound/(currentTime-lastTime)
        #rpm_accurancy=60/signalPerRound/(currentTime-lastTime)
        lastTime=currentTime
        lastCount=currentCount
        dp, windgauge_spd = windgauge.get_dp_spd()
        temp = windgauge.get_temp()
        time.sleep(0.1)

thread = threading.Thread(target=i2cThreadFunc)
thread.start()


sys.stdout.write("datetime; freq; scale1; scale2; rpm;\n")
sys.stdout.flush()

try:
    scale1.startConntinuousConversion(0)
    scale2.startConntinuousConversion(0)
    lastTime=time.time();
    w1d=False
    w2d=False
    while 1:
        if not w1d:
              w1d=not scale1.isBusy()
              if w1d:
                   w1 = scale1.measureWeight()
        if not w2d:
              w2d=not scale2.isBusy()
              if w2d:
                   w2 = scale2.measureWeight()

        if w1d and w2d:
              currentTime=time.time();
              ts = datetime.datetime.utcfromtimestamp(time.time()).isoformat()
              sys.stdout.write("%s; %4.1f; %+4.3f;%+4.3f;%4.0f;%4.1f,%4.1f,%3.1f\r" %(ts, 1/(currentTime-lastTime), w1,w2,rpm,dp,windgauge_spd,temp))
              sys.stdout.flush()
              lastTime=currentTime
              w1d=False
              w2d=False

except KeyboardInterrupt:
    running=0
    thread.join()
    sys.exit(0)
