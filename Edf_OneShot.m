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

%% Labels predictors separation
target = regularize(data_eeg(127,:));
data_eeg = data_eeg(1:126,:);

%% ONE SHOT
baseline = [1281, 1380, 1369, 4607];
target(ismember(target,baseline))=0;
target(target==1290) = 1;
target(target==1295) = 2;
target(target==1300) = 3;
target(target==1305) = 4;
target(target==1310) = 5;
target(target==1315) = 6;
target(target==1320) = 7;
target(target==1325) = 8;
target(target==1330) = 9;
target(target==1335) = 10;
target(target==1340) = 11;
target(target==1345) = 12;
target(target==1350) = 13;
target(target==1357) = 14;
target(target==1360) = 15;
target(target==1365) = 16;
target(target==1368) = 17;
target = categorical(target);

%% Data Preparation
disp("Train test split...")
[eeg_tosplit, target_tosplit] = data_preparation(data_eeg, target);

%% Train-Test Split
[train, y_train, val, y_val, test, y_test] = traintestsplit_oneshot(eeg_tosplit,...
                                                           target_tosplit);
%% Training
net = LSTMtrain_oneshot(train,y_train,val,y_val);
 
%% Accuracy on test
preds = classify(net,test);
[preds, y_test] = toarray(preds, y_test);

% Results
res_plot(preds, y_test, "OneShot")
StimnoStim_Acc = eval_res(preds, y_test);
