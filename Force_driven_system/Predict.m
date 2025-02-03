% Predict 

% input: 
% 1. an array of (x,v) tuples, representing particles
% 2. delta t, time traveled. 

% output: 
% 1. an updated array of tuple, based on  system dynamics

function predicted_particles = predict(particles, t)
    % State transition matrix
    sys_dyn = [1, t; 0, 1]; 
    
    % Apply transition to all particles
    % use transpose to do matrix multiplication
    predicted_particles = (sys_dyn * particles')';
end
