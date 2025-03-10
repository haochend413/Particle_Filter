% Test script for 1-D Particle Filter
clear; clc;

% Initialize parameters
num_particles = 2000;  % Number of particles
x_range = [0, 500];    % Range of x values for particles
u = 150;                 % Movement command for prediction
std_dev = 20;           % Standard deviation for prediction noise
z = 200;                % Observation value
R = 20;                 % Measurement noise standard deviation

% Initialize particle set
disp('Initializing ParticlesSet...');
particles_set = ParticlesSet(num_particles, x_range);
disp(['Initial particles mean: ', num2str(mean(particles_set.particles))]);
disp(['Initial particles variance: ', num2str(var(particles_set.particles))]);


% Plot initial particles
figure;
scatter(particles_set.particles, particles_set.weights, '.', 'MarkerEdgeAlpha', 0.5);
xlabel('Position');
ylabel('Weight');
title('Initial Particles and Weights');
grid on;
disp(['Sum of weights after init: ', num2str(sum(particles_set.weights))]);

% Predict step
disp('Performing Predict step...');
particles_set = particles_set.Predict(u, std_dev);
disp(['Sum of weights after predict: ', num2str(sum(particles_set.weights))]);

% Plot after Predict step
figure;
scatter(particles_set.particles, particles_set.weights, '.', 'MarkerEdgeAlpha', 0.5);
xlabel('Position');
ylabel('Weight');
title('Particles and Weights after Predict Step');
grid on;

% Update step
disp('Performing Update step...');
particles_set = particles_set.Update(z, R);
disp(['Sum of weights after Update: ', num2str(sum(particles_set.weights))]);
disp(['Particles mean after Update: ', num2str(mean(particles_set.particles))]);
disp(['Particles variance after Update: ', num2str(var(particles_set.particles))]);

% Plot after Update step
figure;
scatter(particles_set.particles, particles_set.weights, '.', 'MarkerEdgeAlpha', 0.5);
xlabel('Position');
ylabel('Weight');
title('Particles and Weights after Update Step');
grid on;

% Residual Resample step
disp('Performing Resample step...');
particles_set = particles_set.resResample();

disp(['Particles mean after Resample: ', num2str(mean(particles_set.particles))]);
disp(['Particles variance after Resample: ', num2str(var(particles_set.particles))]);
disp(['Sum of weights after Resample: ', num2str(sum(particles_set.weights))]);
disp(['Number of particles after Resample: ', num2str(length(particles_set.particles))]);

% Plot after Resample step
figure;
scatter(particles_set.particles, particles_set.weights, '.', 'MarkerEdgeAlpha', 0.5);
xlabel('Position');
ylabel('Weight');
title('Particles and Weights after Resample Step');
grid on;

% Estimate step
disp('Performing Estimate step...');
particles_set = particles_set.Estimate();
disp(['Estimated mean: ', num2str(particles_set.mean)]);
disp(['Estimated variance: ', num2str(particles_set.var)]);

% Plot final estimate as a vertical line
figure;
scatter(particles_set.particles, particles_set.weights, '.', 'MarkerEdgeAlpha', 0.5);
hold on;
xline(particles_set.mean, 'r', 'LineWidth', 2, 'DisplayName', 'Estimated Mean');
xlabel('Position');
ylabel('Weight');
title('Final Particles, Weights, and Estimated Mean');
legend show;
grid on;
