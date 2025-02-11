% Predict 

% input: 
% 1. an array of (x,v) tuples, representing particles
% 2. delta t, time traveled. 

% output: 
% 1. an updated array of tuple, based on  system dynamics

function predicted_particles = sin_predict(particles, dt, std, a)
    % State transition matrix
    % this needs to come with some noise! which can be some random
    % acceleration that I do not know of.  

    % System dynamics with Gaussian noise; 
    A = [1, dt; -dt, 1];


    process_noise = std .* randn(size(particles)); 
    
    % Apply transition to all particles
    % use transpose to do matrix multiplication
    predicted_particles = (A * particles')' + process_noise;
end

