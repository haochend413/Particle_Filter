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
    x_array = zeros(1, length(particles));
    v_array = zeros(1, length(particles));

    % populate x, v arrays
    for i = 1:length(particles)
        p = particles(i);
        x_array(i) = p(1);
        v_array(i) = p(2);
    end

    % calculate mean
    mean_x = sum(x_array .* weights); 
    mean_v = sum(v_array .* weights); 
    var_x = sum(weights .* (x_array - mean_x).^2);
    var_v = sum(weights .* (v_array - mean_v).^2);
    
end