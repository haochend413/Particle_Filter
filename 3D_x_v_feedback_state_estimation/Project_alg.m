% Use projection Algorithm to update the parameters in the observation
% model; 
% input: old parameter matrix (theta); estimation (raw states, phi); observation (conbined output, y); 
% output: updated parameter matrix (theta_new)


% function theta_new = Project_alg(theta, estimation, observation) 
%     theta_new = theta + estimation' / (estimation * estimation') * observation - estimation * theta;               
% 
%     % Print the updated theta matrix
%     disp('Updated theta matrix:');
%     disp(theta_new);
% end


function theta_new = Project_alg(theta, estimation, observation)
    theta_new = theta + (diag(estimation) ./ sum(estimation.^2, 2)) .* (diag(observation) - diag(estimation) .* theta);
    % Print the updated theta matrix
    disp('Updated theta matrix:');
    disp(theta_new);
end