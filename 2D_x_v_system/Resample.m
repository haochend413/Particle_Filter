% Systematic Resampling

% Resampling is only based on weight

% input:
% 1. particles
% 2. weights

% output: 
% 1. updated particles
% 2. updated weights


function [resampled_particles, norm_weights] = Resample(particles, weights, position_noise_std, velocity_noise_std)
    num_particles = length(weights);

    % make partition
    positions = (rand(num_particles, 1) + (0:num_particles-1)') / num_particles;
    positions(num_particles) = 0.99999; 
    
    % Cumulative sum of weights
    weights_cumsum = cumsum(weights); 
    
    % Systematic resampling
    i = 1;
    j = 1;
    resampled_particles = zeros(size(particles));
    while i <= num_particles
        
            if positions(i) < weights_cumsum(j)
                resampled_particles(i, :) = particles(j, :);
                i = i + 1;
            else
                j = j + 1;
            end
            if j > num_particles
                break; 
            end
    end
    
    % Assign equal weights
    norm_weights = ones(num_particles, 1) / num_particles;

    % Jittering comes after estimate; 

    % % Add Gaussian noise to resampled particles

    % try deduce the noises from current velocity



    noise_x = position_noise_std * randn(num_particles, 1);  % Noise for position
    noise_v = velocity_noise_std * randn(num_particles, 1);  % Noise for velocity

    % Apply noise to each resampled particle
    resampled_particles(:, 1) = resampled_particles(:, 1) + noise_x;  % Update positions with noise
    resampled_particles(:, 2) = resampled_particles(:, 2) + noise_v;  % Update velocities with noise
end
    
   
