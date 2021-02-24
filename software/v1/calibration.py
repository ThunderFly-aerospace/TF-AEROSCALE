#!/usr/bin/python

from configparser import SafeConfigParser
import I2CSPI_BRIDGEADC01

cfg_file = "logger.ini"

config = SafeConfigParser()
config.read(cfg_file)

ch_1_calibration = raw_input("channel 1 calibrate (y/n): ").lower()

if ch_1_calibration == "y":
    raw_input("release channel 1, then press enter")

    zero_calibration_1 = 0 - I2CSPI_BRIDGEADC01.get_data1()

    calibration_weight = raw_input("type calibration weight in grams: ")

    raw_input("put it on channel 1, then press enter")

    weight_number = 0
    print("starting calibration...")

    for i in range(100):
        weight_number = weight_number + I2CSPI_BRIDGEADC01.get_data1() +zero_calibration_1

    number = weight_number / 100

    config.set('channel_1', 'calibration_number', str(number))
    config.set('channel_1', 'calibration_weight', str(calibration_weight))

    with open(cfg_file, "w") as ini_file:
        config.write(ini_file)

    print("\ncalibration done!")



ch_2_calibration = raw_input("channel 2 calibrate (y/n): ").lower()

if ch_2_calibration == "y":
    raw_input("release channel 2, then press enter")

    zero_calibration_2 = 0 - I2CSPI_BRIDGEADC01.get_data2()

    calibration_weight = raw_input("type calibration weight in grams: ")

    raw_input("put it on channel 2, then press enter")

    weight_number = 0
    print("starting calibration...")

    for i in range(100):
        weight_number = weight_number + I2CSPI_BRIDGEADC01.get_data2() +zero_calibration_2

    number = weight_number / 100

    config.set('channel_2', 'calibration_number', str(number))
    config.set('channel_2', 'calibration_weight', str(calibration_weight))

    with open(cfg_file, "w") as ini_file:
        config.write(ini_file)

    print("\ncalibration done!")
