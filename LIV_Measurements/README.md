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
* ThorlabsPowerMeter MATLAB wrapper

## Driver Installation

The power meter communication relies on the MATLAB wrapper `ThorlabsPowerMeter`, developed by Zimo Zhao (University of Oxford).

Before running the script:

1. Install the Thorlabs Optical Power Monitor software.
2. Download the `ThorlabsPowerMeter` MATLAB wrapper.
3. Verify that the required Thorlabs .NET DLL files are available on your system.
4. Edit the variable `METERPATHDEFAULT` or 'MOTORPATHDEFAULT' for a previous typo, inside `ThorlabsPowerMeter.m` so that it points to the folder containing the DLL files.

Depending on the local MATLAB and VISA installation, it may also be necessary to add the VISA runtime path:

```matlab
setenv('PATH',[getenv('PATH') ';C:\Program Files\IVI Foundation\VISA\Win64\Bin']);
```

If the power meter is not detected, check both the DLL path and the VISA installation.

## Usage

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
* The power meter wavelength is configured to 635 nm.
* Current resolution is set to 0.1 mA.
* The laser output is automatically disabled at the end of the measurement.

## Acknowledgements

Power meter communication is based on the MATLAB wrapper developed by Zimo Zhao (University of Oxford) for Thorlabs PM100 series power meters.

## Author

Antonio Consoli
Universidad Rey Juan Carlos (URJC)
Instituto de Ciencia de Materiales de Madrid (ICMM-CSIC)
