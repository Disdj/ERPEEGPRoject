function target = label_binarizer(target, zero_class)
    target(ismember(target,zero_class))=0;
    target(target~=0)=1;
    disp("Zeros")
    disp(length(target)-sum(target))
    disp("Ones")
    disp(sum(target))
    target = categorical(target);
end
