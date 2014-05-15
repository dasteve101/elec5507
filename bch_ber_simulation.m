% simulations section 1) part 8)
% Find the BER over a BCH code
pValues = 0:0.001:10;
repetitions = 100;
messageLength = 1000;

BER = [];

for p = pValues
    averageBerrs = 0;
    for r = 1:repetitions
        msg = (rand(1, messageLength) > 0.5);
        bch_encoded = 0; % TODO: BCH encode
        errors = (rand(1,length(bch_encoded)) < p);
        bch_decode = decodeMsg(mod(bch_encoded + errors, 2)); % TODO: BCH decode
        bitErrs = sum(bch_decode + msg)/length(msg);
        averageBerrs = averageBerrs + bitErrs;
    end
    BER = [BER (averageBerrs/repetitions)];
end

figure()
plot(pValues, BER);

% Q(x) = 0.5 * ( 1 - erf(x/sqrt(2)))

Xuncoded = 20*log10(1/(0.5 * ( 1 - erf(pValues/sqrt(2)))));
Xcoded = Xuncoded - 10*log10(R); % R = code Rate = k/n

figure()
plot(Xuncoded, BER);
hold;
plot(Xcoded, BER, '-r');


