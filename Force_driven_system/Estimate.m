% Estimate function

% estimate position (nased on noised observation) and velocity (based ont th
% e difference between distances ? )

% input
% 1. particles
% 2. weights

% output
% 1. mean_x
% 2. mean_v
% 3. var_x
% 4. var_v

function [mean_x, mean_v, var_x, var_v] = Estimate(particles, weights)
    % Compute mean values
    mean_x = sum(particles(:, 1) .* weights);
    mean_v = sum(particles(:, 2) .* weights);
    
    % Compute variances
    var_x = sum(weights .* (particles(:, 1) - mean_x).^2);
    var_v = sum(weights .* (particles(:, 2) - mean_v).^2);
end