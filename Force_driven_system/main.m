%%%%%%%%%%% System Description %%%%%%%%%%%%%%

% Force-driven car with certain weight; 

% Predict the position and
% velocity of the car. Update the prediction with observation of position;

% all noises are guassian

% Force is a function of time, which is evenly spaced and discrete; We loop
% through the time period to make sequential estimations; 

% position and velocity are dependent; 


%%%%%%%%%%% System Description %%%%%%%%%%%%%%


% test

% Test Script for Particle Filter

% Set parameters
ranges = [0, 10; -5, 5];  % Define position and velocity ranges [x_range; v_range]
num_steps = 50;           % Number of time steps
true_position = 5;        % True position of the object (for comparison)
true_velocity = 2;        % True velocity of the object (for comparison)
measurement_noise = 1;    % Measurement noise (R)

% Initialize particles
[particles, weights] = init(ranges);

% Store history for plotting
history_particles = zeros(num_steps, 2);
history_estimates = zeros(num_steps, 2);

% Simulate particle filter over time
for t = 1:num_steps
    % Simulate true motion (position + velocity)
    true_position = true_position + true_velocity + randn * measurement_noise;  % Add some noise
    true_velocity = true_velocity + randn * 0.1;  % Simulate small changes in velocity

    % Predict step (motion model)
    particles = Predict(particles, 1);  % Assume time step of 1
    
    % Simulate measurement (add noise to true position)
    z = true_position + randn * measurement_noise;
    
    % Update weights based on measurement
    weights = Update(particles, weights, z, measurement_noise);
    
    % Resample particles
    [particles, norm_weights] = Resample(particles, weights);
    
    % Estimate parameters (mean and variance)
    [mean_x, mean_v, var_x, var_v] = Estimate(particles, weights);
    
    % Store history for plotting
    history_particles(t, :) = [mean_x, mean_v];
    history_estimates(t, :) = [true_position, true_velocity];
    
    % Display progress
    disp(['Step ', num2str(t), ': True Position = ', num2str(true_position), ...
        ', Estimated Position = ', num2str(mean_x), ', Estimated Velocity = ', num2str(mean_v)]);
end

% Plot results
figure;
subplot(2, 1, 1);
plot(1:num_steps, history_estimates(:, 1), 'r', 'DisplayName', 'True Position');
hold on;
plot(1:num_steps, history_particles(:, 1), 'b', 'DisplayName', 'Estimated Position');
xlabel('Time Step');
ylabel('Position');
legend;
title('Position Estimation Over Time');

subplot(2, 1, 2);
plot(1:num_steps, history_estimates(:, 2), 'r', 'DisplayName', 'True Velocity');
hold on;
plot(1:num_steps, history_particles(:, 2), 'b', 'DisplayName', 'Estimated Velocity');
xlabel('Time Step');
ylabel('Velocity');
legend;
title('Velocity Estimation Over Time');