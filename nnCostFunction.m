function [J grad] = nnCostFunction(nn_params, ...
    input_layer_size, ...
    hidden_layer_size, ...
    num_labels, ...
    X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
    hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
    num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Add ones to the X data matrix
X = [ones(m, 1) X];

for i = 1:m
    a2 = [1 sigmoid(X(i,:)*Theta1')];
    a3 = sigmoid(Theta2*a2');
    
    y_encoded = zeros(num_labels,1);
    y_encoded(y(i)) = 1;
    
    for k = 1:num_labels
        J = J - (y_encoded(k)*log(a3(k))) - ((1-y_encoded(k))*log(1-a3(k)));
    end
end
J = J/m;

[r1,c1] = size(Theta1);
[r2,c2] = size(Theta2);

reg_cost = 0;
for i = 1:r1
    for j = 2:c1
        reg_cost = reg_cost + Theta1(i,j)^2;
    end
end

for i = 1:r2
    for j = 2:c2
        reg_cost = reg_cost + Theta2(i,j)^2;
    end
end

reg_cost = (reg_cost*lambda)/(2*m);
J = J + reg_cost;


for t = 1:m
    a1 = X(t,:);
    z2 = [1 a1*Theta1'];
    a2 = [1 sigmoid(a1*Theta1')];
    a3 = sigmoid(Theta2*a2');
    
    y_encoded = zeros(num_labels,1);
    y_encoded(y(t)) = 1;
   
    delta3 = a3 - y_encoded;
    delta2 = ((Theta2'*delta3)'.*sigmoidGradient(z2))';
    delta2 = delta2(2:end);
    
    Theta2_grad = Theta2_grad + delta3*a2;
    Theta1_grad = Theta1_grad + delta2*a1;
    
end

Theta2_grad = Theta2_grad/m;
Theta1_grad = Theta1_grad/m;

for i = 1:r1
    for j = 2:c1
        Theta1_grad(i,j) = Theta1_grad(i,j) + (lambda/m)*Theta1(i,j);
    end
end

for i = 1:r2
    for j = 2:c2
        Theta2_grad(i,j) = Theta2_grad(i,j) + (lambda/m)*Theta2(i,j);
    end
end

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
