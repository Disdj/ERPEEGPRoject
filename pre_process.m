function data_eeg = pre_process(data_eeg)
    % Debiasing
    disp("DC Correction...")
    fs = 512;
    start = [2/(fs/2)];
    to = [16/(fs/2)];
%     [b,a] = cheby2(5, 70, [start to], 'bandpass');
%     % fvtool(b,a)

    for i=1:length(data_eeg(:,1))-1
        signal = data_eeg(i,:);
        signal = signal - mean(signal);
        signal = bandpass(signal, [start to]);
        data_eeg(i,:) = signal;
    end
    %plot_data(data_eeg)

    % Filtering
    % We apply a notch filter, removing noise.
    disp("50Hz remotion...")
    wo = [50/(fs/2)];
    bw = wo;
    [b, a] = iirnotch(wo,bw);

    for i=1:length(data_eeg(:,1))-1
        data_eeg(i,:) = filter(b,a,data_eeg(i,:));
    end
%     
    % Outlier detection
    for i=1:length(data_eeg(:,1))-1
        channel = data_eeg(i,:);
        channel(channel>25) = 20; 
        channel(channel<-25) = -20; 
        data_eeg(i,:) = channel;
    end
    
end