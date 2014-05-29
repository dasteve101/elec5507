% Simulate LDPC over AWGN with BPSK
% Hard decision demodulator and soft-decision decoder

close all
clear all

% Import LDPC parity matrix
load ldpc_h
ldpc_h = sparse(ldpc_h);

% Generate EbNo's
ebnos = -3:10;

% LDPC Encoder/Decoder
hEnc = comm.LDPCEncoder(ldpc_h);

% Hard decision by default
hDec = comm.LDPCDecoder(ldpc_h, 'MaximumIterationCount', 5, 'DecisionMethod', 'Soft decision');

hMod = comm.PSKModulator(2);
hDemodHard = comm.PSKDemodulator(2, 'BitOutput',true,...
            'DecisionMethod', 'Approximate log-likelihood ratio');

hError = comm.ErrorRate;
hError_uncoded = comm.ErrorRate;

bers = [];
bers_uncoded = [];
 
% For each eb/no, encode using LDPC, modulate, demodulate,
% decode, then determine error rate. Do the same for uncoded
numErrors = 0;
i = 0;

for e = ebnos
            
    % Create noisy channel using EbNo.
    hChan = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', 'SNR', e);
    
    while i <  10000
        
        % Generate data
        data = logical(randi([0 1], 1152, 1));

        % Encode data
        encodedData = step(hEnc, data);

        % Modulate encoded data
        modData = step(hMod, encodedData);
        % Modulate uncoded data
        modData_uncoded = step(hMod, data);

        % Add AWGN noise according to EbNo.
        noisySignal = step(hChan, modData);
        noisySignal_uncoded = step(hChan, modData_uncoded);                

        % Demod
        receivedSignal = step(hDemodHard, noisySignal);
        receivedSignal_uncoded = step(hDemodHard, noisySignal_uncoded);
        
        receivedSignal_uncoded(receivedSignal_uncoded>0) = 0;
        receivedSignal_uncoded(receivedSignal_uncoded<0) = 1;

        % LDPC decode
        dataDec = step(hDec, receivedSignal);
        
        dataDecThreshold = dataDec;
        dataDecThreshold(dataDecThreshold>0) = 0;
        dataDecThreshold(dataDecThreshold<0) = 1;
       
        % Determine error rate
        errorstats = step(hError, data, logical(dataDecThreshold));
        errorstats_uncoded = step(hError_uncoded, data, logical(receivedSignal_uncoded));
        
        i = i + 1
       
    end
    
    bers  = [bers errorstats(1) ];
    bers_uncoded = [bers_uncoded errorstats_uncoded(1)];
    
    i = 0;
    % Reset error stats
    reset(hError);
    reset(hError_uncoded);
    
end

bers(bers < 10e-10) = 10e-15;
bers_uncoded(bers_uncoded < 10e-10) = 10e-15;

figure
semilogy(ebnos, bers);
hold on
semilogy(ebnos, bers_uncoded, 'r');
legend('Coded', 'Uncoded');
ylim([10^-7 10^-1])
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
title('BER vs EB/No for LDPC Soft-decision (BPSK)')
%fprintf('Error rate       = %1.2f\nNumber of errors = %d\n', ...
%      errorstats(1), errorstats(2))
    
    

    