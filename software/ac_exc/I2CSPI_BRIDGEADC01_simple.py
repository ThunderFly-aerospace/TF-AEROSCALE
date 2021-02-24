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

##from vispy import app, scene, color

import numpy as np

LOGGER = logging.getLogger(__name__)

    

    


"""canvas = scene.SceneCanvas(keys='interactive', show=True, size=(1024, 768))
grid = canvas.central_widget.add_grid()
view = grid.add_view(0, 1)
view.camera = scene.MagnifyCamera(mag=1, size_factor=0.5, radius_ratio=0.6)

# Add axes
yax = scene.AxisWidget(orientation='left')
yax.stretch = (0.05, 1)
grid.add_widget(yax, 0, 0)
yax.link_view(view)

xax = scene.AxisWidget(orientation='bottom')
xax.stretch = (1, 0.05)
grid.add_widget(xax, 1, 1)
xax.link_view(view)


N = 4
M = 1000

view.camera.rect = (0, 526200, 1, 500)

lines = scene.ScrollingLines(n_lines=N, line_size=M, columns=1, dx=0.8/M, #color = 'red',
                             cell_size=(1, 8), parent=view.scene)
lines.transform = scene.STTransform(scale=(1, 1/8.))

"""

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
    scale = BRIDGEADC01(spi,spi.I2CSPI_SS0)

    scale.reset()

    scale.setFilter()

    scale.setMode(
                     mode = scale.AD7730_SYSTEM_ZERO_CALIBRATION
                    ,polarity = scale.AD7730_BIIPOLAR_MODE
                    ,den = scale.AD7730_IODISABLE_MODE
                    ,iovalue = 0b00
                    ,data_length = scale.AD7730_24bitDATA_MODE
                    ,reference = scale.AD7730_REFERENCE_5V
                    ,input_range = scale.AD7730_80mVIR_MODE
                    ,clock_enable = scale.AD7730_MCLK_ENABLE_MODE
                    ,burn_out = scale.AD7730_BURNOUT_DISABLE
                    ,channel = scale.AD7730_AIN1P_AIN1N
                )

    while scale.IsBusy():            ## wait for RDY pin to go low to indicate end of callibration cycle. 
        print scale.getStatus()
        time.sleep(0.1)

    print "system Zero scale calibration completed.."



    scale.setMode(
                     mode = scale.AD7730_INT_FULL_CALIBRATION
                    ,polarity = scale.AD7730_BIIPOLAR_MODE
                    ,den = scale.AD7730_IODISABLE_MODE
                    ,iovalue = 0b00
                    ,data_length = scale.AD7730_24bitDATA_MODE
                    ,reference = scale.AD7730_REFERENCE_5V
                    ,input_range = scale.AD7730_80mVIR_MODE
                    ,clock_enable = scale.AD7730_MCLK_ENABLE_MODE
                    ,burn_out = scale.AD7730_BURNOUT_DISABLE
                    ,channel = scale.AD7730_AIN1P_AIN1N
				)
    print "Internal Full scale calibration started"

    while scale.IsBusy():            ## wait for RDY pin to go low to indicate end of callibration cycle. 
        print scale.single_read(scale.AD7730_MODE_REG)
        time.sleep(0.1)

    print "Full scale calibration completed. Start zero scale calibration"



#    spi.SPI_write(spi.I2CSPI_SS0, [0x02, 0x91, 0x80])
    scale.setMode(
                     mode = scale.AD7730_SYSTEM_ZERO_CALIBRATION
                    ,polarity = scale.AD7730_BIIPOLAR_MODE
                    ,den = scale.AD7730_IODISABLE_MODE
                    ,iovalue = 0b00
                    ,data_length = scale.AD7730_24bitDATA_MODE
                    ,reference = scale.AD7730_REFERENCE_5V
                    ,input_range = scale.AD7730_80mVIR_MODE
                    ,clock_enable = scale.AD7730_MCLK_ENABLE_MODE
                    ,burn_out = scale.AD7730_BURNOUT_DISABLE
                    ,channel = scale.AD7730_AIN1P_AIN1N
                )

    while scale.IsBusy():            ## wait for RDY pin to go low to indicate end of callibration cycle. 
        print scale.getStatus()
        time.sleep(0.1)

    print "System Zero scale calibration completed.. Start reading the data.."

    scale.setFilter()

    while 1:

        scale.setMode(
                     mode = scale.AD7730_SCONVERSION_MODE
                    ,polarity = scale.AD7730_BIIPOLAR_MODE
                    ,den = scale.AD7730_IODISABLE_MODE
                    ,iovalue = 0b00
                    ,data_length = scale.AD7730_24bitDATA_MODE
                    ,reference = scale.AD7730_REFERENCE_5V
                    ,input_range = scale.AD7730_80mVIR_MODE
                    ,clock_enable = scale.AD7730_MCLK_ENABLE_MODE
                    ,burn_out = scale.AD7730_BURNOUT_DISABLE
                    ,channel = scale.AD7730_AIN1P_AIN1N
                )

        while scale.IsBusy():            ## wait for RDY pin to go low to indicate end of callibration cycle. 
            time.sleep(0.05)

        channel1 = scale.getData()

        data = np.array([channel1])
        print data

except KeyboardInterrupt:
    sys.exit(0)

