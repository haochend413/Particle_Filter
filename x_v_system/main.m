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
ranges = [0, 100; -10, 10];  % Define position and velocity ranges [x_range; v_range]
num_particles = 2000000; 
num_steps = 50;               % Number of time steps
x0 = 5;                       % Initial position
measurement_noise = 2;        % Measurement noise (R) 

% jittering noises for position and velocity
position_noise_std = 0.5;
velocity_noise_std = 0.1;



% Initialize particles
[particles, weights] = init(ranges, num_particles);

% Store history for plotting
history_particles = zeros(num_steps, 2);
history_estimates = zeros(num_steps, 1);
history_true_velocity = zeros(num_steps, 1);

% Simulate particle filter over time
for t = 1:num_steps

    % linear case
    true_position = x0 + t; 
    % nonlinear case
    % true_position = x0 + sin(t); 

    
    
    % Predict step (motion model)
    particles = Predict(particles, 1, 2);  % Assume time step of 1, std of guassian noise to be 2; 
    
    % Update weights based on position observation
    % Generate observation with noise
    
    weights = Update(particles, weights, true_position, measurement_noise);
    
    % Resample particles
    [particles, norm_weights] = Resample(particles, weights, position_noise_std, velocity_noise_std);


    
    disp(['size of particles: ', num2str(size(particles, 1))]); 
    
    % Estimate parameters
    [mean_x, mean_v, ~, ~] = Estimate(particles, weights);

    %     % plot 
    % if t <= 20
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
    history_particles(t, :) = [mean_x, mean_v];
    history_estimates(t) = true_position;

    
    % Display progress
    disp(['Step ', num2str(t), ': True Position = ', num2str(true_position), ...
        ', Estimated Position = ', num2str(mean_x), ', Estimated Velocity = ', num2str(mean_v)]);
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
plot(1:num_steps, history_particles(:, 2), 'b', 'DisplayName', 'Estimated Velocity'); % Plot the velocity

% Compute the overall mean velocity across all time steps
overall_mean_velocity = mean(history_particles(:, 2));

% Plot the overall mean velocity as a constant horizontal line
hold on; % Hold the current plot to overlay the mean line
plot(1:num_steps, repmat(overall_mean_velocity, num_steps, 1), 'r--', 'DisplayName', 'Overall Mean Velocity'); % Red dashed line for overall mean

xlabel('Time Step');
ylabel('Velocity');
legend;
title('Estimated Velocity Over Time');
hold off; % Release the hold to prevent future plots from being added to the same figure
