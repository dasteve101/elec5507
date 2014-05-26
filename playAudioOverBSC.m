function playAudioOverBSC(pVal)
[data, Fs] = wavread('austinpowers.wav', 'native');
data = de2bi(data);
% add a row of zeros as it is not divisible by 16
data = double(reshape([data; zeros(1,8)],[],16));
errors = rand(length(data),31) < pVal;
encoded_data = mod(encoder(data) + errors,2);
decoded_data = reshape(matlabBCHdecode(encoded_data),[], 8);
% remove the last row of zeros again
decoded_data = bi2de(decoded_data(1:end-1,:)); 
soundsc(double(decoded_data),Fs);
