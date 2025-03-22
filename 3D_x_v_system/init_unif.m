% what user needs to define for system initialization:
% 2. size (number of particles/rows);
% 3. init range for each dimension (range of particle values);
% ranges should be an array of 2-tuples

% what the init function returns:
% 1. The multidimensional array representing the particles;
% 2. The 1-D weight array that represent the possibility of that particle;


function [particles, weights] = init_unif(ranges, num_particles)
    % Define position and velocity ranges
    xx_range = ranges(1, :);
    vx_range = ranges(2, :);
    xy_range = ranges(3, :);
    vy_range = ranges(4, :);
    xz_range = ranges(5, :);
    vz_range = ranges(6, :);
    
    % Generate random positions and velocities within the specified ranges
    xx_values = xx_range(1) + (xx_range(2) - xx_range(1)) * rand(num_particles, 1);
    vx_values = vx_range(1) + (vx_range(2) - vx_range(1)) * rand(num_particles, 1);
    xy_values = xy_range(1) + (xy_range(2) - xy_range(1)) * rand(num_particles, 1);
    vy_values = vy_range(1) + (vy_range(2) - vy_range(1)) * rand(num_particles, 1);
    xz_values = xz_range(1) + (xz_range(2) - xz_range(1)) * rand(num_particles, 1);
    vz_values = vz_range(1) + (vz_range(2) - vz_range(1)) * rand(num_particles, 1);
    
    % Combine into particle matrix
    particles = [xx_values, vx_values, xy_values, vy_values, xz_values, vz_values];
    weights = ones(num_particles, 1) / num_particles; 
end



