# Spectral Characterization with Arroyo and Andor Instruments

MATLAB routines for automated spectral measurements of semiconductor laser diodes using an Arroyo 6305 ComboSource and an Andor CCD spectrometer.

## Description

This code provides a simple framework for acquiring optical spectra as a function of injection current. The system combines:

* An Arroyo 6305 laser diode controller for current injection.
* An Andor CCD spectrometer for optical spectrum acquisition.

The package currently contains three functions:

### init_andor.m

Initializes the Andor camera and configures it for Full Vertical Binning (FVB) operation.

Main tasks:

* Loads the Andor SDK libraries.
* Initializes communication with the camera.
* Configures acquisition parameters.
* Enables detector cooling.
* Sets the exposure time and trigger mode.

This function must be executed before any spectral acquisition.

### get_spectra.m

Acquires one or more spectra from the Andor detector.

Input:

```matlab
out = get_spectra(na);
```

where `na` is the number of spectra to average.

Output:

* Column vector containing the acquired spectrum (1024 pixels).

When `na > 1`, multiple acquisitions are averaged to improve the signal-to-noise ratio.

### acq_spe.m

Performs an automated current sweep while acquiring optical spectra.

Input:

```matlab
specs = acq_spe(current_vector);
```

Example:

```matlab
current_vector = 10:2:50;
specs = acq_spe(current_vector);
```

Output:

* Matrix of size `1024 × N`, where each column corresponds to the spectrum acquired at one current value.

At each current step:

1. The current is sent to the Arroyo controller.
2. The laser output is allowed to stabilize.
3. Five spectra are acquired and averaged.
4. The resulting spectrum is stored.

After the scan, the laser current is returned to zero and the output is disabled automatically.

## Hardware

* Arroyo 6305 ComboSource
* Andor CCD spectrometer
* Semiconductor laser diode

## Software Requirements

* MATLAB
* Andor Software Development Kit (SDK)
* MATLAB Instrument Control support
* Arroyo serial communication access

## Installation Notes

The function `init_andor.m` requires access to the Andor SDK files:

```text
atmcd64d.dll
ATMCD32D.H
```

Depending on the local installation, the paths specified in the code may need to be modified.

Example:

```matlab
dllfile = 'C:\Program Files\MATLAB\R2023b\Andor\Drivers\atmcd64d.dll';
hfile   = 'C:\Program Files\MATLAB\R2023b\Andor\Drivers\ATMCD32D.H';
```

Users should verify that the SDK files exist at the specified locations before running the code.

## Typical Workflow

```matlab
init_andor;

current = 10:2:50;

spectra = acq_spe(current);
```

The variable `spectra` contains all acquired spectra and can be used for further spectral analysis, wavelength calibration, peak tracking, or LIV characterization.

## Author

Antonio Rocoba

Rey Juan Carlos University (URJC)

Madrid Institute of Materials Science (ICMM-CSIC)

Madrid, Spain
