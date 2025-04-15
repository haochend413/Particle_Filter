% Use projection Algorithm to update the parameters in the observation
% model; 
% input: old parameter matrix (theta); estimation (raw states, phi); observation (conbined output, y); 
% output: updated parameter matrix (theta_new)
% function theta_new = Project_alg(theta, estimation, observation)
%     error_term = observation - estimation * theta;       
%     gain = estimation' / (estimation * estimation');     
%     theta_new = theta + gain * error_term;               
% 
%     % Print the updated theta matrix
%     disp('Updated theta matrix:');
%     disp(theta_new);
% end


function theta_new = Project_alg(theta, estimation, observation)
    error_term = diag(observation) - diag(estimation) .* theta;
    gain = diag(estimation) ./ sum(estimation.^2, 2);  % Assuming row-wise update
    theta_new = theta + gain .* error_term;
             

    % Print the updated theta matrix
    disp('Updated theta matrix:');
    disp(theta_new);
end