% 1-D particle filter

classdef ParticlesSet

    properties
        size % number of particles used
        particles % 1d array, row: particle
        weights % 1d array of the same size of particles;
        mean
        var % variance of the distribution
    end

    methods


        % Constructor, initializes randomly distributed particles of given size;
        % Weight spread equally;
        function obj = ParticlesSet(size, x_range)
            % size
            obj.size = size;
            % 1-D particle array
            obj.particles = randi([x_range(1), x_range(2)], 1, size);

            % weight
            w = 1/size;
            weights = ones(1, size);
            obj.weights = weights.*w;
        end


        % Predict step, predicts postiori belief based on priori belief and
        % system dynamics.
        % Simple 1-D movement command for system dynamic.
        % u: distance moving forward (positive) or backwards(negative)
        function obj = Predict(obj, u, std)
            noise = randn(1, obj.size) * std;
            dist = noise + u;
            obj.particles = obj.particles + dist;
        end


        % Update step, updates the postiori belief based on measurement and
        % noise.
        % z: array, observation
        % R: standard deviation
        % Assume that there is only one landmark and the measurement noise
        % is gaussian;
        function obj = Update(obj, z, R)
            % 1-D distance
            dist = obj.particles - z;

            % Update weights with gaussian noise
            % normalpdf returns the possibility at z of N(dist, R);
            % Consider using toolbox normpdf()
            likelihood = (1 / (R * sqrt(2 * pi))) * exp(-0.5 * (dist ./ R).^2);
            obj.weights = obj.weights .* likelihood; % elementwise operations between arrays

            % normalize weight;
            obj.weights = obj.weights / sum(obj.weights + 1.e-300) ;
        end


        % Residual resampling function, maximizing the high-weighted particles.
        % After resampling, the weights of all particles goes back to 1/N.
        
        function obj = resResample(obj)
            % Weight * N copy
            int_array = int32(obj.weights .* obj.size); % correct

            % Update particle array.
            Updated_particles = ones(1, obj.size);

            % for every index in the int_array, the particle along with its
            % weight get repeated;

            index = 1;
            for i = 1:obj.size % int_array
                k = int_array(i);


                % particle at position(i) gets updated by k times;
                for j = 1:k
                    Updated_particles(index) = obj.particles(i);
                    index = index + 1;
                end
            end


            % This leaves slots in the particle array since the integer is
            % floored. We fill in the slots by taking residuals and do
            % multinomial resampling on the residual array;

            n_slot = obj.size - sum(int_array); % number of slots

            residual_array = obj.weights .* obj.size - double(int_array); % residual array;
            residual_array = residual_array / sum(residual_array); % normalization;

            % multinomial resampling;
            % build cummulative sum array and use random points to choose
            % interval;

            residual_cumsum = cumsum(residual_array);
            residual_cumsum(obj.size) = 1.; % avoid round-off error

            % Sampling.
            random_vals = rand(1, n_slot); % Generate random values in [0, 1)
            residual_particles = arrayfun(@(x) find(residual_cumsum >= x, 1), random_vals);
            Updated_particles(sum(int_array) + 1 : obj.size) = residual_particles;

            obj.particles = Updated_particles;
            % Weight reset.
            obj.weights = ones(1, obj.size) / obj.size;

        end

        % System Resampling

        function obj = sysResample(obj)
            % take size subdivisions;
            % cumulative sum array
            % make sure each sample is 1/size apart;

            % make partitions
            size_index = 1:obj.size;
            positions = (size_index + rand(1, obj.size)) / obj.size; % ./ not needed since N is scaler.
            positions(obj.size) = 0.99999; 
            
            
            disp(['position array: ', num2str(positions)]);

            % Resample
            disp(['weight array: ', num2str(obj.weights)]);
            weights_cumsum = cumsum(obj.weights);
            disp(['cumsum array: ', num2str(weights_cumsum)]);

            i = 1; 
            j = 1;

            Updated_particles = ones(1, obj.size);

            while i <= obj.size

                if positions(i) < weights_cumsum(j)
                    Updated_particles(i) = obj.particles(j);
                    i = i + 1; 
                else
                    j = j + 1;
                end

            end

            % Update particles and normalize weights
            obj.particles = Updated_particles;
            obj.weights = ones(1, obj.size) .* (1/obj.size);
        end


        % Estimate function, outputing mean and var of particle simulated distribution;
        function obj = Estimate(obj)
            obj.mean = sum(obj.particles.* obj.weights);
            obj.var = sum(obj.weights .* (obj.particles - obj.mean).^2);
        end
    end
end

% functions;
