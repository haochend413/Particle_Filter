% Update
% Given the observed position, update x;

% input:
% 1. particles
% 2. weights
% 3. position observation z with std R (Gaussian noise)

% output: updated weights array

function updated_weights = Update(particles, weights, z, R)
    % Compute distances between particle positions and measurement z
    dist = particles(:, 1) - z; % this needs some noise; 
    
    % Compute likelihood 
    % Assume gaussian observation noise 
    likelihood = (1 / (R * sqrt(2 * pi))) * exp(-0.5 * (dist ./ R).^2);
    
    % Update and normalize weights
    updated_weights = weights .* likelihood;
    updated_weights = updated_weights / sum(updated_weights + 1.e-300);
end

