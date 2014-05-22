function codeword = polBCHencoder(msg)
genPol = [1 0 0 0 1 1 1 1 1 0 1 0 1 1 1 1];
d = [msg zeros(1,15)];
[~, r] = gfdeconv(fliplr(d), fliplr(genPol));
r = [zeros(1,15 - length(r)) fliplr(r) zeros(1,16)];
codeword = r + [zeros(1,15) msg];
