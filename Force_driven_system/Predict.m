% Predict 

% input: 
% 1. an array of (x,v) tuples, representing particles
% 2. delta t, time traveled. 

% output: 
% 1. an updated array of tuple, based on  system dynamics

function [predicted_particles] = Predict(particles, t)
    % matrix multiplication of speed and velocity
    predicted_particles = cell(length(particles));

    % initialize matrix
    sys_dyn = [1, t; 0, 1]; 

    % elementwise multiplication
    for i = 1:length(particles)
        p = sys_dyn * particles(i); 
        predicted_particles(i) = p; 
    end
end
