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

skip=3000;
limit=skip+4800;
window=200;

sumscale1=0;
sumscale2=0;

prumscale1=[];
prumscale2=[];

for i in range(min(len(lines),limit)):
    line=lines[i]
    if(i<skip):
        continue;
    parts=line.split(";")
    scale1.append(float(parts[2]))
    scale2.append(float(parts[3]))
    rpm.append(float(parts[4]))

    sumscale1=sumscale1+scale1[i-skip];
    sumscale2=sumscale2+scale2[i-skip];

    if i>window+skip:
        sumscale1=sumscale1-scale1[i-skip-window];
        sumscale2=sumscale2-scale2[i-skip-window];

    prumscale1.append(sumscale1/window)
    prumscale2.append(sumscale2/window)

plt.figure(1)
plt.subplot(311)
plt.plot(rpm)
plt.subplot(312)
plt.plot(scale1)
plt.subplot(313)
plt.plot(scale2)

plt.figure(2)
plt.subplot(311)
plt.plot(rpm)
plt.subplot(312)
plt.plot(prumscale1)
plt.subplot(313)
plt.plot(prumscale2)

plt.show();
