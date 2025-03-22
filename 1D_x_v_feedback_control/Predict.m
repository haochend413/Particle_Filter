% Predict 

% input: 
% 1. an array of (x,v) tuples, representing particles
% 2. delta t, time traveled. 

% output: 
% 1. an updated array of tuple, based on  system dynamics

function predicted_particles = Predict(particles, t, dt, std, p, v)
    % State transition matrix
    % this needs to come with some noise! which can be some random
    % acceleration that I do not know of.  

    % System dynamics with Gaussian noise; 

    % feedback parameters

    % feedback control parameters
    k_pos = -0.2;
    k_vel = -0.1;
    % a = -9*tan(3*t); 
    a = k_pos * (p - 0) + k_vel * v ; 

    A = [1, dt; 0, 1]; 
    B = [dt^2 / 2, dt]; 


    process_noise = std .* randn(size(particles)); 
    predicted_particles = (A * particles')' + B * a + process_noise;
end

