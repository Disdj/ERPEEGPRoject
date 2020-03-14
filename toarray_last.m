function [preds_out, y_test_out] = toarray(preds, y_test)
    % Reconvert output to a single array
    for i=1:length(preds)
        preds_out(i) = grp2idx(preds(i));
        y_test_out(i) = grp2idx(y_test(i));
    end
%     preds = cell2mat(preds);
%     y_test = cell2mat(y_test);
end
