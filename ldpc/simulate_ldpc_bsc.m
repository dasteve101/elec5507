% Simulate LDPC over BSC
% Part II, Question 3a)
% Author: Vanush Vaswani

close all
clear all

% Import LDPC parity matrix
load ldpc_h
ldpc_h = sparse(ldpc_h);

% Generate transition probabilities
ps = [0.0000000001 0.0000001 0.000001 0.00001 0.001:0.01:0.5];

% Generate data
data = logical(randi([0 1], 1152, 1));

% LDPC Encoder/Decoder
hEnc = comm.LDPCEncoder(ldpc_h);
hDec = comm.LDPCDecoder(ldpc_h, 'MaximumIterationCount', 5);

% Go through perfect BPSK mod/demod (no noise) - this is because the LDPC Decoder
% requires log-likelihood ratios
hMod = comm.PSKModulator(2, 'BitInput',true);
hDemod = comm.PSKDemodulator(2, 'BitOutput',true, ...
            'DecisionMethod','Approximate log-likelihood ratio');
hError = comm.ErrorRate;

% Generate arrays of BER
bers = [];
i = 0;

disp ('Running simulation ...')
for p = ps
    
    hError = comm.ErrorRate;
    
    % Encode data
    data_enc = step(hEnc, data);
    
    % BSC channel
    data_enc_bsc = bsc(double(data_enc), p);
    data_bsc = bsc(double(data), p);  
    
    % Mod/demod
    data_enc_bsc_mod = step(hMod, data_enc_bsc);
    data_enc_bsc_demod = step(hDemod, data_enc_bsc_mod);
    
    % Decode
    data_dec = step(hDec, data_enc_bsc_demod);
    
    % Get BER
    errorstats = step(hError, data, data_dec);

    bers = [bers errorstats(1)];
end

disp('Plotting BER vs p ...')
plot_ber(ps, bers);
disp ('Plotting BER vs EBNo ...')
plot_ebno(ps, bers, ps, 1);


