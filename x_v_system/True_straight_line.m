% Real-life system simulation

% Initial conditions
position = 10;
velocity = 5;
std = [0.5, 0.01]; % Standard deviation for position and velocity noise

% Create single particle
p = [position, velocity];

dt = 1;
num_steps = 50; % Define the number of simulation steps
a = 2; % Example acceleration value

% Storage for plotting
positions = zeros(num_steps, 1);
velocities = zeros(num_steps, 1);
time = 1:num_steps;

for t = 1:num_steps
    A = [1, dt; 0, 1];       % State transition matrix
    B = [0; a * dt];         % Control input matrix (column vector)
    
    % Generate noise for both position and velocity
    real_noise = std .* randn(1, 2); % Ensures noise is 1×2, matching p

    % Update state
    p = (A * p' + B)' + real_noise;
    
    % Store values for plotting
    positions(t) = p(1);
    velocities(t) = p(2);
end

save('positions.mat', 'positions'); 
save('velocities.mat', "velocities")

% Plot results
figure;

subplot(2,1,1); % First subplot: Position over time
plot(time, positions, '-', 'LineWidth', 2);
xlabel('Time Step');
ylabel('Position');
title('Position vs. Time');
grid on;

subplot(2,1,2); % Second subplot: Velocity over time
plot(time, velocities, '-', 'LineWidth', 2, 'Color', 'r');
xlabel('Time Step');
ylabel('Velocity');
title('Velocity vs. Time');
grid on;