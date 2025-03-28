
close all;
clc;
clear; 

%%%%%%%%%%%%%%%%%%%%%%%
% Set Parameters
%%%%%%%%%%%%%%%%%%%%%%% 

% Syncronize these parameters with real_system parameters! 

% init particles
ranges = [-150,150; -150,150; -150,150; -10, 10; -10, 10; -10, 10]; 
num_particles = 2000; 

% init system 
num_steps = 2000;               % Number of time steps
t = 0;                         % time start with 0, increase each step
dt = 0.04; 


% Predict step (state model) 
% **!!!** a is initialized inside the predict function
process_noise = 0.02 * [1,1,1,1,1,1];     
% Update Step (observation model)
measurement_noise = 3; %0.00249661;                         % noise for sensor
 
% Resampling 
jnoise_xx = 0.8;  % jittering noises for position and velocity
jnoise_xv = 0.8;
jnoise_yx = 0.8;  % jittering noises for position and velocity
jnoise_yv = 0.8; 
jnoise_zx = 0.8;  % jittering noises for position and velocity
jnoise_zv = 0.8;  



% Fetch Observed Data (NOT FOR USE)
pos_data = load("positions.mat");
vel_data = load("velocities.mat"); 
true_positionsx = pos_data.positionxs; 
true_velocitiesx = vel_data.velocitiesx; 
true_positionsy = pos_data.positionys; 
true_velocitiesy = vel_data.velocitiesy; 
true_positionsz = pos_data.positionzs; 
true_velocitiesz = vel_data.velocitiesz; 

% Fetch Observed Data
load('outputs.mat', 'outputs'); 
observations = outputs; 


%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Setup
%%%%%%%%%%%%%%%%%%%%%%%

history_particles = zeros(num_steps, 6);
history_xx = zeros(num_steps, 1);  
history_xy = zeros(num_steps, 1);  
history_xz = zeros(num_steps, 1);  
history_vx = zeros(num_steps, 1); 
history_vy = zeros(num_steps, 1); 
history_vz = zeros(num_steps, 1); 


%%%%%%%%%%%%%%%%%%%%%%%
% PF Initialization
%%%%%%%%%%%%%%%%%%%%%%%

% choose different init functions for different init patterns
[particles, weights] = init_unif(ranges, num_particles); 

% estimate result, start at [0,0] an get updated; 
% the estimated results will be used instead of the observed results;
estimate = [50,50,50,-2,-2,-2]; 

%%%%%%%%%%%%%%%%%%%%%%%
% PF Propagation
%%%%%%%%%%%%%%%%%%%%%%%
% particles and weights are updated each step


for j = 1:num_steps

    %%%%%%%%%%%%%%%%%%%%%%%
    % Filtering
    %%%%%%%%%%%%%%%%%%%%%%%

    % Get true data for each step
    
    observation = observations(j,:); 


    % Update 
    weights = Update(particles, weights, observation, measurement_noise);

    % Resample 
    [particles, weights] = Resample(particles, weights, jnoise_xx,jnoise_xv,jnoise_yx,jnoise_yv,jnoise_zx,jnoise_zv);

    % Estimate 
    [mean_xx, mean_vx, mean_xy, mean_vy, mean_xz, mean_vz] = Estimate(particles, weights);
    estimate = [mean_xx, mean_vx, mean_xy, mean_vy, mean_xz, mean_vz]; 

    % Predict 
    particles = Predict(particles, t, dt, process_noise, estimate);  % Assume time step of 1, std of guassian noise to be 2; 


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
    history_particles(j, :) = [mean_xx, mean_vx, mean_xy, mean_vy, mean_xz, mean_vz];
    history_xx(j) = true_positionsx(j); 
    history_xy(j) = true_positionsy(j); 
    history_xz(j) = true_positionsz(j); 
    history_vx(j) = true_velocitiesx(j); 
    history_vy(j) = true_velocitiesy(j); 
    history_vz(j) = true_velocitiesz(j); 


end




%%%%%%%%%%%%%%%%%%%%%%%
% Plotting 3D Position Trajectory
%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot3(history_xx, history_xy, history_xz, 'r', 'DisplayName', 'True Position', 'LineWidth', 3); hold on;
plot3(history_particles(:,1), history_particles(:,3), history_particles(:,5), 'b', 'DisplayName', 'Estimated Position', 'LineWidth', 2);
xlabel('X Position', 'FontSize', 12);
ylabel('Y Position', 'FontSize', 12);
zlabel('Z Position', 'FontSize', 12);
legend('Location','best');
title('3D Position Estimation Over Time', 'FontSize', 12);
grid on;
set(gca, 'FontSize', 20)
set(gca, 'FontName', 'Times New Roman')
hold off;

%%%%%%%%%%%%%%%%%%%%%%%
% Plotting 
%%%%%%%%%%%%%%%%%%%%%%%
time = dt:dt:num_steps * dt;

%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Velocity Components
%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
plot(time, history_vx, 'r', time, history_particles(:,2), 'b');
legend('True Vx', 'Estimated Vx'); xlabel('Time'); ylabel('Vx');

subplot(3,1,2);
plot(time, history_vy, 'r', time, history_particles(:,4), 'b');
legend('True Vy', 'Estimated Vy'); xlabel('Time'); ylabel('Vy');

subplot(3,1,3);
plot(time, history_vz, 'r', time, history_particles(:,6), 'b');
legend('True Vz', 'Estimated Vz'); xlabel('Time'); ylabel('Vz');

sgtitle('Velocity Components Over Time');
%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Velocity Error
%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
plot(time, history_vx - history_particles(:,2), 'r');
xlabel('Time'); ylabel('Vx');

subplot(3,1,2);
plot(time, history_vy - history_particles(:,4), 'r');
xlabel('Time'); ylabel('Vy');

subplot(3,1,3);
plot(time, history_vz - history_particles(:,6), 'r');
xlabel('Time'); ylabel('Vz');

sgtitle('Velocity Error Over Time');






%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Position Components
%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
plot(time, history_xx, 'r', time, history_particles(:,1), 'b');
legend('True Xx', 'Estimated Xx'); xlabel('Time'); ylabel('Xx');

subplot(3,1,2);
plot(time, history_xy, 'r', time, history_particles(:,3), 'b');
legend('True Xy', 'Estimated Xy'); xlabel('Time'); ylabel('Xy');

subplot(3,1,3);
plot(time, history_xz, 'r', time, history_particles(:,5), 'b');
legend('True Xz', 'Estimated Xz'); xlabel('Time'); ylabel('Xz');

sgtitle('Position Components Over Time');

%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Position Error
%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
plot(time, history_xx - history_particles(:,1), 'r');
 xlabel('Time'); ylabel('Xx');

subplot(3,1,2);
plot(time, history_xy - history_particles(:,3), 'r');
 xlabel('Time'); ylabel('Xy');

subplot(3,1,3);
plot(time, history_xz - history_particles(:,5), 'r');
xlabel('Time'); ylabel('Xz');

sgtitle('Position Error Over Time');
