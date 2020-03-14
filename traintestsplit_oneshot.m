function [train, y_train, val, y_val, test, y_test] = traintestsplit_oneshot(eeg_tosplit,...
                                                           target_tosplit)
    for i=1:length(target_tosplit)-1
        label(i) = max(grp2idx(target_tosplit{i,1}));
    end
    a =(randperm(length(label)));

    i_tr = floor(0.75*length(a));
    train_indexes = a(1:i_tr);
    i_v = i_tr + floor(0.1*length(a));
    val_indexes = a(i_tr:i_v); 
    test_indexes = a(i_v:length(a));
    
    train = eeg_tosplit(train_indexes);
    y_train = target_tosplit(train_indexes);
    val = eeg_tosplit(val_indexes);
    y_val = target_tosplit(val_indexes);
    test = eeg_tosplit(test_indexes);
    y_test = target_tosplit(test_indexes);
    
    numObservations = numel(train);
    for i=1:numObservations
        sequence = train{i};
        sequenceLengths(i) = size(sequence,2);
    end
    
    [sequenceLengths,idx] = sort(sequenceLengths);
    train = train(idx);
    y_train = y_train(idx);
    
    disp(min(sequenceLengths))
    disp(max(sequenceLengths))
    figure
    bar(sequenceLengths)
    ylim([0 70])
    xlabel("Sequence")
    ylabel("Length")
    title("Sorted Data")
end