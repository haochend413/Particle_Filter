% 1-D particles

classdef ParticlesSet
    properties
        size % number of particles used
        particles % md array, row: particle
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
            obj.particles = randi([x_range(1), x_range(2)], size(1));

            % weight
            w = 1/size;
            weight = ones(size);
            obj.weights = weight.*w; 
        end

        % Predict step, predicts postiori belief based on priori belief and
        % system dynamics. 
        % Simple 1-D movement command for system dynamic. 
        function obj = Predict(u, std)
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
        
        function obj = Update(z, R)
            %1-D distance
            dist = obj.particles - z; 

            % Update weights with gaussian noise
            % normalpdf returns the possibility at z of N(dist, R); 
            % Consider using toolbox normpdf()
            obj.weights = obj.weights .* (1 / (R * sqrt(2 * pi))) * exp(-(z - dist)^2 / (2 * R^2));

            % normalize weight; 
            obj.weights = obj.weights / sum(obj.weights + 1.e-300) ;
        end


        % Resampling function, maximizing the high-weighted particles. 
        % Consider making this static. 
        function obj = Resample()
            %
        end
    end

    methods(Static)
        % Estimate function, outputs mean and var of particle simulated distribution; 
        function obj = estimate(obj)
            obj.mean = sum(obj.particles.* obj.weight); 
            obj.var = sum(obj.weight .* (obj.particles - obj.mean).^2);
        end
    end
        
end

% functions; 
