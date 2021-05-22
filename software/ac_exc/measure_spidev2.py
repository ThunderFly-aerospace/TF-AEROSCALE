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
    def __init__(self,cs_pins):
        self.spi=spidev.SpiDev()
        self.spi.open(0,1)

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

spi = SPIWraper([4])

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
    scale = BRIDGEADC01(spi,4,1)
    scale.reset()

    freq=scale.setFilterAC(200)
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
        scale.setChannelOnly(i)
        scale.setOffsetRegister(int(vals[0]))
        scale.setFullScaleRegister(int(vals[1]))
        scale.setUnitCalibrationGain(float(vals[2]))
        i += 1
 
    sys.stdout.write("datetime; freq; channel1;\n")
    sys.stdout.flush()
    scale.startConntinuousConversion(0)
    lastTime=time.time();
    while 1:
        if scale.isBusy():
            #sys.stdout.write("busy\n")
            #sys.stdout.flush()
            #time.sleep(0.25)
            continue
        currentTime=time.time();
        ts = datetime.datetime.utcfromtimestamp(time.time()).isoformat()
        channel1 = scale.measureWeight()
        sys.stdout.write("%s; %4.1f; %+4.3f;\n" %(ts, 1/(currentTime-lastTime), channel1))
        sys.stdout.flush()
        lastTime=currentTime
        
except KeyboardInterrupt:
    sys.exit(0)









