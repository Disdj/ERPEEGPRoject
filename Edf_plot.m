%% Initialization
clear all
close all
clc

%% Data ingestion
[hdr, data_eeg1] = edfread("21_mf.edf");
[hdr, data_eeg2] = edfread("21_mf_2.edf");
% [hdr, data_eeg3] = edfread("19_ab_3.edf");
data_eeg = [data_eeg1 data_eeg2];
plot_data(data_eeg)

%% Sequence removal
data_eeg(:,590400:688400) = [];
% plot_data(data_eeg)

%% Pre-processing
data_eeg = pre_process(data_eeg);
% plot_data(data_eeg)

%% Labels predictors separation
target = regularize(data_eeg(127,:));
data_eeg = data_eeg(1:122,:);

%% STIMULUS vs NO STIMULUS
no_stim = [1281, 1380, 1369, 4607];
labels = label_binarizer(target, no_stim);
% check_plot(data_eeg, labels, "StimNoStim");

% Data Preparation
disp("Train test split...")
[eeg_tosplit, target_tosplit] = data_preparation(data_eeg, labels);

% Train-Test Split
[train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
                                                           target_tosplit);
% Training
net = LSTMtrain(train,y_train,val,y_val,[0.5, 0.5]);
 
% Accuracy on test
preds = classify(net,test);
[preds, y_test] = toarray(preds, y_test);

% Results
res_plot(preds, y_test, "Stim_noStim")
[StimnoStim_Acc, StimnoStim_Rec, StimnoStim_Pre, StimnoStim_F1] = eval_res(preds, y_test);

% Features importance 
% Assessed randomly shuffling a channel in the validation set and 
% estimating the augment in the loss. The network has not to be retrained.
stim_losses = permutation_importance(net, val, y_val);

% Remove no stimuli
[data_eeg, target, data_o, target_o] = split_data(data_eeg, target, no_stim);
%% PICTURE vs NOT PICTURE
no_pic = [1290,1295,1300,1305,1310,1315,1320,1325,1330,1335];
labels = label_binarizer(target, no_pic);
% check_plot(data_eeg, labels, "PicNoPic");

% Data Preparation
disp("Train test split...")
[eeg_tosplit, target_tosplit] = data_preparation(data_eeg, labels);

% Train-Test Split
[train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
                                                           target_tosplit);
% Training
net = LSTMtrain(train,y_train,val,y_val,[0.5, 0.5]);

% Accuracy on test
preds = classify(net,test);
[preds, y_test] = toarray(preds, y_test);

% Results
res_plot(preds, y_test, "PictnoPict")
[PicnoPic_Acc, PicnoPic_Rec, PicnoPic_Pre, PicnoPic_F1] = eval_res(preds, y_test);

% Features importance 
pict_losses = permutation_importance(net, val, y_val);

% Remove no stimuli
[vid_aud_eeg, target_vid_aud, picture_eeg, target_picture] = split_data(data_eeg,...
                                        target, no_pic);
%% PICTURE: Target vs Trigger
% pic_target = 1335;
% labels = label_binarizer(target_picture, pic_target);
% % % check_plot(picture_eeg, labels, "TrigNoTrigPict");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(picture_eeg, labels);

% % Train-Test Split
% [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
%                                                            target_tosplit);
% % Training
% net = LSTMtrain(train,y_train,val,y_val,[2.55 0.05]);
% 
% % Accuracy on test
% preds = classify(net,test);
% [preds, y_test] = toarray(preds, y_test);
% 
% % Results
% res_plot(preds, y_test, "Pict_TargetvcsTrigger")
% Pict_TarTrig_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [picture_eeg, target_picture, data_o, target_o] = split_data(picture_eeg,...
%                                         target_picture, pic_target);
%                                     
% %% PICTURE: Living vs Not Living to train
% living = [1290, 1295, 1300, 1305];
% labels = label_binarizer(target_picture, living);
% % % check_plot(picture_eeg, labels, "LivNoLiv");

% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(picture_eeg, labels);
% 
% % Train-Test Split
% [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
%                                                            target_tosplit);
% % Training
% net = LSTMtrain(train,y_train,val,y_val,[0.54 0.46]);
% 
% % Accuracy on test
% preds = classify(net,test);
% [preds, y_test] = toarray(preds, y_test);
% 
% % Results
% res_plot(preds, y_test, "LivNoLiv")
% LivnoLiv_Acc = eval_res(preds, y_test);

% % Remove no stimuli
% [notliv_eeg, target_notliv, liv_eeg, target_liv] = split_data(picture_eeg,...
%                                         target_picture, living);
%                                     
% %% PICTURE LIVING: Human vs Animal
% animal = 1300;
% labels = label_binarizer(target_liv, animal);
% % % check_plot(liv_eeg, labels, "HumAn");
% 
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(liv_eeg, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "Hum_Animal")
% % HumAn_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [human_data, target_human, data_o, target_o] = split_data(liv_eeg,...
%                                         target_liv, animal);
% 
% %% PICTURE LIVING: Faces vs Bodies
% bodies = 1305;
% labels = label_binarizer(target_human, bodies);
% % % check_plot(human_data, labels, "FaceBod");
% 
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(human_data, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "FacesBodies")
% % FacBod_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [faces_data, target_faces, data_o, target_o] = split_data(human_data,...
%                                         target_human, bodies);
% 
% %% PICTURE LIVING: Adult vs Infant
% infant = 1290;
% labels = label_binarizer(target_faces, infant);
% % % check_plot(faces_data, labels, "AdInf");
% 
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(faces_data, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                           target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "AdultInfant")
% % AdInf_Acc = eval_res(preds, y_test);
% 
% %% PICTURE NOT LIVING: Thing vs Written
% written = [1315, 1320];
% labels = label_binarizer(target_notliv, written);
% % % check_plot(notliv_eeg, labels, "ThingWritt");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(notliv_eeg, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "ThingWrt")
% % TngWrt_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [thing_data, target_thing, written_data, target_written] = split_data(notliv_eeg,...
%                                         target_notliv, written);
% 
% %% PICTURE NOT LIVING: Letter vs Word
% letter = 1320;
% labels = label_binarizer(target_written, letter);
% % % check_plot(written_data, labels, "LettWor");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(written_data, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "LettWor")
% % Lett_Wor_Acc = eval_res(preds, y_test);
% 
% %% PICTURE NOT LIVING: Checkerboard vs Other
% check = 1310;
% labels = label_binarizer(target_thing, check);
% % % check_plot(thing_data, labels, "CheckOth");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(thing_data, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "CheckOth")
% % CheckOth_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [other_data, target_other, data_o, target_o] = split_data(thing_data,...
%                                         target_thing, check);
% 
% %% PICTURE NOT LIVING: Tool vs Object
% tool = 1330;
% labels = label_binarizer(target_other, tool);
% % % check_plot(other_data, labels, "ToolObj");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(other_data, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "ToolObj")
% % ToolObj_Acc = eval_res(preds, y_test);
% 
%% AUDIO vs VIDEO
vid_tar = [1360, 1365, 1368];
labels = label_binarizer(target_vid_aud, vid_tar);
% check_plot(vid_aud_eeg, labels, "VidAud");

% Data Preparation
disp("Train test split...")
[eeg_tosplit, target_tosplit] = data_preparation(vid_aud_eeg, labels);

% Train-Test Split
[train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
                                                           target_tosplit);
% Training
net = LSTMtrain(train,y_train,val,y_val,[0.5 0.5]);

% Accuracy on test
preds = classify(net,test);
[preds, y_test] = toarray(preds, y_test);

% Results
res_plot(preds, y_test, "AudioVideo")
[AudVid_Acc, AudVid_Rec, AudVid_Pre, AudVid_F1] = eval_res(preds, y_test);

% Features importance 
aud_vid_losses = permutation_importance(net, val, y_val);

% Remove no stimuli
[aud_eeg, target_aud, video_eeg, vid_target] = split_data(vid_aud_eeg,...
                                        target_vid_aud, vid_tar);
 %% AUDIO: Target vs Trigger
% audio_target = 1357;
% labels = label_binarizer(target_aud, audio_target);
% % % check_plot(aud_eeg, labels, "AudTrigNoTrig");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(aud_eeg, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "Aud_TriggTarg")
% % Audio_TargTrigg_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [aud_eeg, target_aud, data_o, target_o] = split_data(aud_eeg,...
%                                         target_aud, audio_target);
%                                     
% %% AUDIO: Music vs Not Music
% music = 1340;
% labels = label_binarizer(target_aud, music);
% % % check_plot(aud_eeg, labels, "MusNoMus");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(aud_eeg, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "MusicNotMus")
% % MusnotMus_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [aud_eeg, target_aud, data_o, target_o] = split_data(aud_eeg,...
%                                         target_aud, music);
%                                     
% %% AUDIO: Vocalization vs Word
% voc = 1345;
% labels = label_binarizer(target_aud, voc);
% % % check_plot(aud_eeg, labels, "VocWord");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(aud_eeg, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "VocWord")
% % VocWord_Acc = eval_res(preds, y_test);
% 
% %% VIDEO: Target vs Trigger
% video_target = 1368;
% labels = label_binarizer(vid_target, video_target);
% % % check_plot(video_eeg, labels, "TrigNoTrigVid");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(video_eeg, labels);
% 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "Video_TargTrigg")
% % Video_TargTrigg_Acc = eval_res(preds, y_test);
% 
% % Remove no stimuli
% [video_eeg, vid_target, data_o, target_o] = split_data(video_eeg,...
%                                         vid_target, video_target);
% 
% %% VIDEO: Biological vs Mechanical
% video_target = 1360;
% labels = label_binarizer(vid_target, video_target);
% % % check_plot(video_eeg, labels, "BioMecs");
% 
% % Data Preparation
% disp("Train test split...")
% [eeg_tosplit, target_tosplit] = data_preparation(video_eeg, labels);
% % 
% % % Train-Test Split
% % [train, y_train, val, y_val, test, y_test] = traintestsplit(eeg_tosplit,...
% %                                                            target_tosplit);
% % % Training
% % net = LSTMtrain(train,y_train,val,y_val,512);
% % 
% % % Accuracy on test
% % preds = classify(net,test);
% % [preds, y_test] = toarray(preds, y_test);
% % 
% % % Results
% % res_plot(preds, y_test, "BioMecc")
% % BioMecc_Acc = eval_res(preds, y_test);
% 
