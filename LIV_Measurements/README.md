# LIV Measurements

MATLAB script for automated Light-Current-Voltage (LIV) characterization of semiconductor laser diodes.

The script controls an Arroyo 6305 ComboSource current and temperature controller together with a Thorlabs PM100USB optical power meter. For each injected current value, the software records:

* Laser diode voltage (V)
* Optical output power (L)

The laser temperature is automatically stabilized at 20 °C using the integrated TEC controller before starting the measurement.

## Hardware

* Arroyo Instruments 6305 ComboSource
* Thorlabs PM100USB power meter
* Semiconductor laser diode under test

## Software Requirements

* MATLAB
* MATLAB Serial Port support
* Thorlabs Power Meter MATLAB driver (`ThorlabsPowerMeter`)

## Usage

Define the current vector in mA and run:

```matlab
current = 0:5:100;
out = liv(current);
```

The output matrix contains:

| Column | Description             |
| ------ | ----------------------- |
| 1      | Laser diode voltage (V) |
| 2      | Optical power (W)       |

The script also generates:

* Current versus voltage plot
* Current versus optical power plot

## Notes

* The script assumes the Arroyo controller is connected to `COM5`.
* The laser temperature is fixed at 20 °C.
* The optical power meter wavelength is configured to 635 nm.
* Current resolution is set to 0.1 mA.
* The laser output is automatically disabled at the end of the measurement.

## Author

Antonio Consoli
Universidad Rey Juan Carlos (URJC)
Instituto de Ciencia de Materiales de Madrid (ICMM-CSIC)
