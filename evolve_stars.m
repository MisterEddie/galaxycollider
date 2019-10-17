function [t, r_stars, v_stars] = evolve_stars(tmax, level, r_stars_init, v_stars_init, r_cores, m)
%tmax : final solution time
%level: discretization level
%N : number of cores
%M : number of stars
%r_stars_init : M x 3 array containing star's initial position (3 for 3d)
%v_stars_init : M x 3 array containing star's initial velocities
%r_cores : N x 3 array containing core's position (3D array)
%m = size N vector of masses of cores

%t : time vector of length nt
%r_stars : 3D array containing all positions of all stars for all times
%v_stars : 3D array " " velocity " " " 

    if isempty(r_cores)
        % no initial position supplied
        r_stars = [];
        v_stars = [];
        return;
    else
    
    %discretization
    nt = 2^level + 1;
    t = linspace(0, tmax, nt);
    dt = t(2) - t(1);
    
    %edge case where there are no stars
    if isempty(r_stars_init)
        r_stars = [];
        v_stars = [];
        return
    end
   
    %motion matrices
    num_stars = length(r_stars_init(:,1));
    r_stars = zeros(num_stars,3,nt);
    v_stars = zeros(num_stars,3,nt);
    
    %initialize first position/velocity step
    r_stars(:,:,1) = r_stars_init;
    v_stars(:,:,1) = v_stars_init;
    
    %initialize second position step
    %r_cores_shaped = reshape(r_cores(:,:,1),len(m),3);
    a = nbodystaraccn(r_stars(:,:,1),r_cores(:,:,1),m);
    r_stars(:,:,2) = r_stars(:,:,1) + dt * v_stars(:,:,1) + dt^2 * (1/2) * a;
    
    %evolve stars
    for n = 2 : (nt-1)
        %r_cores_shaped = reshape(r_cores(:,:,n),N_cores,3);
        a = nbodystaraccn(r_stars(:,:,n),r_cores(:,:,n),m);
        r_stars(:,:,n+1) = 2*r_stars(:,:,n) - r_stars(:,:,n-1) + (dt^2) * a;
        v_stars(:,:,n) = (r_stars(:,:,n+1) - r_stars(:,:,n-1)) / (2*dt);
    end
   %linear extrapolate for the last velocity
    v_stars(:,:,nt) = 2 * v_stars(:,:,nt-1) - v_stars(:,:,nt-2);
end
    
    
    
    
 