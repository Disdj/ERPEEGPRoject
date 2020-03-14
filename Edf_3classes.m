%% Initialization
clear all
close all
clc

%% Data ingestion
[hdr, data_eeg] = edfread("09_vm.edf");
% plot_data(data_eeg)

%% Pre-processing
data_processed = pre_process(data_eeg);
%plot_data(data_eeg)

%% Normalization
disp('Data normalization...')
for i=1:length(data_eeg(:,1))-1
    data_eeg(i,:) = (data_eeg(i,:)-mean(data_eeg(i,:)))/...
        (std(data_eeg(i,:)));
end

%% Labels predictors separation
target = regularize(data_eeg(127,:));
data_eeg = data_eeg(1:126,:);

%% 3 CLASSES ONE SHOT
baseline = [1281, 1380, 1369, 4607];
picture = [1290,1295,1300,1305,1310,1315,1320,1325,1330,1335];
audio = [1340,1345,1350,1357];
video = [1360,1365,1368];
target(ismember(target,baseline))=0;
target(ismember(target,picture))=1;
target(ismember(target,audio))=2;
target(ismember(target,video))=3;

% Data Preparation
disp("Train test split...")
[eeg_tosplit, target_tosplit] = data_preparation(data_eeg, labels);

% Train-Test Split
[train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
                                                           target_tosplit);
% Training
net = LSTMtrain(train,y_train,val,y_val,64);
 
% Accuracy on test
preds = classify(net,test);
[preds, y_test] = toarray(preds, y_test);

% Results
res_plot(preds, y_test, "3Classes")
StimnoStim_Acc = eval_res(preds, y_test);
