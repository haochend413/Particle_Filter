% Systematic Resampling

% Resampling is only based on weight

% input:
% 1. particles
% 2. weights

% output: 
% 1. updated particles
% 2. updated weights


function [resampled_particles, norm_weights] = Resample(particles, weights, jnoise_xx,jnoise_xv,jnoise_yx,jnoise_yv,jnoise_zx,jnoise_zv)
    num_particles = length(weights);

    % make partition
    positions = (rand(num_particles, 1) + (0:num_particles-1)') / num_particles;
    positions(num_particles) = 1 - 1e-12; 
    
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

    % % Add Gaussian noise
    noise_xx = jnoise_xx * randn(num_particles, 1);  % Noise for position
    noise_xv = jnoise_xv * randn(num_particles, 1);  % Noise for velocity
    noise_yx = jnoise_yx * randn(num_particles, 1);  % Noise for position
    noise_yv = jnoise_yv * randn(num_particles, 1);  % Noise for velocity
    noise_zx = jnoise_zx * randn(num_particles, 1);  % Noise for position
    noise_zv = jnoise_zv * randn(num_particles, 1);  % Noise for velocity

    % Apply noise to each resampled particle
    resampled_particles(:, 1) = resampled_particles(:, 1) + noise_xx;  % Update positions with noise
    resampled_particles(:, 2) = resampled_particles(:, 2) + noise_xv;  % Update velocities with noise
    resampled_particles(:, 3) = resampled_particles(:, 3) + noise_yx;  % Update positions with noise
    resampled_particles(:, 4) = resampled_particles(:, 4) + noise_yv;  % Update velocities with noise
    resampled_particles(:, 5) = resampled_particles(:, 5) + noise_zx;  % Update positions with noise
    resampled_particles(:, 6) = resampled_particles(:, 6) + noise_zv;  % Update velocities with noise
end
    
   
