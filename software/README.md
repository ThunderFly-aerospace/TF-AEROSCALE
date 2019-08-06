# Logger

## Channel calibration
```
raw_data = true
```
Take item of known weight and write the weight to ```calibration_weight```.
Start reading data from calibrated channel and then place your item on the calibrated channel. You should see bigger number than before. Place the number to ```calibration_number```. Now set ```raw_data = false```.
```units = g``` accepts g (grams), kg (kilograms), lbs (pound), N (newtons)

## .csv custimizing
If you mechanically connect two channels for getting a bigger range, set ```common_measurement = true```