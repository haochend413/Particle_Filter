% real system

% Initial conditions
position = 1000; 
velocity = 3; 


t = 0; 
dt = 0.04; % time-track 
num_steps = 1000; % Define the number of simulation steps
 
% Noises Setup
% process noice 



% Storage for plotting
positions = zeros(num_steps, 1);
velocities = zeros(num_steps, 1);
outputs = zeros(num_steps, 1);

time = 1:num_steps;


% Create single particle
p = [position, velocity]; 

for j = 1:num_steps



    % feedback control parameters
    k_pos = -1;
    k_vel = -0.1;
    % a = -9*tan(3*t); 
    a = k_pos * p(1) + k_vel * p(2); 


    % noise_a = randn * noise_size;
    % a = a + noise_a; 
    process_noise =  8; 

    % propogate model
    A = [1, dt; 0, 1];       % A
    B = [dt^2 / 2, dt];             % control input
    % process_noise = std .* randn(2, 1); 

    % Update state
    p = (A * p')' + B * a + randn * process_noise;
    

    % Store values for plotting
    positions(j) = p(1); % x
    velocities(j) = p(2); % v

    % output generation
    % Calculate Sensor output: a * p + b * v
    observation_noise = 0; %p(1) / 5 + p(2) / 5
    a = 0.3;
    b = 0.7; 
    outputs(j) = p(1) * a + p(2) * b + observation_noise * randn; 

    t = t + dt; 
end




% Save for output 
save('positions.mat', 'positions'); 
save('velocities.mat', "velocities"); 
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