function predicted_particles = Predict(particles, t, dt, std, p)
    % feedback control parameters
    k_posx = -10;
    k_velx = -1;
    k_posy = -1;
    k_vely = -1;
    k_posz = -1;
    k_velz = -1;
    
    % State transition matrix
    A = [1, dt, 0, 0, 0, 0;
         0, 1, 0, 0, 0, 0;
         0, 0, 1, dt, 0, 0;
         0, 0, 0, 1, 0, 0;
         0, 0, 0, 0, 1, dt;
         0, 0, 0, 0, 0, 1];
    
    % Control input matrix
    B = [dt^2/2, 0, 0;
         dt, 0, 0;
         0, dt^2/2, 0;
         0, dt, 0;
         0, 0, dt^2/2;
         0, 0, dt];
    
    % Loop over each particle
    predicted_particles = zeros(size(particles));
    for i = 1:size(particles, 1)
        % Get the state of the current particle
        particle = particles(i, :)';  % Convert to column vector
        
        % We should use p, which is the estimate of the particles; 
    ax = sin(t);
    ay = 9*sin(3*t);
    az = 4*sin(2*t);
        a = [ax; ay; az];
        
        % Generate process noise (match format from real system)
        process_noise = std(:) .* randn(size(particle));
        
        % Update state with dynamics and noise
        predicted_state = A * particle + B * a + process_noise;
        
        % Store the updated state
        predicted_particles(i, :) = predicted_state';
    end
end