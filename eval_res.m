function [accuracy, Recall, Precision, F_score] = eval_res(preds, y_test)
    accuracy = sum(preds == y_test)/numel(y_test)*100;
    [confMat,order] = confusionmat(y_test,preds);
    for i=1:size(confMat,1)
        recall(i)=confMat(i,i)/sum(confMat(i,:));
        precision(i)=confMat(i,i)/sum(confMat(:,i));
    end
    recall(isnan(recall))=[];
    Recall=sum(recall)/size(confMat,1);
    Precision=sum(precision)/size(confMat,1);
    F_score=2*Recall*Precision/(Precision+Recall);
%     figure
%     ccLSTM = confusionchart(y_test,preds);
%     ccLSTM.Title = 'Confusion Chart Stim_noStim';
%     ccLSTM.ColumnSummary = 'column-normalized';
%     ccLSTM.RowSummary = 'row-normalized';
end
