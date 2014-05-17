function binarywav = binary_to_wav(data)
    d = char(data+48);
    d1 = bin2dec(d);
    binarywav = d1./255;
    binarywav = binarywav - 0.5;
end
    