#!/usr/bin/python3

#uncomment for debbug purposes
#import logging
#logging.basicConfig(level=logging.DEBUG) 

import sys
import time
import datetime
import threading
import os
import math
from pymlab import config

from BRIDGEADC01 import BRIDGEADC01

import rclpy
from rclpy.node import Node

from std_msgs.msg import Float32

"""
Show data from TF-AEROSCALE over SPIDEV and I2C on rpi3. 
"""

#### Script Arguments ###############################################

import spidev

class SPIWraper:
    def __init__(self,cs_pin):
        self.spi=spidev.SpiDev()
        self.spi.open(0,cs_pin)

        self.spi.max_speed_hz=400000
        self.spi.mode=1

        self.result=[];

    def SPI_write(self,cs,data):
        '''write data to bus with selected CS pin'''
        tmpresult = self.spi.xfer2(data)
        self.result=[x for x in tmpresult]

    def SPI_read(self,num_bytes):
        '''read result from last transaction'''
        return self.result;

class MinimalPublisher(Node):

    def __init__(self):
        super().__init__('minimal_weight_publisher')
        self.publisher1 = self.create_publisher(Float32, 'weight_1', 10)
        self.publisher2 = self.create_publisher(Float32, 'weight_2', 10)
        self.spi0 = SPIWraper(0)
        self.spi1 = SPIWraper(1)

        #Weight scale configuration..
        self.scale1 = BRIDGEADC01(self.spi0,0,1)
        self.scale1.reset()
        freq=self.scale1.setFilterAC(200)
        sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))

        self.scale2 = BRIDGEADC01(self.spi1,1,1)
        self.scale2.reset()
        freq=self.scale2.setFilterAC(200)
        sys.stdout.write("frekvence vyčítání: %4.2f;\n" %(freq))
        sys.stdout.flush()

        f = open("2ScaleCalibration.txt","r")
        lines = f.readlines()
        f.close()

        vals=lines[0].split()
        self.scale1.setChannelOnly(0)
        self.scale1.setOffsetRegister(int(vals[0]))
        self.scale1.setFullScaleRegister(int(vals[1]))
        self.scale1.setUnitCalibrationGain(float(vals[2]))

        vals=lines[1].split()
        self.scale2.setChannelOnly(0)
        self.scale2.setOffsetRegister(int(vals[0]))
        self.scale2.setFullScaleRegister(int(vals[1]))
        self.scale2.setUnitCalibrationGain(float(vals[2]))

        self.scale1.startConntinuousConversion(0)
        self.scale2.startConntinuousConversion(0)

        self.timer = self.create_timer(0.001, self.timer_callback)
        self.w1d=False
        self.w2d=False
        self.w1=0.0
        self.w2=0.0
        self.lastTime=time.time()

    def timer_callback(self):
        if not self.w1d:
            self.w1d=not self.scale1.isBusy()
            if self.w1d:
               self.w1 = self.scale1.measureWeight()
        if not self.w2d:
            self.w2d=not self.scale2.isBusy()
            if self.w2d:
               self.w2 = self.scale2.measureWeight()

        if self.w1d and self.w2d:
            currentTime=time.time();
            ts = datetime.datetime.utcfromtimestamp(time.time()).isoformat()
            #sys.stdout.write("%s;  %04.1f;  %06.3f;  %06.3f;\n" %(ts, 1/(currentTime-self.lastTime), self.w1,self.w2))
            #sys.stdout.flush()
            self.lastTime=currentTime
            self.w1d=False
            self.w2d=False

            msg = Float32()
            msg.data = self.w1
            self.publisher1.publish(msg)

            msg2 = Float32()
            msg2.data = self.w2
            self.publisher2.publish(msg2)

def main(args=None):

    #sys.stdout.write("           system_datetime;  freq ;  scale1;  scale2;\n")
    #sys.stdout.flush()

    rclpy.init(args=args)
    minimal_publisher = MinimalPublisher()
    rclpy.spin(minimal_publisher)

    minimal_publisher.destroy_node()
    rclpy.shutdown()

if __name__=="__main__":
    main()


