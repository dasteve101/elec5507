function decoded_data = syndReducedLookupDecode(data_to_decode)
load reducedTable
H = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 1 1 1 1 0 0 0
     0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 1 1 1 1 0 0
     0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 1 1 1 1 0
     0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 1 1 1 1
     0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 1 1 1 1 1 1 1
     0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 0 0 0 0 0 0 1 1 1
     0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 1 1 1 0 1 0 1 1 1 1 0 1 1
     0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 0 1
     0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1 0
     0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1
     0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 0 1 0 1 0 1 0 1 1 1 1 1 0
     0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 0 1 0 1 0 1 0 1 1 1 1 1
     0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 1 1
     0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 0 1 1
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 1 1 1 1 0 0 0 1];
for index = 1:31
    s = [data_to_decode(index:end) data_to_decode(1:(index-1))]*H';
    s = bin2dec(int2str(mod(s,2)));
    if sum(syndromes == s) > 0
        errorInd = find(syndromes == s);
        errorLoc = reducedTable(errorInd,:);
        y = mod([data_to_decode(index:end) ...
            data_to_decode(1:(index-1))] + errorLoc, 2);
        decoded_data = [y((end - index+2):end) y(1:end -index + 1)];
        decoded_data = decoded_data(16:end);
        return
    end
end
error('HELP! cant find!')
