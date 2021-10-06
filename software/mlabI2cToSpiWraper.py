#!/usr/bin/python3

from pymlab import config


class SPIWraper:
    def __init__(self,port):
        self.cfg = config.Config(
            i2c = {
                "port": port,
            },

            bus = [
                { "name":"spi", "type":"i2cspi", "address": 0x28},
            ],
        )

        cfg.initialize()
        self.spi = cfg.get_device("spi")
        self.spi.SPI_config(self.spi.I2CSPI_MSB_FIRST| self.spi.I2CSPI_MODE_CLK_IDLE_LOW_DATA_EDGE_LEADING| self.spi.I2CSPI_CLK_461kHz)
        self.spi.GPIO_config(self.spi.I2CSPI_SS2 | self.spi.I2CSPI_SS3, self.spi.SS2_INPUT | self.spi.SS3_INPUT)


    def SPI_write(self,cs,data):
        '''write data to bus with selected CS pin'''
        self.spi.SPI_write(cs,data);

    def SPI_read(self,num_bytes):
        '''read result from last transaction'''
        return self.spi.SPI_read(num_bytes);

