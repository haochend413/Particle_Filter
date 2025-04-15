% Initial conditions
positionx = 50; 
positiony = 50; 
positionz = 50; 
velocityx = -2; 
velocityy = -2;
velocityz = -2;                                                        

t = 0; 
dt = 0.04; % time-step 
num_steps = 2000; % Define the number of simulation steps

% Storage for plotting & data
positionxs = zeros(num_steps, 1);  
positionys = zeros(num_steps, 1);  
positionzs = zeros(num_steps, 1);  
velocitiesx = zeros(num_steps, 1); 
velocitiesy = zeros(num_steps, 1); 
velocitiesz = zeros(num_steps, 1); 
outputs = zeros(num_steps, 6); 
% outputs = zeros(num_steps, 1);

% Create single particle
p = [positionx, velocityx, positiony, velocityy, positionz, velocityz]; 

for j = 1:num_steps
    k_posx = -1;
    k_velx = -0.2;
    k_posy = -0.3;
    k_vely = -0.1;
    k_posz = -0.5;
    k_velz = -0.5;

    ax = k_posx * p(1) + k_velx * p(2); 
    ay = k_posy * p(3) + k_vely * p(4);
    az = k_posz * p(5) + k_velz * p(6); 


    a = [ax, ay, az];  % enforce column
    % A'
    A = [1, dt, 0, 0, 0, 0; 
         0, 1, 0, 0, 0, 0; 
         0, 0, 1, dt, 0, 0; 
         0, 0, 0, 1, 0, 0; 
         0, 0, 0, 0, 1, dt; 
         0, 0, 0, 0, 0, 1]; 
    % B'
    B = [dt^2/2, 0, 0; 
         dt, 0, 0; 
         0, dt^2/2, 0; 
         0, dt, 0; 
         0, 0, dt^2/2; 
         0, 0, dt]; 

    process_noise = 0.3 * [1,1,1,1,1,1] .* rand(size(p));
    p = p * A' + a * B' + process_noise;  % clean matrix math

    % Store values for plotting
    positionxs(j) = p(1); % x
    positionys(j) = p(3); % y
    positionzs(j) = p(5); % z
    t = t + dt; 
    velocitiesx(j) = p(2); % vx
    velocitiesy(j) = p(4); % vy
    velocitiesz(j) = p(6); % vz

    % Output generation 
    observation_noise = 0.05 * randn(1,6); 
    C = [1,0,0,0,0,0;
         0,20,0,0,0,0;
         0,0,1,0,0,0;
         0,0,0,2,0,0;
         0,0,0,0,1,0;
         0,0,0,0,0,2]; 
    outputs(j,:) = p * C + observation_noise; 
    % output shape: 1 * 6 vector; 

end

% Save for output 
save('positions.mat', 'positionxs', 'positionys', 'positionzs'); 
save('velocities.mat', 'velocitiesx', 'velocitiesy', 'velocitiesz'); 
save('outputs.mat', 'outputs'); 

% Plot results as a 3D line
figure;
% 3D line plot of the particle trajectory
plot3(positionxs, positionys, positionzs, 'b', 'DisplayName', 'Robot Trajectory', 'LineWidth', 2);
xlabel('X Position', 'FontSize', 12);
ylabel('Y Position', 'FontSize', 12);
zlabel('Z Position', 'FontSize', 12);
title('3D Trajectory of the Particle','FontSize', 32);
legend('Location','best');
grid on;
set(gca, 'FontSize', 20)
set(gca, 'FontName', 'Times New Roman')
axis equal;
view(3); % Set default 3D view

% figure;
% plot3(history_xx, history_xy, history_xz, 'r', 'DisplayName', 'True Position', 'LineWidth', 3); hold on;
% plot3(history_particles(:,1), history_particles(:,3), history_particles(:,5), 'b', 'DisplayName', 'Estimated Position', 'LineWidth', 2);
% xlabel('X Position', 'FontSize', 12);
% ylabel('Y Position', 'FontSize', 12);
% zlabel('Z Position', 'FontSize', 12);
% legend('Location','best');
% title('3D Position Estimation Over Time', 'FontSize', 32);
% grid on;
% set(gca, 'FontSize', 20)
% set(gca, 'FontName', 'Times New Roman')
% hold off;


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
