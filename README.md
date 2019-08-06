# force_balance
A device to measure of lift and drag of rotor.


![Base with strain gauges](doc/img/888_5501.png)

![Rotor mount](doc/img/888_5502.png)


# Build

Repository use git submodules therefore an initialization of repository is needed prior make. 

    git submodule init
    git submodule update

After that commands the make should be run from src directory. 

    force_balance/cad/src$ make -j 4
