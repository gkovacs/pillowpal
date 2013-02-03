function createWaveFile(array,output,fs=8000)
    wavwrite(array,fs,output); 
    sound(array); 
end 