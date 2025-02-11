% real sinusoidal system

% Real-life system simulation

% Initial conditions
position = 0;
velocity = 1;
std = [0.1, 0.1]; % gaussian noise stds for (position, velocity)

% Create single particle
p = [position, velocity]; 

dt = 0.001; % time-track
num_steps = 100000; % Define the number of simulation steps


% Storage for plotting
positions = zeros(num_steps, 1);
velocities = zeros(num_steps, 1);
time = 1:num_steps;

t = 0; 

for j = 1:num_steps


    A = [1, dt; -dt, 1];       % State transition matrix

    
    % % Generate noise for both position and velocity
    % real_noise = std .* randn(2,1); 

    % Update state
    p = (A * p')';
    
    % Store values for plotting
    positions(j) = p(1); % x
    velocities(j) = p(2); % v

    t = t + dt; 
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