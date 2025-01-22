% particle

classdef ParticlesSet
    properties
        size % [number of particles used, number of dimensions]
        particles % md array, row: particle
        weight % 1d array of the same size of particles; 
    end

    methods
        % Constructor, creating randomly distributed particles of given size; 
        % Weight spread equally; 
        function obj = ParticlesSet(size)
            particles = randi


        end
    end
end

% functions; 

def create_particles; 
