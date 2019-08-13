#!/usr/bin/python

from ConfigParser import SafeConfigParser
import I2CSPI_BRIDGEADC01
import datetime
import time
import os
import sys

cfg_file = "logger.ini"
gravity = 9.81

config = SafeConfigParser()
config.read(cfg_file)

if config.get("channel_1", "zero_calibration") == 'true':
    zero_calibration_1 = 0 - I2CSPI_BRIDGEADC01.get_data1()

elif config.get("channel_1", "zero_calibration") == 'false':
    zero_calibration_1 = I2CSPI_BRIDGEADC01.get_data1()


if config.get("channel_2", "zero_calibration") == 'true':
    zero_calibration_2 = 0 - I2CSPI_BRIDGEADC01.get_data2()

elif config.get("channel_2", "zero_calibration") == 'false':
    zero_calibration_2 = I2CSPI_BRIDGEADC01.get_data2()

def channel_1():
    return I2CSPI_BRIDGEADC01.get_data1() + zero_calibration_1

def channel_2():
    return I2CSPI_BRIDGEADC01.get_data2() + zero_calibration_2



def ch1_calibrated():
    ch1_calibration_number = int(config.get('channel_1', 'calibration_number'))
    ch1_calibration_weight = int(config.get('channel_1', 'calibration_weight'))

    if config.get('channel_1', 'units') == 'g':
        return ch1_calibration_weight * channel_1() / ch1_calibration_number

    elif config.get('channel_1', 'units') == 'kg':
        return float(ch1_calibration_weight) * float(channel_1()) / float(ch1_calibration_number) / float(1000)

    elif config.get('channel_1', 'units') == 'lbs':
        return float(ch1_calibration_weight) * float(channel_1()) / float(ch1_calibration_number) * float(0.00220462262)

    elif config.get('channel_1', 'units') == 'N':
        return float(ch1_calibration_weight) * float(channel_1()) / float(ch1_calibration_number) / float(1000) * float(gravity)


def ch2_calibrated():
    ch2_calibration_number = int(config.get('channel_2', 'calibration_number'))
    ch2_calibration_weight = int(config.get('channel_2', 'calibration_weight'))

    if config.get('channel_2', 'units') == 'g':
        return ch2_calibration_weight * channel_2() / ch2_calibration_number
    elif config.get('channel_2', 'units') == 'kg':
        return float(ch2_calibration_weight) * float(channel_2()) / float(ch2_calibration_number) / float(1000)
    elif config.get('channel_2', 'units') == 'lbs':
        return float(ch2_calibration_weight) * float(channel_2()) / float(ch2_calibration_number) * float(0.00220462262)
    elif config.get('channel_2', 'units') == 'N':
        return float(ch2_calibration_weight) * float(channel_2()) / float(ch2_calibration_number) / float(1000) * float(gravity)

if config.get('log', 'file') == 'true':
    now = datetime.datetime.now()
    filename = str(now.year)+"-"+str(now.month)+"-"+str(now.day)+"T"+str(now.hour)+":"+str(now.minute)+".csv"
    file = open(filename, "w")
    if config.get('log', 'headline') == 'true':
        if config.get('log', 'average_value') == 'false':
            if config.get('log', 'common_measurement') == 'false':
                file.write('timestamp,CH1 ['+config.get('channel_1', 'units')+'],CH2 ['+config.get('channel_2', 'units')+']\r\n')
            elif config.get('log', 'common_measurement') == 'true':
                file.write('timestamp,CH1 ['+config.get('channel_1', 'units')+'],CH2 ['+config.get('channel_2', 'units')+'],common\r\n')
        elif config.get('log', 'average_value') == 'true':
            if config.get('log', 'common_measurement') == 'false':
                file.write('timestamp,CH1 ['+config.get('channel_1', 'units')+'],CH2 ['+config.get('channel_2', 'units')+'],AVG\r\n')
            elif config.get('log', 'common_measurement') == 'true':
                file.write('timestamp,CH1 ['+config.get('channel_1', 'units')+'],CH2 ['+config.get('channel_2', 'units')+'],AVG,common\r\n')
    file.close()
    os.chmod(filename, 0o666)
    print("\n-Start logging into "+filename)

try:
    while True:
        if config.get('channel_1', 'raw_data') == 'false':
            channel1 = ch1_calibrated()
        else:
            channel1 = channel_1()

        if config.get('channel_2', 'raw_data') == 'false':
            channel2 = ch2_calibrated()
        else:
            channel2 = channel_2()

        if config.get('log', 'common_measurement') == 'false':
            print(str(channel1)+"   "+str(channel2))
        elif config.get('log', 'common_measurement') == 'true':
            print(str(channel1)+"   "+str(channel2)+"      "+str(channel1+channel2))

        if config.get('log', 'file') == 'true':
            with open(filename, "a") as file:
                if config.get('log', 'average_value') == 'false':
                    if config.get('log', 'common_measurement') == 'false':
                        file.write(str(time.time())+","+str(channel1)+","+str(channel2)+"\r\n")
                    elif config.get('log', 'common_measurement') == 'true':
                        file.write(str(time.time())+","+str(channel1)+","+str(channel2)+","+str(channel1+channel2)+"\r\n")
                elif config.get('log', 'average_value') == 'true':
                    if config.get('log', 'common_measurement') == 'false':
                        file.write(str(time.time())+","+str(channel1)+","+str(channel2)+","+str((channel1+channel2)/2)+"\r\n")
                    elif config.get('log', 'common_measurement') == 'true':
                        file.write(str(time.time())+","+str(channel1)+","+str(channel2)+","+str((channel1+channel2)/2)+","+str(channel1+channel2)+"\r\n")

except KeyboardInterrupt:
    sys.exit(0)