% Update
% Given the observed position, update x;

% input:
% 1. particles
% 2. weights
% 3. position observation z with std R (Gaussian noise)

% output: updated weights array

function updated_weights = Update(particles, weights, z, R)
    % Compute distances between particle positions and measurement z

    % Calculate according to output function
    a = 0.3;
    b = 0.7; 
    curr = particles(:,1) * a + particles(:,2) * b; 
    dist = curr - z; 
    
    % Compute likelihood 
    % Assume gaussian observation noise 
    likelihood = (1 / (R * sqrt(2 * pi))) * exp(-0.5 * (dist ./ R).^2);
    
    % Update and normalize weights 
    updated_weights = weights .* likelihood;
    updated_weights = updated_weights / sum(updated_weights + 1.e-300);
end

