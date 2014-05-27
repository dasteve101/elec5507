load ldpc_h
ldpc_h = sparse(ldpc_h);
ebno = 0
   for e = ebno
        hEnc = comm.LDPCEncoder(ldpc_h);
        hMod = comm.PSKModulator(2, 'BitInput',true);
        hChan = comm.AWGNChannel(...
                'NoiseMethod', 'Signal to noise ratio (Eb/No)','EbNo',e);
        hDemod = comm.PSKDemodulator(2, 'BitOutput',true,...
                'DecisionMethod','Approximate log-likelihood ratio', ...
                'Variance', 1/10^(hChan.SNR/10));
        hDec = comm.LDPCDecoder(ldpc_h);
        hError = comm.ErrorRate;
        for counter = 1:10
            counter
          data           = logical(randi([0 1], 1152, 1));
          encodedData    = step(hEnc, data);
          modSignal      = step(hMod, encodedData);
          receivedSignal = step(hChan, modSignal);
          demodSignal    = step(hDemod, receivedSignal);
          receivedBits   = step(hDec, demodSignal);
          data == receivedBits
          errorStats     = step(hError, data, receivedBits);
        end
        fprintf('Error rate       = %1.8f\nNumber of errors = %d\n', ...
          errorStats(1), errorStats(2))
   end