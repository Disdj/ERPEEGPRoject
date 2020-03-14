function target = regularize(target)
    % From spike to histograms. 
    m = target(1);
    for i=1:length(target)
        if(target(i)==0)
            target(i) = m;
        else
           m = target(i);
        end
    end
end
