%% Functions
function [] = plot_data(data_eeg)
    figure()
    subplot(2,1,1)
    for i=1:length(data_eeg(:,1))
        plot(data_eeg(i,:))
        % legend('Orientation', 'horizontal', 'Location', 'east')
        hold on
    end
    
    subplot(2,1,2)
    fs = 512;
    for i=1:length(data_eeg(:,1))-4
        spectrum = fft(data_eeg(i,:));
        spectrum = spectrum(1:length(spectrum)/2+1);
        pxx = (1/fs*length(data_eeg(1,:)))*abs(spectrum).^2;
        pxx(2:end-1) = 2*pxx(2:end-1);
        fxx = 0:(fs/2)/(length(data_eeg(1,:))/2):fs/2;
        plot(fxx,pxx)
        % legend('Orientation', 'horizontal', 'Location', 'east')
        hold on
    end
    ylim([0 3e14])
    xlim([0 256])
end