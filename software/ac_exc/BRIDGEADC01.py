import time

class BRIDGEADC01:
    """
    Driver for the AD7730/AD7730L bridge ADC device. 
    """

    def __init__(self,spi, SPI_CS,bipolar):

        self.spi=spi
        self.CS = SPI_CS

        #AD7730 register address
        self.AD7730_COMM_REG            =0b000
        self.AD7730_STATUS_REG          =0b000
        self.AD7730_DATA_REG            =0b001
        self.AD7730_MODE_REG            =0b010
        self.AD7730_FILTER_REG          =0b011
        self.AD7730_DAC_REG             =0b100
        self.AD7730_OFFSET_REG          =0b101
        self.AD7730_GAIN_REG            =0b110
        self.AD7730_TEST_REG            =0b111      # do not change state of this register

        self.AD7730_IDLE_MODE           =0b000
        self.AD7730_CCONVERSION_MODE    =0b001
        self.AD7730_SCONVERSION_MODE    =0b010
        self.AD7730_POWERDOWN_MODE      =0b011
        self.AD7730_INT_ZERO_CALIBRATION=0b100
        self.AD7730_INT_FULL_CALIBRATION=0b101
        self.AD7730_SYSTEM_ZERO_CALIBRATION=0b110
        self.AD7730_SYSTEM_FULL_CALIBRATION=0b111

        self.AD7730_BIIPOLAR_MODE        =0b0
        self.AD7730_UNIPOLAR_MODE       =0b1
        self.AD7730_IOENABLE_MODE       =0b1
        self.AD7730_IODISABLE_MODE      =0b0
        self.AD7730_16bitDATA_MODE      =0b0
        self.AD7730_24bitDATA_MODE      =0b1
        self.AD7730_REFERENCE_2V5       =0b0        
        self.AD7730_REFERENCE_5V        =0b1
        self.AD7730_10mVIR_MODE         =0b00
        self.AD7730_20mVIR_MODE         =0b01
        self.AD7730_40mVIR_MODE         =0b10
        self.AD7730_80mVIR_MODE         =0b11
        self.AD7730_MCLK_ENABLE_MODE    =0b0
        self.AD7730_MCLK_DISABLE_MODE   =0b1
        self.AD7730_BURNOUT_DISABLE     =0b0
        self.AD7730_BURNOUT_ENABLE      =0b1
        self.AD7730_AIN1P_AIN1N         =0b00
        self.AD7730_AIN2P_AIN2N         =0b01
        self.AD7730_AIN1N_AIN1N         =0b10 #nois test purpose - internaly connected together
        self.AD7730_AIN1N_AIN2N         =0b11  

        if bipolar==1:
            self.polarity=self.AD7730_BIIPOLAR_MODE     
        else:
            self.polarity=self.AD7730_UNIPOLAR_MODE 

        self.den = self.AD7730_IODISABLE_MODE
        self.iovalue = 0b00
        self.data_length = self.AD7730_24bitDATA_MODE
        self.reference = self.AD7730_REFERENCE_5V
        #self.input_range = self.AD7730_80mVIR_MODE
        self.input_range =self.AD7730_10mVIR_MODE
        self.clock_enable = self.AD7730_MCLK_ENABLE_MODE
        self.burn_out = self.AD7730_BURNOUT_DISABLE

        self.calibrationCoeficient=[1.0,1.0]
        self.currentChannel=-1;


    def reset(self):
        self.spi.SPI_write(self.CS, [0xFF])       # wrinting least 32 serial clock with 1 at data input resets the device. 
        self.spi.SPI_write(self.CS, [0xFF])
        self.spi.SPI_write(self.CS, [0xFF])
        self.spi.SPI_write(self.CS, [0xFF])

    def single_write(self, register, value):
        comm_reg = (0b00000 << 3) + register
        self.spi.SPI_write(self.CS, [comm_reg] + value)

    def single_read(self, register):
        '''
        Reads data from desired register only once. 
        '''
        
        comm_reg = (0b00010 << 3) + register

        if register == self.AD7730_STATUS_REG:
            bytes_num = 1
        elif register == self.AD7730_DATA_REG:
            bytes_num = 3
        elif register == self.AD7730_MODE_REG:
            bytes_num = 2
        elif register == self.AD7730_FILTER_REG:
            bytes_num = 3
        elif register == self.AD7730_DAC_REG:
            bytes_num = 1
        elif register == self.AD7730_OFFSET_REG:
            bytes_num = 3
        elif register == self.AD7730_GAIN_REG:
            bytes_num = 3
        elif register == self.AD7730_TEST_REG:
            bytes_num = 3

        command = [comm_reg] + ([0x00] * bytes_num)
        self.spi.SPI_write(self.CS, command)
        data = self.spi.SPI_read(bytes_num + 1)        
        return data[1:]

    def getStatus(self):

        """
        RDY - Ready Bit. This bit provides the status of the RDY flag from the part. The status and function of this bit is the same as the RDY output pin. A number of events set the RDY bit high as indicated in Table XVIII in datasheet

        STDY - Steady Bit. This bit is updated when the filter writes a result to the Data Register. If the filter is
        in FASTStep mode (see Filter Register section) and responding to a step input, the STDY bit
        remains high as the initial conversion results become available. The RDY output and bit are set
        low on these initial conversions to indicate that a result is available. If the STDY is high, however,
        it indicates that the result being provided is not from a fully settled second-stage FIR filter. When the
        FIR filter has fully settled, the STDY bit will go low coincident with RDY. If the part is never placed
        into its FASTStep mode, the STDY bit will go low at the first Data Register read and it is
        not cleared by subsequent Data Register reads. A number of events set the STDY bit high as indicated in Table XVIII. STDY is set high along with RDY by all events in the table except a Data Register read.

        STBY - Standby Bit. This bit indicates whether the AD7730 is in its Standby Mode or normal mode of
        operation. The part can be placed in its standby mode using the STANDBY input pin or by
        writing 011 to the MD2 to MD0 bits of the Mode Register. The power-on/reset status of this bit
        is 0 assuming the STANDBY pin is high.

        NOREF - No Reference Bit. If the voltage between the REF IN(+) and REF IN(-) pins is below 0.3 V, or either of these inputs is open-circuit, the NOREF bit goes to 1. If NOREF is active on completion of a conversion, the Data Register is loaded with all 1s. If NOREF is active on completion of a calibration, updating of the calibration registers is inhibited."""

        status = self.single_read(self.AD7730_STATUS_REG)
        bits_values = dict([('NOREF',status[0] & 0x10 == 0x10),
                            ('STBY',status[0] & 0x20 == 0x20),
                            ('STDY',status[0] & 0x40 == 0x40),
                            ('RDY',status[0] & 0x80 == 0x80)])
        return bits_values
    
    def getReg24bit(self,reg):
        data = self.single_read(reg)
        value = (data[0] << 16) + (data[1] << 8) + data[2]
        #if self.polarity==self.AD7730_BIIPOLAR_MODE:
        #    value -= 0x800000
        return value

    def setReg24bit(self,reg,data):
        self.single_write(reg, [(data & 0xFF0000)>>16,(data & 0x00FF00)>>8,(data & 0x0000FF)])

    def isBusy(self):
        """ Return True if ADC is busy """
        status = self.getStatus()
        return status['RDY']

    def wait(self):
        while self.isBusy():            ## wait for RDY pin to go low to indicate end of callibration cycle. 
            #print scale.getStatus()
            time.sleep(0.1)

    def setMode(self
                    ,mode
                    ,polarity 
                    ,den 
                    ,iovalue 
                    ,data_length 
                    ,reference 
                    ,input_range 
                    ,clock_enable 
                    ,burn_out 
                    ,channel):
        '''
        def setMode(self
                    ,mode = self.AD7730_IDLE_MODE
                    ,polarity = self.AD7730_BIIPOLAR_MODE
                    ,den = self.AD7730_IODISABLE_MODE
                    ,iovalue = 0b00
                    ,data_lenght = self.AD7730_24bitDATA_MODE
                    ,reference = self.AD7730_REFERENCE_5V
                    ,input_range = self.AD7730_40mVIR_MODE
                    ,clock_enable = self.AD7730_MCLK_ENABLE_MODE
                    ,burn_out = self.AD7730_BURNOUT_DISABLE
                    ,channel = self.AD7730_AIN1P_AIN1N
               ):
        '''
        mode_MSB = (mode << 5) + (polarity << 4) + (den << 3) + (iovalue << 1) + data_length
        mode_LSB = (reference << 7) + (0b0 << 6) + (input_range << 4) + (clock_enable << 3) + (burn_out << 2) + channel
    
        self.single_write(self.AD7730_MODE_REG, [mode_MSB, mode_LSB])        

    def setFilter(self):
        '''
        Do some magic, (btw. set AC excitation)
        '''
        data = self.single_read(self.AD7730_FILTER_REG)
        data[2] = data[2] | 0b00110011
        self.single_write(self.AD7730_FILTER_REG, data)
        return data

    def blockingOperation(self,mode,channel_num):
        if channel_num==0:
            channel = self.AD7730_AIN1P_AIN1N

        if channel_num==1:
            channel = self.AD7730_AIN2P_AIN2N

        self.currentChannel=channel_num
        self.setMode(
                         mode = mode
                        ,polarity=self.polarity  
                        ,den = self.den
                        ,iovalue = self.iovalue
                        ,data_length = self.data_length
                        ,reference = self.reference
                        ,input_range = self.input_range
                        ,clock_enable = self.clock_enable
                        ,burn_out = self.burn_out
                        ,channel = channel
			        )
        time.sleep(0.25)
        self.wait()

    def systemZeroCalibration(self,channel_num):
        '''
        zero calibration using connected tenzometer with zero load
        '''
        self.blockingOperation(self.AD7730_SYSTEM_ZERO_CALIBRATION,channel_num)

    def internalZeroCalibration(self,channel_num):
        '''
        zero calibration with 0V connected internaly
        '''
        self.blockingOperation(self.AD7730_INT_ZERO_CALIBRATION,channel_num)

    def systemFullScaleCalibration(self,channel_num):
        '''
        full scale calibration with tenozmeter connected and fully loaded.
        Not sure, but do do zero calibration before and after this calibration
        '''
        self.blockingOperation(self.AD7730_SYSTEM_FULL_CALIBRATION,channel_num)

    def internalFullScaleCalibration(self,channel_num):
        '''
        full scale calibration with max input voltage conected internaly.
        Not sure, but do do zero calibration before and after this calibration
        '''
        self.blockingOperation(self.AD7730_INT_FULL_CALIBRATION,channel_num)
        
    def doSingleConversion(self,channel_num):
        '''
        do single conversion of selected channel
        '''
        self.blockingOperation(self.AD7730_SCONVERSION_MODE,channel_num)

    def getData(self):
        '''
        Read data register for last used selected channel
        '''
        value=self.getReg24bit(self.AD7730_DATA_REG)
        if self.polarity==self.AD7730_BIIPOLAR_MODE:
            value -= 0x800000
        return value

    def getFullScaleRegister(self):
        '''
        Read gain register for last used selected channel
        '''
        return self.getReg24bit(self.AD7730_GAIN_REG)


    def getOffsetRegister(self):
        '''
        Read offset register for last used selected channel
        '''
        return self.getReg24bit(self.AD7730_OFFSET_REG)

    def getUnitCalibrationGain(self):
        '''
        Read calibration parameter
        '''
        return self.calibrationCoeficient[self.currentChannel]

    def setChannelOnly(self, channel_num):
        if channel_num==0:
            channel = self.AD7730_AIN1P_AIN1N

        if channel_num==1:
            channel = self.AD7730_AIN2P_AIN2N
    
        mode = self.single_read(self.AD7730_MODE_REG)
        mode[1] = (mode[1] & 0b11111100) | channel
        self.single_write(self.AD7730_MODE_REG, mode)
        self.currentChannel=channel_num

    def setFullScaleRegister(self, gainReg):
        '''
        Set gain register value for last used channel -
        gain is about Register/0x400000.
        https://ez.analog.com/data_converters/precision_adcs/w/documents/3067/ad7730-calibration-coefficient
        '''
        self.setReg24bit(self.AD7730_GAIN_REG,gainReg)

    def setOffsetRegister(self, offset):
        '''
        Set offset register value for last used channel.
        '''
        self.setReg24bit(self.AD7730_OFFSET_REG,offset)

    def setUnitCalibrationGain(self, coeficient):
        '''
        Set calibration gain coeficient
        result from ADC is multiplied by this coeficient to get results in some Weight units 
        '''
        self.calibrationCoeficient[self.currentChannel]=coeficient

    def measureWeightSingle(self, channel_num):
        self.doSingleConversion(channel_num)
        data=self.calibrationCoeficient[channel_num]*self.getData()
        return data

    def doCalibration(self,channel):
        input("Place zero weight on scale:")
        self.systemZeroCalibration(channel)
        print("System Zero scale calibration completed..")
        self.internalFullScaleCalibration(channel)
        print("Internal Full scale calibration completed...")
        self.systemZeroCalibration(channel)
        print("System Zero scale calibration completed...")

        print("Offset register")
        print(self.getOffsetRegister());
        print("Full Scale regiser")
        print(self.getFullScaleRegister());

        input("Place single unit of weight on scale:")
        self.doSingleConversion(channel)
        weight=self.getData()
        self.setUnitCalibrationGain(1.0/weight);
        print("Calibration coef:")
        print(1.0/weight)
        print("Done.")

