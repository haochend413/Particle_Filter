% Initial conditions
positionx = 5; 
positiony = 5; 
positionz = 5; 
velocityx = -0; 
velocityy = -0;
velocityz = -0;                                                        

t = 0; 
dt = 0.04; % time-step 
num_steps = 800; % Define the number of simulation steps

% Storage for plotting & data
positionxs = zeros(num_steps, 1);  
positionys = zeros(num_steps, 1);  
positionzs = zeros(num_steps, 1);  
velocitiesx = zeros(num_steps, 1); 
velocitiesy = zeros(num_steps, 1); 
velocitiesz = zeros(num_steps, 1); 
outputs = zeros(num_steps, 1);

% Create single particle
p = [positionx, velocityx, positiony, velocityy, positionz, velocityz]; 

for j = 1:num_steps
    k_posx = -10;
    k_velx = -1;
    k_posy = -1;
    k_vely = -1;
    k_posz = -1;
    k_velz = -1;

    ax = k_posx * p(1) + k_velx * p(2); 
    ay = k_posy * p(3) + k_vely * p(4);
    az = k_posz * p(5) + k_velz * p(6); 

    p = p(:);  % enforce column
    a = [ax; ay; az];  % enforce column

    A = [1, dt, 0, 0, 0, 0; 
         0, 1, 0, 0, 0, 0; 
         0, 0, 1, dt, 0, 0; 
         0, 0, 0, 1, 0, 0; 
         0, 0, 0, 0, 1, dt; 
         0, 0, 0, 0, 0, 1]; 

    B = [dt^2/2, 0, 0; 
         dt, 0, 0; 
         0, dt^2/2, 0; 
         0, dt, 0; 
         0, 0, dt^2/2; 
         0, 0, dt]; 

    process_noise = 0.1 * [1;1;1;1;1;1] .* randn(size(p)); 
    p = A * p + B * a + process_noise;  % clean matrix math

    % Store values for plotting
    positionxs(j) = p(1); % x
    positionys(j) = p(3); % y
    positionzs(j) = p(5); % z
    t = t + dt; 
    velocitiesx(j) = p(2); % vx
    velocitiesy(j) = p(4); % vy
    velocitiesz(j) = p(6); % vz

    % Output generation 
    observation_noise = 0.2; 
    ax = 1; bx = 0; 
    ay = 1.1; by = 0; 
    az = 2.1; bz = 0; 
    outputs(j) = p(1) * ax + p(2) * bx + p(3) * ay + p(4) * by + p(5) * az + p(6) * bz + observation_noise * randn; 

end

% Save for output 
save('positions.mat', 'positionxs', 'positionys', 'positionzs'); 
save('velocities.mat', 'velocitiesx', 'velocitiesy', 'velocitiesz'); 
save('outputs.mat', 'outputs'); 

% Plot results as a 3D line
figure;

% 3D line plot of the particle trajectory
plot3(positionxs, positionys, positionzs, 'b-', 'LineWidth', 1.5);

xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
title('3D Trajectory of the Particle');
grid on;
axis equal;
view(3); % Set default 3D view


% Create time vector for plotting
time = (0:dt:(num_steps-1)*dt)';

% Create figure for position vs time plots
figure('Position', [100, 100, 900, 700]);

% Plot X position vs time
subplot(3,1,1);
plot(time, positionxs, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('X Position');
title('X Position vs Time');

% Plot Y position vs time
subplot(3,1,2);
plot(time, positionys, 'g-', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Y Position');
title('Y Position vs Time');

% Plot Z position vs time
subplot(3,1,3);
plot(time, positionzs, 'r-', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Z Position');
title('Z Position vs Time');

% Adjust spacing between subplots
tight = get(gcf, 'Position');
set(gcf, 'Position', tight);
sgtitle('Position vs Time for Each Coordinate');