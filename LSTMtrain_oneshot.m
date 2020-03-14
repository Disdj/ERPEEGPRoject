function net = LSTMtrain_oneshot(train,y_train,val,y_val)
    % LSTM Network architecture
    disp("LSTM generation...")
    inputSize = 126;
    numClasses = 18;
    numHiddenUnits = 500;

    layers = [ ...
        sequenceInputLayer(inputSize)
        bilstmLayer(numHiddenUnits,'OutputMode','sequence')
        dropoutLayer(0.5)
        bilstmLayer(numHiddenUnits/2,'OutputMode','sequence')
        dropoutLayer(0.5)
        bilstmLayer(numHiddenUnits/4,'OutputMode','sequence')
        dropoutLayer(0.5)
        bilstmLayer(numHiddenUnits/10,'OutputMode','sequence')
%         dropoutLayer(0.5)
%         lstmLayer(50,'OutputMode','sequence')
%         dropoutLayer(0.5)
%         lstmLayer(25,'OutputMode','sequence')
        dropoutLayer(0.5)
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];

    % Per aggiungere questa riga svegliati ed installa il nuovo
    % driver di CUDA.
    %     'ExecutionEnvironment','gpu', ... 
    options = trainingOptions('adam', ...
        'GradientThreshold',1, ...
        'ValidationData',{val,y_val},...
        'ValidationFrequency',20,...
        'MaxEpochs',10, ...
        'LearnRateDropFactor',0.2, ...
        'LearnRateDropPeriod',5, ...
        'MiniBatchSize', 128, ...
        'LearnRateSchedule','piecewise', ...
        'SequenceLength','longest', ...
        'Shuffle','never', ...
        'Verbose',0, ...
        'Plots','training-progress');

    net = trainNetwork(train,y_train,layers,options);
end
