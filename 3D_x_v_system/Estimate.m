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

function [mean_xx, mean_vx, mean_xy, mean_vy, mean_xz, mean_vz] = Estimate(particles, weights)
    % Compute mean values
    mean_xx = sum(particles(:, 1) .* weights);
    mean_vx = sum(particles(:, 2) .* weights); 
    mean_xy = sum(particles(:, 3) .* weights);
    mean_vy = sum(particles(:, 4) .* weights); 
    mean_xz = sum(particles(:, 5) .* weights);
    mean_vz = sum(particles(:, 6) .* weights); 
    
    
    % % Compute variances
    % var_x = sum(weights .* (particles(:, 1) - mean_xx).^2);
    % var_v = sum(weights .* (particles(:, 2) - mean_vx).^2);
end