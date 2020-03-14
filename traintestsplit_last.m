function [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
                                                           target_tosplit)
    for i=1:length(target_tosplit)-1
        label(i) = (grp2idx(target_tosplit(i)));
    end
    a = find(label==1);
    a = a(randperm(numel(a)));
    b = find(label==2);
    b = b(randperm(numel(b)));
    
    a_tr = floor(0.75*length(a));
    b_tr = floor(0.75*length(b));
    i_tr = min(a_tr, b_tr);
    train_indexes = a(1:i_tr);
    train_indexes = [train_indexes; b(1:i_tr)];
    train_indexes = train_indexes(randperm(numel(train_indexes)));
    
    a_v = a_tr + floor(0.1*length(a));
    b_v = b_tr + floor(0.1*length(b));
    i_v = min(a_v, b_v);
    val_indexes = a(i_tr:i_v);
    val_indexes = [val_indexes; b(i_tr:i_v)];
    val_indexes = val_indexes(randperm(numel(val_indexes)));
    
    test_indexes = a(i_v:length(a));
    test_indexes = [test_indexes, b(i_v:length(b))];
    test_indexes = test_indexes(randperm(numel(test_indexes)));
    
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