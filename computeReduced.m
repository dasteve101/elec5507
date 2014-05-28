load trt
% go through all errors
allCycles = trt;
uniqueTable = [];
for i = 1:31
    tmp = [trt(:,i:end) trt(:,1:(i-1))];
    allCycles(:,:,i) = tmp;
    uniqueTable = unique([uniqueTable; allCycles(:,:,i)], 'rows');
end
redTable = [];
for index = 1:31
    [~, intA, intB] = intersect(allCycles(:,:,index), uniqueTable, 'rows');
    [~, I] = sort(intA);
    redTable = [redTable intB(I)];
end
uniqueIndexs = ones(length(uniqueTable),1);
for r = redTable'
    if sum(uniqueIndexs(r)) == 31
        uniqueIndexs(r(2:end)) = zeros(30,1);
    elseif sum(uniqueIndexs(r)) ~= 1
        error('huh?')
    end
end
uniqueIndexs(1) = 1; % all zero gets deleted
reducedTable = uniqueTable(find(uniqueIndexs),:);
[~, iA, iB] = intersect(reducedTable, trt, 'rows');
[~, I] = sort(iA);
syndromes = iB(I) - 1;
save('reducedTable.mat','syndromes', 'reducedTable');