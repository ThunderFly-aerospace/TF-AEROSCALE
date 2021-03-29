# TF-AEROSCALE - Force balance for measuring lift and drag of aerodynamic surfaces

Knowledge of aircraft wings is important for optimizing their flight parameters. This scale-type device is used to measure the polar of the wing or rotor. The device is designed so that it is possible to measure wings/rotors of various sizes. Because it is difficult to obtain a enought large wind tunnel, weight is designed so that it can be operated, for example, on the roof of a [TF-R1 driving car](https://github.com/ThunderFly-aerospace/TF-R1) that ensures suficiently high quality laminar flow. 


## Features

* Robust construction to measure Lift and Drag forces up to 400 N.
* Open-source design (Open-source HW and SW)
* Scalability for different needs (OpenSCAD parametric design)
* Polar measurement capable (Lift and drag ratio calculation)
* Airspeed and groundspeed measurement
* RPM measurement (In case of rotor)
* Use on a car roof or in a wind tunnel

![Base with strain gauges](doc/img/complete.png)

![Rotor mount](doc/img/888_5502.png)

# Build

Repository use git submodules therefore an initialization of repository is needed prior make.

    git submodule init
    git submodule update

After that commands the make should be run from src directory.

    force_balance/cad/src$ make -j 4

## Electrical connection

![Elecrical connection](doc/img/wiring_draw.png)
