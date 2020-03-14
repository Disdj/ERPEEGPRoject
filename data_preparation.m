function [eeg_tosplit, target_tosplit] = data_preparation(data_eeg, labels)
    len = 64;
    idx_change = 1:len:length(labels);
    idx_change(logical(diff(idx_change)<len)) = [];

    for i=1:length(idx_change)-1
        signal = data_eeg(:, idx_change(i)+1:idx_change(i+1));
        eeg_tosplit{i} = signal;
        target_tosplit{i} = labels(idx_change(i)+1:idx_change(i+1));
    end

    eeg_tosplit = eeg_tosplit';
    target_tosplit = target_tosplit';
end