function [] = res_plot(preds, y_test, string)
    figure()
    plot(preds(1:1000),'.-')
    hold on
    plot(y_test(1:1000))
    hold off
    xlabel("Time Step")
    ylabel("Trigger")
    title(string)
    legend(["Predicted" "Test Data"])
end