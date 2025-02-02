% what user needs to define for system initialization:
% 2. size (number of particles/rows);
% 3. init range for each dimension (range of particle values);
% ranges should be an array of 2-tuples

% what the init function returns:
% 1. The multidimensional array representing the particles;
% 2. The 1-D weight array that represent the possibility of that particle;


function [particles, weights] = init(ranges)
    % x range : 0-1000
    % v range : -5 - 5
    x_range = ranges(1);
    v_range = ranges(2);
    
    % array for x and v
    x_array = x_range(1):1:x_range(2);
    v_array = v_range(1):1:v_range(2);
    
    size_x = length(x_array);
    size_v = length(v_array); 

    particles = cell(1, size_v * size_x);
    % Populate Particle Array
    for i = 1:size_x
        for j = 1:size_v
            p = {x_array(i), v_array(j)};
            particles(i) = p;
        end
    end
    
    % init weight
    
    % weight
    w = 1/(size_x * size_v);
    weights = ones(1, (size_x * size_v));
    weights = weights.*w;
end