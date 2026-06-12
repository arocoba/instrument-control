function out = get_spectra(na)

% GET_SPECTRA Acquire spectra from an Andor spectrometer.
%
% Input
%   na : Number of acquisitions to average.
%
% Output
%   out : Column vector (1024 x 1) containing the acquired spectrum.
%         If na > 1, out corresponds to the average spectrum.
%
% Notes
%   - The Andor camera must be initialized previously using init_andor().
%   - The detector is assumed to be configured in Full Vertical Binning (FVB) mode.
%   - The detector size is assumed to be 1024 pixels.
%   - For na > 1, multiple spectra are acquired and averaged to improve
%     the signal-to-noise ratio.

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
    % er is the pixel-by-pixel standard deviation of the acquired spectra.
    % Currently not returned by the function.
    er = std(spc); 
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
