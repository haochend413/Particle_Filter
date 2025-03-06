% real system


% Initial conditions
position = 1000; 
velocity = 3; 


t = 0; 
dt = 0.03; % time-track 
num_steps = 2000; % Define the number of simulation steps
 


% Storage for plotting
positions = zeros(num_steps, 1);
velocities = zeros(num_steps, 1);
time = 1:num_steps;


% Create single particle
p = [position, velocity]; 

for j = 1:num_steps



    % feedback control parameters
    k_pos = -0.6;
    k_vel = -0.3;
    a = k_pos * p(1) + k_vel * p(2); 

    % with noise at base level
    noise_size = 50; 
    noise_a = randn * noise_size;
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
save('velocities.mat', "velocities"); 

% Calculate Sensor output: a * p + b * v
a = 0.7;
b = 0.3; 
outputs = positions * a + velocities * b; 
save('outputs.mat', 'outputs'); 

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