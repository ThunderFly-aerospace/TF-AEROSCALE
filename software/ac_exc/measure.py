#!/usr/bin/python3

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time
import datetime

from pymlab import config
import logging

from BRIDGEADC01 import BRIDGEADC01

"""
Show data from BRIDGEADC01 module. 
"""

import numpy as np
LOGGER = logging.getLogger(__name__)

if len(sys.argv)!=2:
    sys.stderr.write("Invalid number of arguments.\n")
    sys.stderr.write("Usage: %s #I2CPORT\n" % (sys.argv[0], ))
    sys.exit(1)

port = eval(sys.argv[1])

cfg = config.Config(
    i2c = {
        "port": port,
    },

    bus = [
        { "name":"spi", "type":"i2cspi", "address": 0x28},
    ],
)

cfg.initialize()

print("SPI weight scale sensor with SPI interface. The interface is connected to the I2CSPI module which translates signalls. \r\n")

spi = cfg.get_device("spi")

try:
    print("SPI configuration..")
    spi.SPI_config(spi.I2CSPI_MSB_FIRST| spi.I2CSPI_MODE_CLK_IDLE_LOW_DATA_EDGE_LEADING| spi.I2CSPI_CLK_461kHz)
    spi.GPIO_config(spi.I2CSPI_SS2 | spi.I2CSPI_SS3, spi.SS2_INPUT | spi.SS3_INPUT)

    print("Weight scale configuration..")
    scale = BRIDGEADC01(spi,spi.I2CSPI_SS0,1)
    scale.reset()

    scale.setFilter()

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
 
    sys.stdout.write("datetime; channel1; channel2;\n")
    sys.stdout.flush()
    while 1:
        ts = datetime.datetime.utcfromtimestamp(time.time()).isoformat()
        channel1 = scale.measureWeightSingle(0)
        channel2 = scale.measureWeightSingle(1)
        sys.stdout.write("%s; %+4.2f; %+4.2f;\n" %(ts, channel1, channel2))
        sys.stdout.flush()
        
except KeyboardInterrupt:
    sys.exit(0)

