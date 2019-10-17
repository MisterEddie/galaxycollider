function [r_stars_init, v_stars_init] = init_stars(num_stars_per_gal, ...
    r_max_star, r_min_star, r_cores_init, v_cores_init, direction, m_cores)
%initializes star positions and velocities
%num_stars_per_gal : row vector of number of stars per galaxy (can be col vector) [num_stars_gal1, num_stars_gal2]
%direction : ccw or cw
%r_max_star : maximum radius of where we want to put star scalar
%r_min_star : minimum radius of where we want to put star scalar
%r_cores_init : N X 3 array of core initial positions (N is num cores)
%v_cores_init : N X 3 array of core initial velocitites
%m_cores : 1D vector of size N mass of core

%r_stars_init : M X 3 array of star initial positions
%v_stars_init: M x 3 array of star initial velocitities

    r_stars_init = [];
    v_stars_init = [];
    num_cores = length(num_stars_per_gal);
    
    diff_max_min = r_max_star - r_min_star;
    
    for i = 1 : num_cores
        % generate stars for each core, core by core
        num_star = num_stars_per_gal(i);
        
        %check if core has any stars
        if (num_star ~= 0)
            %generate random positions in spherical coordinates, rand generates (num_star x 1) vector
            phi = 2 * pi * rand(num_star, 1, 'double');
            theta = 0% 2 * pi * rand(num_star, 1, 'double');
            radius = (diff_max_min) * rand(num_star,1,'double') + r_min_star;

            %convert to xyz coordinates
            %sph2cart returns row vector of a single position [x_pos y_pos z_pos]
            %x,y,z each is num_star by 1 column
            [x, y, z] = sph2cart(phi,theta,radius);

            %calculated r is wrt origin, which is the core it is orbiting
            r_origin = [x,y,z];  
            %find the absolute r_star
            r_stars = r_origin  + r_cores_init(i,:);
            %add row to the bottom
            r_stars_init = [r_stars_init; r_stars];

            %generate star initial velocities
            dir = direction{i};

            %generate magnitude s.t. gives circular orbits sqrt(m/r)
            r_norm = vecnorm(r_origin,2,2); %gets 2norm of 2nd dimension (row by row), returns col vector
            v_stars_init_mag = sqrt( m_cores(i)./r_norm ); %returns col vector, for each star

            %multiply by unit direction (not matrix multiplication, elementwise)
            v_stars = v_stars_init_mag.*get_perp_v(r_origin, dir);
            %add the initial core velocities
            v_stars = v_stars + v_cores_init(i,:);
            %place row to the bottom
            v_stars_init = [v_stars_init; v_stars];
        end

    end

end