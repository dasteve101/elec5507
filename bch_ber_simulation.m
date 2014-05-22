% simulations section 1) part 8)
% Find the BER over a BCH code
pValues = 0.001:0.001:0.5;
snrValues = 0.001:0.001:10;
repetitions = 100;

msg = rand(length(pValues)*repetitions, 16) > 0.5;
errors = rand(length(msg), 31) < repmat(reshape(repmat(pValues,repetitions,1),1,[])',1,31);
bch_encoded = encoder(msg);

bch_decoded = matlabBCHdecode(mod(bch_encoded + errors, 2));
bitErrs = reshape((sum(mod(bch_decoded' + msg',2))/16)', repetitions, []);
BER = sum(bitErrs)/length(bitErrs); % take the average

figure()
plot(pValues, BER);
title('Plot of BER in BCH codes in a BSC');
xlabel('P values');
ylabel('BER');

% Q(x) = 0.5 * ( 1 - erf(x/sqrt(2)))
% Q^(-1)(x) = sqrt(2)*erfinv(1 - 2x)

Xuncoded = 20*log10(1./(sqrt(2)*erfinv(1 - 2.*pValues)));
Xcoded = Xuncoded - 10*log10(16/31); % R = code Rate = k/n

figure()
plot(Xuncoded, BER, Xcoded, BER, '-r');
title('Plot of BER in BCH codes in a BSC');
legend('Uncoded', 'Coded');
xlabel('SNR');
ylabel('BER');

% section 1) q 8)b)

% TODO: check conversion to snr, put in dB? sqrt(1./snrValues)?
msg = rand(length(snrValues)*repetitions, 16) > 0.5;
bch_encoded = encoder(msg);
noise = randn(length(bch_encoded), 31).*repmat(reshape(repmat(sqrt(1./snrValues),repetitions,1),1,[])',1,31); 
signal = 1 - 2*bch_encoded;
bch_decoded = matlabBCHdecode((signal + noise) < 0); % Hard decision on 0
bitErrs = reshape((sum(mod(bch_decoded' + msg',2))/16)', repetitions, []);
BER = sum(bitErrs)/length(bitErrs); % take the average

figure()
plot(snrValues, BER);
title('Plot of BER in BCH codes in an AWGN BPSK');
xlabel('SNR');
ylabel('BER');

