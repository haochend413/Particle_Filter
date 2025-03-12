
close all;
clc;
clear; 

%%%%%%%%%%%%%%%%%%%%%%%
% Set Parameters
%%%%%%%%%%%%%%%%%%%%%%%

% Syncronize these parameters with real_system parameters! 

% init particles
ranges = [-2000,2000; -400, 400];  
num_particles = 100000;  

% init system 
num_steps = 700;               % Number of time steps 
t = 0;                         % time start with 0, increase each step
dt = 0.04; 


% Predict step (state model) 

% | x |            | 1  dt | | x |      | ?  |
% |   |          = |       | |   |    + |    | * a + process_noise
% | v | (t + dt)   | 0   1 | | v | (t)  | dt |

% **!!!** a is initialized inside the predict function
process_noise = [0.1, 0.001];      % [std_x, std_v]


% Update Step (observation model)
measurement_noise = 1;          % std_x_observed

% Resampling
position_noise_std = 1;  % jittering noises for position and velocity
velocity_noise_std = 1; 


% Fetch Observed Data
load("positions.mat","positions");
load("velocities.mat", "velocities"); 
true_positions = positions; 
true_velocities = velocities; 


%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Setup
%%%%%%%%%%%%%%%%%%%%%%%

history_particles = zeros(num_steps, 2);
history_estimates = zeros(num_steps, 1);
history_true_velocity = zeros(num_steps, 1);


%%%%%%%%%%%%%%%%%%%%%%%
% PF Initialization
%%%%%%%%%%%%%%%%%%%%%%%

% choose different init functions for different init patterns

[particles, weights] = init_unif(ranges, num_particles); 
[init_x, init_v,~,~] = Estimate(particles, weights); 
estimate = [1000,0]; 

%%%%%%%%%%%%%%%%%%%%%%%
% PF Propagation
%%%%%%%%%%%%%%%%%%%%%%%
% particles and weights are updated each step


for j = 1:num_steps

    %%%%%%%%%%%%%%%%%%%%%%%
    % Filtering
    %%%%%%%%%%%%%%%%%%%%%%%

    % Get true data for each step
    true_position = true_positions(j);
    true_velocity = true_velocities(j);

    % Predict
    particles = Predict(particles, t, dt, process_noise);  % Assume time step of 1, std of guassian noise to be 2; 

    % Update
    weights = Update(particles, weights, true_position, measurement_noise);
    
    % Resample 
    [particles, weights] = Resample(particles, weights, position_noise_std, velocity_noise_std);

    % Estimate 
    [mean_x, mean_v, ~, ~] = Estimate(particles, weights);
    estimate = [mean_x, mean_v]; 
    % Time Update
    t = t + dt; 

    %%%%%%%%%%%%%%%%%%%%%%%
    % Display & Plotting Setup
    %%%%%%%%%%%%%%%%%%%%%%%
    
    % Display progress
    % disp(['size of particles: ', num2str(size(particles, 1))]); 
    % disp(['Step ', num2str(t), ...
    %     ': True Position = ', num2str(true_position), ...
    %     ', Estimated Position = ', num2str(mean_x), ...
    %     ', Estimated Velocity = ', num2str(mean_v), ...
    %     ', True v', num2str(true_velocity)]);
    
    
    % Store history for plotting
    history_particles(j, :) = [mean_x, mean_v];
    history_estimates(j) = true_position; 
    history_true_velocity(j) = true_velocity;

end




%%%%%%%%%%%%%%%%%%%%%%%
% Plotting
%%%%%%%%%%%%%%%%%%%%%%%

% Plot results
figure;
plot(dt:dt:num_steps * dt, history_estimates, 'r', 'DisplayName', 'True Position','LineWidth', 3);
hold on;
plot(dt:dt:num_steps * dt, history_particles(:, 1), 'b', 'DisplayName', 'Estimated Position', 'LineWidth', 2);
xlabel('Time Step' , 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('Position' , 'FontName', 'Times New Roman', 'FontSize', 12);
legend('Location','southeast');
title('Position Estimation Over Time' , 'FontName', 'Times New Roman', 'FontSize', 12); 
set(gca, 'FontSize', 20)
set(gca, 'FontName', 'Times New Roman')



figure; 
plot(dt:dt:num_steps * dt, history_true_velocity, 'r', 'DisplayName', 'True Velocity' ,'LineWidth', 3); 
hold on; 
plot(dt:dt:num_steps * dt, history_particles(:, 2), 'b', 'DisplayName', 'Estimated Velocity','LineWidth', 2); 
xlabel('Time Step' , 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('Velocity' , 'FontName', 'Times New Roman', 'FontSize', 12);
title('Estimated Velocity Over Time' , 'FontName', 'Times New Roman', 'FontSize', 12);
legend('Location','best');
grid on; 
set(gca, 'FontSize', 20)
set(gca, 'FontName', 'Times New Roman')

hold off; % Release the hold to prevent future plots from being added to the same figure




% % plot for debug
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