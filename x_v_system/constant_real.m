% Real-life system simulation

% Initial conditions
position = 500;
velocity = 15;
std = [5, 0.02]; % gaussian noise stds for (position, velocity)

% Create single particle
p = [position, velocity]; 

dt = 0.2;
num_steps = 4000; % Define the number of simulation steps
a = 0.2; % Example acceleration value 

% Storage for plotting
positions = zeros(num_steps, 1);
velocities = zeros(num_steps, 1);
time = 1:num_steps;

for t = 1:num_steps
    A = [1, dt; 0, 1];       % State transition matrix
    B = [0; a * dt];         % Control input matrix (column vector)
    
    % Generate noise for both position and velocity
    real_noise = std .* randn(1); 

    % Update state
    p = (A * p' + B)' + real_noise;
    
    % Store values for plotting
    positions(t) = p(1); % x
    velocities(t) = p(2); % v
end


% Save for future output
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