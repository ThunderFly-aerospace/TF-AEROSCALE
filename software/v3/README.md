# Software for weight

this folder contains scripts for measurement on weight.

## scripts
  - 1_scale_calibration_spidev.py kalibrace zapúojení s jedním nenzometrem
  - 1_scale_measure_spidev.py měření s jedním tenzometrem, výstup CSV (?)
  - 1ScaleCalibration.txt kalibrační data
  - 2_scale_calibration_spidev.py kalibrace zapojení se 2 tenzometry
  - 2_scale_measure_spidev.py měření se 2 tenzometry, výstup CSV (?)
  - 2_scale_measure_spidev_rpm_dp.py měření se dvema tenzometry a rpm a diff preasure I2C senzory, výstup CSV
  - py_pub_weight_2.py - měření 2 tenzometrů publiikovaných do ROS2
  
## wrapers (not tested yet)
V poslední úpravě byly smazány staré verze kodu podporující připojení převodníku přes jiné SPI sběrnice. 
Tyto části kódu byly vykopírovány do SPI Wraperů, které by měi mít jednoté rozhraní, které používá třída váhy, ale zatím to neplatí a na víc to není vyzkoušené.
Jediný wraper který by měl být funkční je spidevWraper, a také jako jedniný byl testován se 2 tenzometry - starší způsoby byly testovány s jedním tenzometrem


