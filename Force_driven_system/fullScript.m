% full function set fullScript.m



% init particles

function [particles, weights] = init(ranges)
    % Define position and velocity ranges
    x_range = ranges(1, :);
    v_range = ranges(2, :);
    
    % Generate all possible (x, v) pairs
    [X, V] = meshgrid(x_range(1):x_range(2), v_range(1):v_range(2));
    particles = [X(:), V(:)];
    
    % Initialize uniform weights
    num_particles = size(particles, 1);
    weights = ones(num_particles, 1) / num_particles;
end


% predict step

function predicted_particles = Predict(particles, t)
    % State transition matrix
    sys_dyn = [1, t; 0, 1]; 
    
    % Apply transition to all particles
    predicted_particles = (sys_dyn * particles')';
end

% Update Step

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