% Systematic Resampling

% Resampling is only based on weight

% input:
% 1. particles
% 2. weights

% output:
% 1. updated particles
% 2. updated weights


function [resampled_particles, norm_weights] = Resample(particles, weights)
    % make partition
    size = length(particles);
    size_index = 1:size;
    positions = (size_index + rand(1, size)) / size;
    positions(size) = 0.99999;
    
    % Resample
    weights_cumsum = cumsum(weights);
    
    i = 1;
    j = 1;
    
    Updated_particles = ones(1, size);
    
    while i <= size
    
        if positions(i) < weights_cumsum(j)
            Updated_particles(i) = particles(j);
            i = i + 1;
        else
            j = j + 1;
        end
    
    end
    
    % Update particles and normalize weights
    resampled_particles = Updated_particles;
    norm_weights = ones(1, size) .* (1/size);
    
    end
    
   
