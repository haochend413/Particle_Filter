% test script ; no direction change for particles; 


%%%%%%%%%%% System Description %%%%%%%%%%%%%%

% Force-driven car with certain weight;
% Predict the position and velocity of the car;
% Update the prediction with observation of position;
% All noises are Gaussian;
% Force is a function of time, which is evenly spaced and discrete;
% Position and velocity are dependent; 

%%%%%%%%%%% Test Script for Particle Filter %%%%%%%%%%%%%% 


% Set parameters 

% init
ranges = [0, 1000; 0, 50];   % Define position and velocity ranges [x_range; v_range]
num_particles = 500000; 
num_steps = 4000;               % Number of time steps 
dt = 0.2;

% predict
% x0 = 5;                       % Initial position
process_noise = [7, 0.03]; 
a = 0.2; 

% update
measurement_noise = 10;        % Measurement noise (R); We only measure position; 

% resample
position_noise_std = 1;  % jittering noises for position and velocity
velocity_noise_std = 1; 






% Initialize particles
[particles, weights] = init_unif(ranges, num_particles);

% Store history for plotting
history_particles = zeros(num_steps, 2);
history_estimates = zeros(num_steps, 1);
history_true_velocity = zeros(num_steps, 1);


% load true data from real system
load("positions.mat","positions");
load("velocities.mat", "velocities"); 
true_positions = positions; 
true_velocities = velocities; 

t = 0; 

% Simulate particle filter over time
for j = 1:num_steps

    true_position = true_positions(j); 
    true_velocity = true_velocities(j); 

    % % straight line case
    % true_position = t + t*t; % v0 = 1; 
    % % This should come with some noise; 
    % true_position = true_position + 10 * randn(1); 
    % true_velocity = 1 + 2 * t; 


    
    
    % Predict step (motion model)
    
    particles = Predict(particles, dt, process_noise, a);  % Assume time step of 1, std of guassian noise to be 2; 
    
    % Update weights based on position observation
    % Generate observation with noise
    
    weights = Update(particles, weights, true_position, measurement_noise);
    
    % Resample particles
    [particles, norm_weights] = Resample(particles, weights, position_noise_std, velocity_noise_std);


    
    disp(['size of particles: ', num2str(size(particles, 1))]); 
    
    % Estimate parameters
    [mean_x, mean_v, ~, ~] = Estimate(particles, weights);
    
    % % plot 
    % if t >= 100 && t <= 150
    % figure;
    % scatter(particles(:, 1), particles(:, 2), 10, 'filled');
    % xlabel('Position'); 
    % ylabel('Velocity');
    % title('Resampled Particles');
    % grid on; 
    % 
    % yline(mean_v, 'b', 'LineWidth', 2); % Horizontal line for mean velocity
    % end 
    
    % Store history for plotting
    history_particles(j, :) = [mean_x, mean_v];
    history_estimates(j) = true_position; 
    history_true_velocity(j) = true_velocity;

    
    % Display progress
    disp(['Step ', num2str(t), ': True Position = ', num2str(true_position), ...
        ', Estimated Position = ', num2str(mean_x), ', Estimated Velocity = ', num2str(mean_v), ', True v', num2str(true_velocity)]);

    t = t + dt; 
end

% Plot results
figure;
subplot(2, 1, 1); 
plot(1:num_steps, history_estimates, 'r', 'DisplayName', 'True Position');
hold on;
plot(1:num_steps, history_particles(:, 1), 'b', 'DisplayName', 'Estimated Position');
xlabel('Time Step');
ylabel('Position');
legend;
title('Position Estimation Over Time'); 

title('Estimated Position vs True Position'); 

subplot(2, 1, 2); 
plot(1:num_steps, history_particles(:, 2), 'b', 'DisplayName', 'Estimated Velocity'); 
hold on; 
plot(1:num_steps, history_true_velocity, 'r', 'DisplayName', 'True Velocity'); 



xlabel('Time Step');
ylabel('Velocity');
legend;
title('Estimated Velocity Over Time');
hold off; % Release the hold to prevent future plots from being added to the same figure




    % % plot 
    % if t <= 40
    % figure;
    % scatter(particles(:, 1), particles(:, 2), 10, 'filled');
    % xlabel('Position'); 
    % ylabel('Velocity');
    % title('Resampled Particles');
    % grid on; 
    % 
    % yline(mean_v, 'b', 'LineWidth', 2); % Horizontal line for mean velocity
    % end 
