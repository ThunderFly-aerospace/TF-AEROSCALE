#!/usr/bin/python

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time
import numpy as np

from pymlab import config
import logging

from BRIDGEADC01 import BRIDGEADC01

"""
Get calibration data from BRIDGEADC01 module. 
"""

def doCalibration(scale, channel):
    print "Calibration of channel 0:"
    print "Set zero load."
    raw_input("Press Enter to continue...")

    scale.systemZeroCalibration(channel)

    print "Set full load" 
    raw_input("Press Enter to continue...")
    scale.systemFullScaleCalibration(channel)
 
    print "Set zero load"
    raw_input("Press Enter to continue...")
    scale.systemZeroCalibration(channel)

    print "Calibration complete."

    print "offset:"
    print scale.getOffset();
    print "gain:"
    print scale.getGain();




LOGGER = logging.getLogger(__name__)
cfg = config.Config(
    i2c = {
        "port": 9,
    },

    bus = [
        { "name":"spi", "type":"i2cspi", "address": 0x28},
    ],
)

cfg.initialize()

spi = cfg.get_device("spi")

print "SPI configuration.."
spi.SPI_config(spi.I2CSPI_MSB_FIRST| spi.I2CSPI_MODE_CLK_IDLE_LOW_DATA_EDGE_LEADING| spi.I2CSPI_CLK_461kHz)
spi.GPIO_config(spi.I2CSPI_SS2 | spi.I2CSPI_SS3, spi.SS2_INPUT | spi.SS3_INPUT)

print "Weight scale configuration.."
scale = BRIDGEADC01(spi,spi.I2CSPI_SS0,1)
scale.reset()

scale.setFilter()

doCalibration(scale,0)
doCalibration(scale,1) 

