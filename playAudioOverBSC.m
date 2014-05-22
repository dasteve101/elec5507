function playAudioOverBSC(pVal)

[data, Fs] = wavread('austinpowers.wav', 'native');
data = de2bi(data);
data = reshape([data; zeros(1,8)],[],16);
decoded_data = data;
for k = 1:length(data);
    codeword = encoder(double(data(k,:)));
    errors = rand(1,31) < pVal;
    decoded_data(k,:) = berlekamp_decode(mod(codeword + errors,2));
end
decoded_data = reshape(decoded_data,[], 8);
decoded_data = bi2de(decoded_data(1:end-1,:)); % remove the last row of zeros again
soundsc(double(decoded_data),Fs);