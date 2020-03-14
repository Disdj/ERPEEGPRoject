function target = label_binarizer(target, zero_class)
    target(ismember(target,zero_class))=0;
    target(target~=0)=1;
    target = categorical(target);
end
