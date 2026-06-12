function out = acq_spe(cur_v)

% ACQ_SPE Acquire emission spectra as a function of injection current.
%
% This function controls an Arroyo 6305 laser diode controller and an
% Andor spectrometer to automatically record spectra for a user-defined
% current sweep.
%
% Input
%   cur_v : Vector of injection currents (mA).
%
% Output
%   out : Matrix of size (1024 x N), where each column contains the
%         spectrum acquired at the corresponding current value.
%
% Requirements
%   - The Andor camera must be initialized previously using init_andor().
%   - The Arroyo controller must be connected to COM4.
%
% Notes
%   - Five spectra are averaged at each current point through
%     get_spectra(5).
%   - The laser is automatically switched off at the end of the scan.


close all;

% Connect to Arroyo 6305 laser controller
global serial_6305;
serial_6305 = serialport("COM4",9600,"Timeout",6);
serial_6305.BaudRate = 38400;

% set t = 20ºC and turn on TEC
% set_t(20);

% set current resolution
writeline(serial_6305,"LASer:LDIRES 0.1"); % resolution in mA
% turn on laser
writeline(serial_6305,"LASer:OUTput 1");
pause(2); % takes time to turn on

% for cycle
specs = zeros(1024, length(cur_v));

for i = 1 : 1 : length(cur_v)
    % set desired current
    cur_str = "LASer:LDI"+' '+ num2str(cur_v(i));
    writeline(serial_6305, cur_str);
    
    pause(1); % stabilize
   
    specs(:,i) = get_spectra(5);
    pause(1);
end

out = specs;


% set cur = 0 ;
writeline(serial_6305, "LASer:LDI"+' '+ num2str(0));
% turn off laser
writeline(serial_6305,"LASer:OUTput 0");

% close serial port;
serial_6305 = [];



function set_t(temp)

% set temperature and turn on TEC

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
