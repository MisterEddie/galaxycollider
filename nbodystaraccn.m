function [a] = nbodystaraccn(r_stars, r_cores, m)
%calculating star's acceleration
% m: Vector of length N containing the CORE masses 
% r_stars: N x 3 array containing the star positions
% r_cores: N x 3 array containing the core positions

% a: N x 3 array containing the computed star accelerations
        
    num_stars = length(r_stars(:,1));  
    num_cores = length(m);  

    % compute acceleration with summation
    a = [];
    for i = 1 : num_stars
        curr_a = zeros(1,3);
        r_curr = r_stars(i,:);
        for j = 1 : num_cores %calculate acceleration due to all cores
            r_diff = r_cores(j,:) - r_curr;
            r_mag = norm(r_diff);
            curr_a = curr_a + ( m(j)/(r_mag)^3 ) * r_diff;
        end
        
        if isempty(a)
            a = curr_a;
        else
            a = [a;curr_a];
        end
    
    end
    
end
