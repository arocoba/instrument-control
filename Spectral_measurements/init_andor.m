function init_andor

% INIT_ANDOR  Initialize an Andor CCD camera for Full Vertical Binning (FVB)
%
% This function loads the Andor SDK libraries, initializes communication
% with the camera, configures acquisition parameters, enables cooling,
% and prepares the detector for single acquisitions in FVB mode.
%
% Hardware:
%   - Andor CCD camera
%
% Software requirements:
%   - Andor SDK installed
%   - MATLAB loadlibrary support
%
% Notes:
%   - The DLL and header file paths may need to be modified depending on
%     the local SDK installation.
%   - The detector is cooled to -50 °C before acquisition.
%   - Exposure time is fixed to 20 ms.

if not(libisloaded('andor'))
    fprintf('Loading libraries...\n')

    % Path to the Andor SDK dynamic library (.dll) and C header (.h).
    % These files are installed with the Andor Software Development Kit (SDK)
    % and are required by MATLAB's loadlibrary() function.
    % Modify the paths below if the SDK is installed in a different location.

    dllfile = 'C:\Program Files\MATLAB\R2023b\Andor\Drivers\atmcd64d.dll'; % dynamic link library 
    hfile = 'C:\Program Files\MATLAB\R2023b\Andor\Drivers\ATMCD32D.H';     % header written in C
    
    [load_err, warr]=loadlibrary(dllfile,hfile,'alias','andor'); % alias for the libraries
  
        
end
fncs = libfunctions('andor','-full'); % Show all functions defined in ATMCD32D.H to control the spectrometer

%[err,nc]=calllib('andor','GetAvailableCameras',0);
sta=calllib('andor','GetStatus',0);
err=calllib('andor','Initialize','');
pause(2)
fprintf('return from Initialize %d\n',err) 
% If all it's OK retuns 20002. 
if err~=20002
    
    calllib('andor','ShutDown')
     fprintf('ERROR!!!!\n')
    return
end
calllib('andor','SetReadMode',0); % select the mode see manual E:\Documents and Settings\SHAKERS02\Desktop\Angel Mateos\manuals
calllib('andor','SetAcquisitionMode',1);
%calllib('andor','SetSingleTrack',60,10)
calllib('andor','SetHSSpeed',10,1);
[s,Nvs]=calllib('andor','GetNumberVSSpeeds',1);
calllib('andor','SetVSSpeed',16.250);
[err,xpixel,ypixel]=calllib('andor','GetDetector',0,0);
calllib('andor','SetTemperature',-50)
calllib('andor','CoolerON')
calllib('andor','SetTriggerMode',0); % Set Trigger : 0. Internal 1. External more in manual
ex_t = 0.02;% Exposition time in Seconds
calllib('andor','SetExposureTime',ex_t);
calllib('andor','SetShutter',1,1,0,0);
[err,at,bt,ct]=calllib('andor','GetAcquisitionTimings',ex_t,1,10);
fprintf('return from Exposure Time %d\n',err)
if err~=20002
    
    calllib('andor','ShutDown')
    fprintf('ERROR!!!!\n')
    
    return
end
[err, tmin,tmax]=calllib('andor','GetTemperatureRange',0,0);
fprintf('READY!\n')

end

% Authors Niccoló Caselli and Antonio Consoli 
% 2019 - ICMM - CSIC - Spain
