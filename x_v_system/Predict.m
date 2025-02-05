% Predict 

% input: 
% 1. an array of (x,v) tuples, representing particles
% 2. delta t, time traveled. 

% output: 
% 1. an updated array of tuple, based on  system dynamics

function predicted_particles = predict(particles, t, std)
    % State transition matrix
    % this needs to come with some noise! which can be some random
    % acceleration that I do not know of. 

    % noise in speed: [-1 ~ 1]; 
    random_acceleration = 2 * rand() - 1; 

    % System dynamics with Gaussian noise; 
    sys_dyn = [1, t; 0, 1 + random_acceleration]; 
    process_noise = std .* randn(size(particles));
    
    % Apply transition to all particles
    % use transpose to do matrix multiplication
    predicted_particles = (sys_dyn * particles')' + process_noise;
end
