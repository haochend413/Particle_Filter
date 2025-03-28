function predicted_particles = Predict(particles, t, dt, std, p)
    k_posx = -0.1;
    k_velx = -1;
    k_posy = -1;
    k_vely = -0.5;
    k_posz = -0.1;
    k_velz = -0.1;
    
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
        particle = particles(i,:); 
        
        % We should use p, which is the estimate of the particles; particle
        ax = k_posx * p(1) + k_velx * p(2);
        ay = k_posy * p(3) + k_vely * p(4);
        az = k_posz * p(5) + k_velz * p(6);
        a = [ax, ay, az];
        
        % Generate process noise (match format from real system)
        process_noise = std .* randn(size(particle));
        
        % Update state with dynamics and noise
        predicted_state = particle * A' + a * B' + process_noise;
        
        % Store the updated state
        predicted_particles(i,:) = predicted_state;
    end
end