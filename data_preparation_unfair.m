function [eeg_tosplit, target_tosplit] = data_preparation_unfair(data_eeg, labels)
    len = 820;
    step = 410;
    vect = [1:step:length(labels)-len];
    eeg_tosplit = cell(length(vect), 1);
    target_tosplit = cell(length(vect), 1);
    for i=1:length(vect)
        eeg_tosplit{i} = data_eeg(:, 1:1+len);
        data_eeg(:, 1:step) = [];
        target_tosplit{i} = labels(1:1+len);
        labels(1:step) = [];
    end
end