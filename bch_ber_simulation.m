% simulations section 1) part 8)
% Find the BER over a BCH code
pValues = [0.005 0.002 0.001];
repetitions = 10000000;

msg = rand(length(pValues)*repetitions, 16) > 0.5;
errors = rand(length(msg), 31) < ...
        repmat(reshape(repmat(pValues,repetitions,1),1,[])',1,31);
bch_encoded = encoder(msg);

bch_decoded = matlabBCHdecode(mod(bch_encoded + errors, 2));
bitErrs = reshape((sum(mod(bch_decoded' + msg',2))/16)', repetitions, []);
BER = sum(bitErrs)/length(bitErrs); % take the average
errors = rand(length(msg), 16) < ...
        repmat(reshape(repmat(pValues,repetitions,1),1,[])',1,16);
bitErrs = reshape((sum(mod(errors',2))./16)', repetitions, []);
BERUncoded = sum(bitErrs)/length(bitErrs);

figure()
semilogy(fliplr(pValues), fliplr([BERUncoded; BER]));
title('Plot of BER in BCH codes in a BSC');
legend('Uncoded', 'Coded');
ylim([10^-6 10^0]);
xlabel('P values');
ylabel('BER');

% Q(x) = 0.5 * ( 1 - erf(x/sqrt(2)))
% Q^(-1)(x) = sqrt(2)*erfinv(1 - 2x)

Xuncoded = 20.*log10(sqrt(2).*erfinv(1 - 2.*pValues));
Xcoded = Xuncoded - 10.*log10(16/31); % R = code Rate = k/n

figure()
semilogy(Xuncoded, BERUncoded, Xcoded, BER, '-g');
title('Plot of BER in BCH codes in a BSC');
legend('Uncoded', 'Coded');
ylim([10^-6 10^0]);
xlabel('SNR');
ylabel('BER');

clear all; % otherwise run out of memory
% section 1) q 8)b)

snrValues = 0:0.01:8;
repetitions = 5000;

% SNR = 10*log10((1/ampl)^2), ampl = 10^(-SNR/20)
msg = rand(length(snrValues)*repetitions, 16) > 0.5;
bch_encoded = encoder(msg);
noise = randn(length(bch_encoded), 31).* ...
      repmat(reshape(repmat(10.^(-snrValues./20),repetitions,1) ...
             ,1,[])',1,31); 
signal = 1 - 2.*bch_encoded;
bch_decoded = matlabBCHdecode((signal + noise) < 0); % Hard decision on 0
bitErrs = reshape((sum(mod(bch_decoded' + msg',2))./16)', repetitions, []);
BER = sum(bitErrs)/length(bitErrs); % take the average

noise = randn(length(msg), 16).* ...
      repmat(reshape(repmat(10.^(-snrValues./20),repetitions,1) ...
             ,1,[])',1,16); 
signal = 1 - 2.*msg;
decoded = (signal + noise) < 0;
bitErrs = reshape((sum(mod(decoded' + msg',2))./16)', repetitions, []);
BER2 = sum(bitErrs)/length(bitErrs); % take the average

figure()
semilogy(snrValues, [BER2; BER]);
title('Plot of BER in BCH codes in an AWGN BPSK');
legend('Uncoded', 'Coded');
ylim([10^-6 10^0]);
xlabel('SNR');
ylabel('BER');

