% 2-D test 
% Performing system dynamics individually
% x_axis will use residual resampling, y_axis will use systematic
% resampling. 
% 3-D graph, with the x-axis and y-axis, z-axis is weight; 
% x and y are independent

clear; clc;

% Initialize parameters
num_particlesx = 2000;  % Number of particles
x_range = [0, 500];     % Range of x values for particles
ux = 150;               % Movement command for prediction
std_devx = 20;          % Standard deviation for prediction noise
zx = 200;               % Observation value
Rx = 20;                % Measurement noise standard deviation

num_particlesy = 2000;  % Number of particles
y_range = [0, 500];     % Range of y values for particles
uy = 150;               % Movement command for prediction
std_devy = 20;          % Standard deviation for prediction noise
zy = 200;               % Observation value
Ry = 20;                % Measurement noise standard deviation

% Initialize particle sets
x_axis = ParticlesSet(num_particlesx, x_range);
y_axis = ParticlesSet(num_particlesy, y_range);

% Plot initialization
figure;
scatter3(x_axis.particles, y_axis.particles, x_axis.weights, 10, 'filled');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Weight');
title('Initialization');
grid on;

% Predict step
x_axis = x_axis.Predict(ux, std_devx);
y_axis = y_axis.Predict(uy, std_devy);

% Plot prediction step
figure;
scatter3(x_axis.particles, y_axis.particles, x_axis.weights, 10, 'filled');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Weight');
title('Prediction');
grid on;

% Update step
x_axis = x_axis.Update(zx, Rx);
y_axis = y_axis.Update(zy, Ry);

%plot y after update

figure;
scatter(y_axis.particles, y_axis.weights, '.', 'MarkerEdgeAlpha', 0.5);
xlabel('Position');
ylabel('Weight');
title('Particles and Weights after Update Step');
grid on;


% Plot update step
figure;
scatter3(x_axis.particles, y_axis.particles, x_axis.weights, 10, 'filled');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Weight');
title('Update');
grid on;

% Resample step
x_axis = x_axis.resResample(); 
y_axis = y_axis.sysResample(); 

% Plot resampling step
figure;
scatter3(x_axis.particles, y_axis.particles, x_axis.weights, 10, 'filled');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Weight');
title('Resampling');
grid on; 