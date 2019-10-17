function [t, r, v] = evolve_body(tmax, level, r_core_init, v_core_init, m)
%This function handles only cores
%tmax : final solution time
%level: discretization level
%N = number of cores
%r_init : N x 3 array containing core's initial position
%v_init : N x 3 array containing core's initial velocities
%m : size N Vector of masses of cores, orientation does not matter

%t : length nt vector time returned
%r : 3D array containing all positions of all cores for all times
%v : 3D array containing all velocities of all cores for all times

    %discretization levels
    nt = 2^level + 1; %number of steps
    t = linspace(0, tmax, nt);
    dt = t(2) - t(1);

    %motion matrices
    num_cores = length(m);
    r = zeros(num_cores, 3, nt); %(row, columnns, depth/step)
    v = zeros(num_cores, 3, nt); 

    %initialize first position/velocity step
    r(:,:,1) = r_core_init;
    v(:,:,1) = v_core_init;

    %initilize second position step
    a = nbodyaccn(m, r(:,:,1));
    r(:,:,2) = r(:,:,1) + dt * v(:,:,1) + dt^2 * (1/2) * a;

    %evolve body MOST PROUD OF THIS LINE YAY BECAUSE ITS SO POWERFUL AND DRIVES THE ENTIRE PROGRAM!
    for n = 2 : (nt-1)
        a = nbodyaccn(m, r(:,:,n));
        r(:,:,n+1) = 2*r(:,:,n) - r(:,:,n-1) + (dt^2) * a;
        v(:,:,n) = (r(:,:,n+1) - r(:,:,n-1)) / (2*dt);
    end
    %linear extrapolation for last velocity
    v(:,:,nt) = 2*v(:,:,nt-1) - v(:,:,nt-2);
end

    
    
