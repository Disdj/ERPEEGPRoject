function [eeg_tosplit, target_tosplit] = data_preparation(data_eeg, labels, target)
    idx_change = find(logical(diff(target)));
    idx_change = [idx_change, length(target)];
    idx_change = [0, idx_change];
    len = 64;
    c = find(diff(idx_change)>len);
    for i=c
        count = 1;
        while(idx_change(i)+count*len<idx_change(i+1))
            idx_change = [idx_change, idx_change(i)+count*len];
            count = count + 1;
        end
    end
    idx_change = sort(idx_change);
    idx_change(logical(diff(idx_change)<len)) = [];

    for i=1:length(idx_change)-1
        eeg_tosplit{i} = data_eeg(:, idx_change(i)+1:idx_change(i+1));
        target_tosplit(i) = labels(idx_change(i)+1);
    end
    eeg_tosplit = eeg_tosplit';
    target_tosplit = target_tosplit';
end