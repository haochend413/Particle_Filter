% what user needs to define for system initialization:
% 2. size (number of particles/rows);
% 3. init range for each dimension (range of particle values);
% ranges should be an array of 2-tuples

% what the init function returns:
% 1. The multidimensional array representing the particles;
% 2. The 1-D weight array that represent the possibility of that particle;


function [particles, weights] = init(ranges)
    % Define position and velocity ranges
    x_range = ranges(1, :);
    v_range = ranges(2, :);
    
    % Generate two different grid for x and v
    [X, V] = meshgrid(x_range(1):x_range(2), v_range(1):v_range(2));
    particles = [X(:), V(:)];
    
    % Initialize normalized weights
    num_particles = size(particles, 1);
    weights = ones(num_particles, 1) / num_particles;
end



