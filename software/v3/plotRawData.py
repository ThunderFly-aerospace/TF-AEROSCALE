#!/usr/bin/python3

import sys
import matplotlib.pyplot as plt

if (len(sys.argv)!=2):
    print("missing filename as argument!")
    sys.exit(-1);

f = open(sys.argv[1], 'r')
lines = f.readlines()
 
rpm=[];
scale1=[];
scale2=[];

for i in range(len(lines)):
    line=lines[i]
    if(i==0):
        continue;
    parts=line.split(";")
    scale1.append(float(parts[2]))
    scale2.append(float(parts[3]))
    rpm.append(float(parts[4]))


plt.figure(1)
plt.subplot(311)
plt.plot(rpm)
plt.subplot(312)
plt.plot(scale1)
plt.subplot(313)
plt.plot(scale2)

plt.show();
