function [accuracy] = eval_res(preds, y_test)
    accuracy = sum(preds == y_test)/numel(y_test)*100;

    figure
    ccLSTM = confusionchart(y_test,preds);
    ccLSTM.Title = 'Confusion Chart Stim_noStim';
    ccLSTM.ColumnSummary = 'column-normalized';
    ccLSTM.RowSummary = 'row-normalized';
end
