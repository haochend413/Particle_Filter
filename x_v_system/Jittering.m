% jittering function

% should do linear-jittering: consider the size of the noise dependent
% with the size of the steps; 

function [jittered_particles] = Jittering(resampled_particles, position_noise_std, velocity_noise_std)

    num_particles = resampled_particles.size(); 

    % % Add Gaussian noise to resampled particles

    % try deduce the noises from current velocity



    noise_x = position_noise_std * randn(num_particles, 1);  % Noise for position
    noise_v = velocity_noise_std * randn(num_particles, 1);  % Noise for velocity

    % Apply noise to each resampled particle
    jittered_particles(:, 1) = resampled_particles(:, 1) + noise_x;  % Update positions with noise
    jittered_particles(:, 2) = resampled_particles(:, 2) + noise_v;  % Update velocities with noise
end
