#!/usr/bin/python3
import sys
import time

from BRIDGEADC01 import BRIDGEADC01


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


def doCalibration(scale, channel):

    scale.doCalibration(channel)
    offset=scale.getOffsetRegister();
    gain=scale.getFullScaleRegister();
    weight=scale.getUnitCalibrationGain();

    return [offset,gain,weight]

print("1 Weight scale configuration.. calibration of 1 weights connected to single spidev  calibrate first channel of weights ")

spi0 = SPIWraper(0)

scale1 = BRIDGEADC01(spi0,0,1)
scale1.reset()
freq=scale1.setFilterAC(200)
sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))
sys.stdout.flush()


sys.stdout.write("\n\n\nScale 0:\n\n\n")
sys.stdout.flush()
weight0=doCalibration(scale1,0)

f=open("1ScaleCalibration.txt","w")
f.write("%d %d %g\n" % tuple(weight0) )
f.close()

