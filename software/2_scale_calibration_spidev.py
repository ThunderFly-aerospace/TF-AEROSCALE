#!/usr/bin/python3
import sys
import time

from BRIDGEADC01 import BRIDGEADC01
from spidevWraper import SpiWrapper


def doCalibration(scale, channel):

    scale.doCalibration(channel)
    offset=scale.getOffsetRegister();
    gain=scale.getFullScaleRegister();
    weight=scale.getUnitCalibrationGain();

    return [offset,gain,weight]

print("2 Weight scale configuration.. calibration of 2 weights connected to single spidev on two slave select, calibrate first channel of weights ")

spi0 = SPIWraper(0)
spi1 = SPIWraper(1)

scale1 = BRIDGEADC01(spi0,0,1)
scale1.reset()
freq=scale1.setFilterAC(200)
sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))


scale2 = BRIDGEADC01(spi1,1,1)
scale2.reset()
freq=scale2.setFilterAC(200)
sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))
sys.stdout.flush()


sys.stdout.write("\n\n\nScale 0:\n\n\n")
sys.stdout.flush()
weight0=doCalibration(scale1,0)
sys.stdout.write("\n\n\nScale 1:\n\n\n")
sys.stdout.flush()
weight1=doCalibration(scale2,0) 

f=open("2ScaleCalibration.txt","w")
f.write("%d %d %g\n" % tuple(weight0) )
f.write("%d %d %g\n" % tuple(weight1) )
f.close()

