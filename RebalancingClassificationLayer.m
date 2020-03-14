classdef RebalancingClassificationLayer < nnet.layer.ClassificationLayer
   
    properties
            % Vector of weights corresponding to the classes in the training
            % data
            ClassWeights
    end
    methods
        function layer = RebalancingClassificationLayer(classWeights, name)           
             % Set class weights
            layer.ClassWeights = classWeights;

            % Set layer name
            if nargin == 2
                layer.Name = name;
            end

            % Set layer description
            layer.Description = 'Weighted cross entropy';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % loss = forwardLoss(layer, Y, T) returns the weighted cross
            % entropy loss between the predictions Y and the training
            % targets T.
            % Find observation and sequence dimensions of Y
            [~, N, S] = size(Y);

            % Reshape ClassWeights to KxNxS
            W = repmat(layer.ClassWeights(:), 1, N, S);

            % Compute the loss
            loss = -sum( W(:).*T(:).*log(Y(:)) )/N;
        end
        
        function dLdY = backwardLoss(layer, Y, T)
            % dLdY = backwardLoss(layer, Y, T) returns the derivatives of
            % the weighted cross entropy loss with respect to the
            % predictions Y.
            % Find observation and sequence dimensions of Y
            [~, N, S] = size(Y);

            % Reshape ClassWeights to KxNxS
            W = repmat(layer.ClassWeights(:), 1, N, S);

            % Compute the derivative
            dLdY = -(W.*T./Y)/N;
        end
    end
end