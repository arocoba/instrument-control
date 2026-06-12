function out = liv(cur_v)

% Takes an input vector cur_v in mA
% Returns V and L at each I
% example use:
% cur_v = [5:5:100]; is current between 5 mA and 100 mA with 5 mA step
% call:
& lv = liv(cur_v);
% returns two columns matrix lv, with first column power, second column voltage

close all;

% Thorlabs PM100USB
% Thorlabs PM100USB support requires the ThorlabsPowerMeter MATLAB wrapper.
% Depending on the local installation, the DLL path may need to be edited
% inside ThorlabsPowerMeter.m (METERPATHDEFAULT variable).

% Some installations may require adding the VISA runtime path
% for communication with the Thorlabs PM100 power meter.
% Uncomment the following line if MATLAB cannot detect the power meter.
%
% setenv('PATH', [getenv('PATH') ';C:\Program Files\IVI Foundation\VISA\Win64\Bin']);

meter_list = ThorlabsPowerMeter;                        % Initiate the meter_list
DeviceDescription = meter_list.listdevices;             % List available device(s)
test_meter = meter_list.connect(DeviceDescription,1);   % Connect single/the first devices


test_meter.setWaveLength(635);  			% Set sensor wavelength
test_meter.setAttenuation(0);                           % Set Attenuation
test_meter.setPowerAutoRange(1);                        % Set Autorange
pause(5)                                                % Pause to allow the power meter to adjust
test_meter.setAverageTime(0.01);                        % Set average time for the measurement
test_meter.setTimeout(2000);      			% Set timeout

% Call Arroyo 6305 ComboSource, 500mA
global serial_6305;
serial_6305 = serialport("COM5",9600,"Timeout",6);
serial_6305.BaudRate = 38400;

% set t = 20ºC and turn on TEC
set_t(20);

% set current resolution
writeline(serial_6305,"LASer:LDIRES 0.1"); % resolution in mA
% turn on laser
writeline(serial_6305,"LASer:OUTput 1");
pause(4); % takes time to turn on

% for cycle
v_ld = zeros(length(cur_v),1); 		% voltages
pow = zeros(length(cur_v),1); 		% power

for i = 1 : 1 : length(cur_v)
    % set desired current
    cur_str = "LASer:LDI"+' '+ num2str(cur_v(i));
    writeline(serial_6305, cur_str);
    
    pause(2); % stabilize
   
    % read voltage
    writeline(serial_6305,"LASer:LDV?");
    v_ld(i) = str2double(readline(serial_6305));
    pause(1);

    test_meter.updateReading(0.5);
    pow(i) = test_meter.meterPowerReading;


end

out = cat(2, v_ld, pow);
figure(1);
plot(cur_v, v_ld,'o');

figure(2);
plot(cur_v, pow,'o');


% Set current to 0
writeline(serial_6305, "LASer:LDI"+' '+ num2str(0));
% Turn OFF laser
writeline(serial_6305,"LASer:OUTput 0");

% Close serial port;
serial_6305 = [];

% disconnect thorlabs
test_meter.disconnect;   

function set_t(temp)

% set temperature and tunr on TEC

t_str = "TEC:T"+' '+ num2str(temp);
writeline(serial_6305, t_str);

writeline(serial_6305,"TEC:OUTput 1");
pause(10); % thermal inertia
% ask for actual T
writeline(serial_6305,"TEC:T?");
read_T = readline(serial_6305);
disp('Temperature set to '+read_T+' ºC')

end

end
