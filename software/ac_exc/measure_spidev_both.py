#!/usr/bin/python3

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time
import datetime

#from pymlab import config
import logging

from BRIDGEADC01 import BRIDGEADC01

"""
Show data from BRIDGEADC01 module over SPIDEV. 
"""

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



import numpy as np
LOGGER = logging.getLogger(__name__)

spi0 = SPIWraper(0)
spi1 = SPIWraper(1)


#lastTime=time.time();
#count=0
#while 1:
#    spi.SPI_write(4,[128])
#    print(spi.SPI_read(1))


try:
    #print("SPI configuration..")
    #spi.SPI_config(spi.I2CSPI_MSB_FIRST| spi.I2CSPI_MODE_CLK_IDLE_LOW_DATA_EDGE_LEADING| spi.I2CSPI_CLK_461kHz)
    #spi.GPIO_config(spi.I2CSPI_SS2 | spi.I2CSPI_SS3, spi.SS2_INPUT | spi.SS3_INPUT)

    print("Weight scale configuration..")
    scale1 = BRIDGEADC01(spi0,0,1)
    scale2 = BRIDGEADC01(spi1,1,1)
    scale1.reset()
    scale2.reset()

    freq=scale1.setFilterAC(200)
    sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))
    sys.stdout.flush()

    freq=scale2.setFilterAC(200)
    sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))
    sys.stdout.flush()

    f = open("calibration.txt","r")
    lines = f.readlines()
    f.close()    

    i=0
    for line in lines:
        if i>1:
            break
        vals=line.split()
        scale1.setChannelOnly(i)
        scale1.setOffsetRegister(int(vals[0]))
        scale1.setFullScaleRegister(int(vals[1]))
        scale1.setUnitCalibrationGain(float(vals[2]))
        scale2.setChannelOnly(i)
        scale2.setOffsetRegister(int(vals[0]))
        scale2.setFullScaleRegister(int(vals[1]))
        scale2.setUnitCalibrationGain(float(vals[2]))
        i += 1
 
    sys.stdout.write("datetime; freq; scale1; scale2;\n")
    sys.stdout.flush()
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
              sys.stdout.write("%s; %4.1f; %+4.3f;%+4.3f;\n" %(ts, 1/(currentTime-lastTime), w1,w2))
              sys.stdout.flush()
              lastTime=currentTime
              w1d=False
              w2d=False
        
except KeyboardInterrupt:
    sys.exit(0)









