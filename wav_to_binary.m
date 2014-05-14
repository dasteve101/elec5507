function wavbinary = wav_to_binary(filename)
    [x, Fs] = wavread(filename, 'native');
    x1 = x - min(x);
    s = dec2bin(x);
    wavbinary = double(s) - 48;
end
    
    