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
    % weights
    % ax = 1; bx = 1; 
    % ay = 1; by = 1; 
    % az = 1; bz = 1; 
    % curr = particles(:,1) * ax + particles(:,2) * bx + particles(:,3) * ay + particles(:,4) * by + particles(:,5) * az+ particles(:,6) * bz;  
    C = [1,0,0,0,0,0;
         0,1,0,0,0,0;
         0,0,1,0,0,0;
         0,0,0,1,0,0;
         0,0,0,0,1,0;
         0,0,0,0,0,1];
    dist_vec = particles * C - z; 
    dist = vecnorm(dist_vec, 2, 2);  % Compute the 2-norm for each row
    
    % Compute likelihood 
    % Assume gaussian observation noise 
    likelihood = (1 / (R * sqrt(2 * pi))) * exp(-0.5 * (dist ./ R).^2);
    
    % Update and normalize weights 
    updated_weights = weights .* likelihood;
    updated_weights = updated_weights / sum(updated_weights + 1.e-300);
end

