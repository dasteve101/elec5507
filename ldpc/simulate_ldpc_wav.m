% Simulate LDPC encoding of audio
% Author: Vanush Vaswani

% Import LDPC parity matrix
load ldpc_h
ldpc_h = sparse(ldpc_h);

bsc_p = 0.1;

% Get wav data
data = wav_to_binary('austinpowers.wav');
data_t = data';

% Convert data to column vector
data_col = data_t(:);

k = 1152;

num_cols = floor(numel(data_col)/k);

% Clip data to an integer number of messages (K = 1152)
data_col = data_col(1:k*num_cols);

% Messages to columns
data_col = logical(vec2mat(data_col, num_cols));
[nrow, ncol] = size(data_col);

% LDPC Encoder/Decoder
hEnc = comm.LDPCEncoder(ldpc_h);
hDec = comm.LDPCDecoder(ldpc_h,'MaximumIterationCount', 20);

% Go through perfect BPSK mod/demod - this is because the LDPC Decoder
% requires log-likelihood ratios
hMod = comm.PSKModulator(2, 'BitInput',true); % Don't we want (2 ... for a BPSK?
hDemod = comm.PSKDemodulator(2, 'BitOutput',true, ...
            'DecisionMethod','Approximate log-likelihood ratio');
hError = comm.ErrorRate;


received_matrix = zeros(k, num_cols);

disp ('Running simulation ... ')
% For each message (frame of raw audio), generate code word. Then mod/demod, then decode
for i = 1:ncol
    disp(i);
    % Encode
    data_encoded = step(hEnc, data_col(:,i));
    
    % Go through BSC (add bit errors)
    data_encoded_bsc = bsc(double(data_encoded), bsc_p);
    
    errors = data_encoded == data_encoded_bsc;
    error_rate = length(find(errors == 0))/numel(errors)
    
    %data_encoded_bsc = data_encoded;
    
    % Modulate
    data_encoded_bsc_mod = step(hMod, logical(data_encoded_bsc));
    % Demodulate
    data_encoded_bsc_demod = step(hDemod, data_encoded_bsc_mod);
    
    % Decode
    received_bits = step(hDec, data_encoded_bsc_demod);
    
    % Store in rx matrix
    received_matrix(:,i) = received_bits;
    errorStats  = step(hError, data_col(:,i), received_bits);
end

fprintf('Error rate       = %1.2f\nNumber of errors = %d\n', ...
      errorStats(1), errorStats(2))
rxdata = received_matrix';
rxdata = rxdata(:);
rxdata = vec2mat(rxdata, 8);
rxwav = binary_to_wav(rxdata);

fprintf('Plotting corrected audio with BSC p = %d\n', bsc_p)
plot(rxwav)
plot_title = sprintf('Audio over BSC channel with LDPC decoding (p = %.2f)', bsc_p);
xlabel('Audio sample number')
ylabel('Normalized audio magnitude')
title(plot_title)
sound(rxwav, 11025);

    
   
