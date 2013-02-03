function makeTone(Fs,toneFreq,nSeconds,outFile)
    nSeconds = nSeconds/8; 
    y = sin(linspace(0, nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));
    y = (y+1); 
    y = y*500/2; 
    final = repmat([y zeros(1,4000)],1,4); 
    % sound(final,Fs); 
    min(final)
    max(final)
    length(final)
    wavwrite(final, Fs, 8, outFile);
end 
