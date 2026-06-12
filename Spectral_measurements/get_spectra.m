function out = get_spectra(na)

% get spectra with andor spectrometer.
% input: na average over na spectra.
% output: out is a 1x1024 vector. 
% er (below) is the standar deviation over na spectra. 

if libisloaded('andor')    
spc = zeros(na,1024);
ii = 1;

while ii <= na
err = calllib('andor','StartAcquisition');% Start the acquisition 
%  fprintf('return from Start Acquisition %d\n',err)
if err~=20002
    
    calllib('andor','ShutDown')
    
    return
end
 

err = calllib('andor','WaitForAcquisition');

[err,spc(ii,:)] = calllib('andor','GetAcquiredData',spc(ii,:),1024);
% spc(ii,:)=spc(ii,:)-min(spc(ii,:));
ii = ii+1;
end

if  mod(na, ii) == 0
fprintf('return from Start Acquisition %d\n',err)
end
    if na>1
    out = mean(spc); % average of each point of spectra
%     out = sum(spc,1); %cumulative sum of acq. spectra
    out = out';
    er = std(spc); % std dev for each point of acq. spectra
    else
    out = spc;
    out = out';
    er = 0;
    end

else
    fprintf('ERROR: andor spectrometer not inizialized.\n')
    fprintf('try run init_andor.m\n')
    get_spectra(na);
    
end 
