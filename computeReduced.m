load trt
reducedTable = [];
for i = 1:length(trt)
    added = 0;
    [x, ~] = size(reducedTable);
    for r = 1:x
        tmpWord = reducedTable(r,1:31);
        for index = 1:31
            if sum(mod([tmpWord(index:end) tmpWord(1:(index - 1))] ...
                    + trt(i,:),2)) == 0
                added = 1;
                break
            end
            if added == 1
                break
            end
        end
        if added == 1
            break
        end
    end
    if added == 0
        reducedTable = [reducedTable; trt(i,:)];
    end
end