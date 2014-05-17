% Simulate LDPC over BSC
% Author: Vanush Vaswani

% Import LDPC parity matrix
load ldpc_h
ldpc_h = sparse(ldpc_h);

% Generate transition probabilities
ps = 0:0.0001:0.5;

% Generate data
data = logical(randi([0 1], 1152, 1));

% LDPC Encoder/Decoder
hEnc = comm.LDPCEncoder(ldpc_h);
hDec = comm.LDPCDecoder(ldpc_h);

% Go through perfect BPSK mod/demod - this is because the LDPC Decoder
% requires log-likelihood ratios
hMod = comm.PSKModulator(4, 'BitInput',true); % Don't we want (2 ... for a BPSK?
hDemod = comm.PSKDemodulator(4, 'BitOutput',true, ...
            'DecisionMethod','Approximate log-likelihood ratio');
hError = comm.ErrorRate;

% Generate arrays of BER
bers = []

i = 0;

for p = ps
    p
    
    % Encode data
    data_enc = step(hEnc, data);
    
    % BSC channel
    data_enc_bsc = bsc(double(data_enc), p);
    
    % Mod/demod
    data_enc_bsc_mod = step(hMod, data_enc_bsc);
    data_enc_bsc_demod = step(hDemod, data_enc_bsc_mod);
    
    % Decode
    data_dec = step(hDec, data_enc_bsc_demod);
    
    % Get BER
    errorstats = step(hError, data, data_dec);
    bers = [bers errorstats(1)];
end

plot_ber(ps, bers);
plot_ebno(ps, bers, 0.5);


