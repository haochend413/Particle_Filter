% real system


% Initial conditions
position = 1000; 
velocity = 0; 
std = [1, 2]; % gaussian noise stds for (position, velocity)

t = 0; 
dt = 0.04; % time-track 
num_steps = 700; % Define the number of simulation steps
 


% Storage for plotting
positions = zeros(num_steps, 1);
velocities = zeros(num_steps, 1);
time = 1:num_steps;


% Create single particle
p = [position, velocity]; 

for j = 1:num_steps

    % with noise at base level
    noise_a = randn * 10;
    a = -9*sin(3*t); 
    a = a + noise_a; 

    % propogate model
    A = [1, dt; 0, 1];       % A
    B = [dt^2 / 2, dt];             % control input
    % process_noise = std .* randn(2, 1); 

    % Update state
    p = (A * p')' + B * a;
    
    % Store values for plotting
    positions(j) = p(1); % x
    velocities(j) = p(2); % v

    t = t + dt; 
end


% Save for output 
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