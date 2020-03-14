function [data_z, target_z, data_o, target_o] = split_data(data, target, criteria)
    condition = ismember(target, criteria);
    data_z = data;
    target_z = target;
    data_z(:, condition) = [];
    target_z(condition) = [];
%     remainder = mod(length(data_z),64);
%     data_z(:, 1:remainder) = [];
%     target_z(1:remainder) = [];

    data_o = data;
    target_o = target;
    data_o(:, ~condition) = [];
    target_o(~condition) = [];
%     remainder = mod(length(data_o),64);
%     data_o(:, 1:remainder) = [];
%     target_o(1:remainder) = [];
end