function codeword = polBCHencoder(msg)
genPol = [1 0 0 0 1 1 1 1 1 0 1 0 1 1 1 1];
c = [msg zeros(1,15)];
[~, b] = gfdeconv(fliplr(c), fliplr(genPol));
b = [zeros(1,15 - length(b)) fliplr(b) zeros(1,16)];
codeword = b + [zeros(1,15) msg];
