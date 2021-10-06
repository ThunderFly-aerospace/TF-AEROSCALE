#!/usr/bin/python3

from mcp2210 import Mcp2210, Mcp2210GpioDesignation, Mcp2210GpioDirection

class SPIWraper:
    def __init__(self,cs_pins):
        self.mcp=Mcp2210(serial_number="0001112676")
        self.mcp.configure_spi_timing(chip_select_to_data_delay=0,
                                 last_data_byte_to_cs=0,
                                 delay_between_bytes=0)

        self.mcp._get_spi_configuration()
        self.mcp._spi_settings.bit_rate=400000
        self.mcp._spi_settings.mode=3
        self.mcp._set_spi_configuration()

        for i in range(len(cs_pins)):
            self.mcp.set_gpio_designation(cs_pins[i], Mcp2210GpioDesignation.CHIP_SELECT)

        self.result=[];

    def SPI_write(self,cs,data):
        '''write data to bus with selected CS pin'''
        tmpresult=self.mcp.spi_exchange(bytes(data), cs)
        self.result=[x for x in tmpresult]

    def SPI_read(self,num_bytes):
        '''read result from last transaction'''
        return self.result;
