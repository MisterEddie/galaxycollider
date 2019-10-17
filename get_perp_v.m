function perp_v = get_perp_v(in_v, dir)
%in_v: M x 3 matrix, each M is a row vector of star position
%dir: Direction of spin

%perp_v : M x 3 matrix, each M is a unit row vector peprpendicular to star position

    %this function checks if an orientation is provided
    %if exist is true, it means dir is a variable that exists!
    if ~exist('dir','var')
        % not indicating ori
        dir = 'none';
    end
    
    perp_v = [];
    num_vec = size(in_v,1); %retrieve dim of input matrix vector
    
    for i=1:num_vec
        %grab row vector
        curr_v = (in_v(i,:));
        
        %null returns two col vectors perpendicular to curr_v
        two_perp_v = null(curr_v); %e.g.[v1 v2]
        %we take first vector because the third vector is in z dir, turn back into row vector
        xy_perp_v = (two_perp_v(:,1))';
   
        % check if z direction is up or down
        % returns row vector
        z_vec = cross(curr_v,xy_perp_v);
        if (z_vec(1,3) > 0)
            z_vec = 1;
        else
            z_vec = 0;
        end
        %positive z (1) means vector is in ccw
        %negative z (0) means vector is in cw
        
        %string comparing
        if strcmp(dir,'ccw')
        %specified ccw, negative perp vec gets flipped
            if(z_vec == 1)
                flip = 1;
            else
                flip = -1;
            end      
        else
        %specified cw, positive perp vec gets flipped     
            if(z_vec == 1)
                flip = -1;
            else
                flip = 1;
            end
        end
        %flip signs as needed by orientation
        xy_perp_v = flip*xy_perp_v;
        %add row to the bottom
        perp_v = [perp_v ; xy_perp_v];
    end
end


