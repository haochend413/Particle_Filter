% Update
% Given the observed position, update x;

% input:
% 1. particles
% 2. weights
% 3. position observation z with std R (Gaussian noise)

% output: updated weights array

function [updated_weights] = update(particles, weights)
    % Set up pos array
    x_array = cell(1, particles.length());
    for i = 1:length(particles)
        pair = particles(i);
        x_array(i) = pair(1);
    end
    
    % 1-D distance
    dist = x_array - z;
    likelihood = (1 / (R * sqrt(2 * pi))) * exp(-0.5 * (dist ./ R).^2);
    updated_weights = weights .* likelihood; % elementwise operations between arrays
    updated_weights = updated_weights / sum(weights + 1.e-300); % prevent divide by 0; 
end

