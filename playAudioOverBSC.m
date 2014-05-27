function playAudioOverBSC(pVal)
[data, Fs] = wavread('austinpowers.wav', 'native');
data = de2bi(data);
% add a row of zeros as it is not divisible by 16
data = double(reshape([data; zeros(1,8)],[],16));
errors = rand(length(data),31) < pVal;


encoded_data_no_error = encoder(data);
encoded_data = mod(encoder(data) + errors,2);

% Check whether error rate is correct :P
errors = encoded_data_no_error == encoded_data;
error_rate = length(find(errors == 0))/numel(errors)

decoded_data = reshape(matlabBCHdecode(encoded_data),[], 8);
% remove the last row of zeros again
decoded_data = bi2de(decoded_data(1:end-1,:)); 
soundsc(double(decoded_data),Fs);
figure
plot(double(decoded_data));
plot_title = sprintf('Audio over BSC channel with BCH decoding (p = %.2f)', pVal);
xlabel('Audio Sample number')
ylabel('Normalized audio magnitude')
title(plot_title)
                 