function delta_loss = permutation_importance(net, val, y_val)
    % Assess baseline performances
    preds = classify(net,val);
    [preds, y_val_a] = toarray(preds, y_val);
    [N, ~] = size(y_val_a);
    base_loss = abs(-sum(y_val_a(:).*log(preds(:)))/N);
    
    n_features = 122;
    delta_loss = zeros(1,length(n_features));
    
    % Now one features per time ust be randomly shuffled.
    % Loss is then computed. Grater the loss respect to the baseline,
    % grater the importance of that feature.
    % To increase robustness, procedure is iterated each time per feature.
    for i=1:n_features
%         loss = 0;
%         for iter=1:10
        val_to_shuffle = val;
        for cell=1:length(val)
            shuffle = val_to_shuffle{cell};
            indexes = randperm(length(shuffle(i,:)));
            shuffle(i,:) = shuffle(i, indexes);
            val_to_shuffle{cell} = shuffle;
        end
        preds = classify(net,val_to_shuffle);
        [preds, y_val_a] = toarray(preds, y_val);
        [N, ~] = size(y_val_a);
        actual_loss = abs(-sum(y_val_a(:).*log(preds(:)))/N);
%         loss = loss + actual_loss;
%         end
%         delta_loss(1,i) = loss/10;
        delta_loss(1,i) = actual_loss;
    end
end
