function [a] = nbodyaccn(m, r)
%this function only handles CORES
% m: Vector of length N containing the core masses, row or col doesnt matter
% r: N x 3 array containing the core positions 

% a: N x 3 array containing the computed core accelerations

    %number of cores
    num_cores = length(m);  

    % in the case of just one core
    if num_cores == 1
         a = zeros(1,3);
         return 
    end
    
    %iterate over each core, using summation formula
    a = [];
    for i = 1 : num_cores
        curr_a = zeros(1,3);
        r_curr = r(i,:);
        for j = 1 : num_cores
            if i ~= j %do not include itself
                r_diff = r(j,:) - r_curr; %row r vector
                r_mag = norm(r_diff);
                curr_a = curr_a + ( m(j)/(r_mag)^3 ) * r_diff; %3D vector!
            end
        end
        a = [a ; curr_a];   
    end
end
