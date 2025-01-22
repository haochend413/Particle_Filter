% 1-D particles

classdef ParticlesSet
    properties
        size % number of particles used
        particles % md array, row: particle
        weight % 1d array of the same size of particles; 
        mean 
        var % variance of the distribution
    end

    methods
        % Constructor, initializes randomly distributed particles of given size; 
        % Weight spread equally; 
        function obj = ParticlesSet(size, x_range)
            % 1-D particle array
            obj.particles = randi([x_range(1), x_range(2)], size(1));

            % weight
            w = 1/size;
            weight = ones(size);
            obj.weight = weight.*w; 
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
        function obj = Update()
            %
        end
    end

    methods(Static)
        % Estimate function, outputs mean and var of particle simulated distribution; 
        function obj = estimate()
            obj.mean = sum(obj.particles.* obj.weight); 
            obj.var = sum(obj.weight .* (obj.particles - obj.mean).^2);
        end
    end
        
end

% functions; 
