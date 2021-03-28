#!/usr/bin/python

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time

from pymlab import config
import logging

from BRIDGEADC01 import BRIDGEADC01

"""
Show data from BRIDGEADC01 module. 
"""


import numpy as np

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

print "SPI weight scale sensor with SPI interface. The interface is connected to the I2CSPI module which translates signalls. \r\n"

spi = cfg.get_device("spi")


try:
    print "SPI configuration.."
    spi.SPI_config(spi.I2CSPI_MSB_FIRST| spi.I2CSPI_MODE_CLK_IDLE_LOW_DATA_EDGE_LEADING| spi.I2CSPI_CLK_461kHz)
    spi.GPIO_config(spi.I2CSPI_SS2 | spi.I2CSPI_SS3, spi.SS2_INPUT | spi.SS3_INPUT)

    print "Weight scale configuration.."
    scale = BRIDGEADC01(spi,spi.I2CSPI_SS0,1)
    scale.reset()

    scale.setFilter()

    scale.doCalibration(0)
    scale.doCalibration(1)

    scale.setFilter()
 
    while 1:
        channel1 = scale.measureWeightSingle(0)
        channel2 = scale.measureWeightSingle(1)
        data = np.array([channel1,channel2])
        print data

except KeyboardInterrupt:
    sys.exit(0)

