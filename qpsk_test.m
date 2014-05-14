    hEnc = comm.LDPCEncoder;
    hMod = comm.PSKModulator(4, 'BitInput',true);
    hChan = comm.AWGNChannel(...
            'NoiseMethod','Signal to noise ratio (SNR)','SNR',1);
    hDemod = comm.PSKDemodulator(4, 'BitOutput',true,...
            'DecisionMethod','Approximate log-likelihood ratio', ...
            'Variance', 1/10^(hChan.SNR/10));
    hDec = comm.LDPCDecoder;
    hError = comm.ErrorRate;
    for counter = 1:1
      disp(counter);
      data           = logical(randi([0 1], 32400, 1));
      encodedData    = step(hEnc, data);
      encodedData    = bsc(double(encodedData), 0.1);
      modSignal      = step(hMod, encodedData);
      receivedSignal = modSignal;
      %receivedSignal = step(hChan, modSignal);
      demodSignal    = step(hDemod, receivedSignal);
      receivedBits   = step(hDec, demodSignal);
      errorStats     = step(hError, data, receivedBits);
    end
    fprintf('Error rate       = %1.2f\nNumber of errors = %d\n', ...
      errorStats(1), errorStats(2))