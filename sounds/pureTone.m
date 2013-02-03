function pureTone ( frequency, duration, amplitude, sampleFreq, save2file )
% Generate pure tones.
% Enter at least 1 argument.
% Defaults are:
%  duration    1 sec
%  amplitude   1 
%  sampleFreq  48000 Hz
%  save2file   no
%--------------------
% If you want to save the tone to a file, provide a name.    

switch nargin  
case 0
    error('Enter a frequency.')
case 1
    duration   = 1;
    amplitude  = 1;
    sampleFreq = 48000;
    save2file  = 0;
case 2
    amplitude  = 1;
    sampleFreq = 48000;
    save2file  = 0;
case 3
    sampleFreq = 48000;
    save2file  = 0;
case 4
    save2file  = 0;
end


t = linspace( 0, duration, duration * sampleFreq );
% http://de.wikipedia.org/wiki/Sinuston
s = amplitude * sin( 2 * pi * frequency * t );

sound( s, sampleFreq );

if save2file
    wavwrite( s, sampleFreq, 32, save2file);
end

end