% full function set fullScript.m



% init particles
% this generates all possible integer-valued particles 
function [particles, weights] = init(ranges, num_particles)
    % Define position and velocity ranges
    x_range = ranges(1, :);
    v_range = ranges(2, :);
    
    % Generate random positions and velocities within the specified ranges
    x_values = x_range(1) + (x_range(2) - x_range(1)) * rand(num_particles, 1);
    v_values = v_range(1) + (v_range(2) - v_range(1)) * rand(num_particles, 1);
    
    % Combine into particle matrix
    particles = [x_values, v_values];
    weights = ones(num_particles, 1) / num_particles;
end


% predict step
% each particle is moved according to its own velocity. 

function predicted_particles = predict(particles, t, std)
    % State transition matrix
    % this needs to come with some noise! which can be some random
    % acceleration that I do not know of. 

    sys_dyn = [1, t; 0, 1]; 
    process_noise = std .* randn(size(particles));
    
    % Apply transition to all particles
    % use transpose to do matrix multiplication
    predicted_particles = (sys_dyn * particles')' + process_noise;
end



% Update Step
% updated only according to the position we have
function updated_weights = Update(particles, weights, z, R)
    % Compute distances between particle positions and measurement z
    dist = particles(:, 1) - z;
    
    % Compute likelihood
    likelihood = (1 / (R * sqrt(2 * pi))) * exp(-0.5 * (dist ./ R).^2);
    
    % Update and normalize weights
    updated_weights = weights .* likelihood;
    updated_weights = updated_weights / sum(updated_weights + 1.e-300);
end



% Resample Step
% system resampling, according to the weights; 

function [resampled_particles, norm_weights] = Resample(particles, weights)
    num_particles = length(weights);

    % make partition
    positions = (rand(num_particles, 1) + (0:num_particles-1)') / num_particles;
    
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
    end
    
    % Assign equal weights
    norm_weights = ones(num_particles, 1) / num_particles;
end


% Estimate parameters
function [mean_x, mean_v, var_x, var_v] = Estimate(particles, weights)
    % Compute mean values
    mean_x = sum(particles(:, 1) .* weights);
    mean_v = sum(particles(:, 2) .* weights);
    
    % Compute variances
    var_x = sum(weights .* (particles(:, 1) - mean_x).^2);
    var_v = sum(weights .* (particles(:, 2) - mean_v).^2);
end