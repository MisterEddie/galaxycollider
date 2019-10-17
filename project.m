clear; clc;
avienable = false;
avifilename = 'galaxy.avi';
pausetime = 0.01; %seconds
view_xy = true;

level = 8;
tmax = 2000;

%2 cores, no stars-----------------------------------------------------------------------------
% num_stars_per_gal = [0;0]; 
% r_star_max_range = 50;
% r_star_min_range = 49;
% 
% r_1_core = 40;
% r_2_core = 40;
% r = r_1_core + r_2_core;
% m_1 = 5;
% m_2 = m_1*(r_1_core/r_2_core);
% m = m_1 + m_2;
%  
% r_cores_init = [r_1_core 0 0; -r_2_core 0 0];
% v_cores_init = [0 sqrt(m_2*r_1_core)/r 0 ; 0 -sqrt(m_1*r_2_core)/r 0];
% m_cores = [m_1 m_2];
% spin_dir = {'cw' ,'cw'};

%one core Stationary, stars----------------------------------------------------------------------------------------
% num_stars_per_gal = [200];
% r_star_max_range = 50;
% r_star_min_range = 49;
% 
% r_cores_init = [0 0 0];
% v_cores_init = [0 0 0];
% m_cores = [10];
% spin_dir = "ccw";

%one moving core, stars-----------------------------------------------------------------------------------------------
% num_stars_per_gal = [1000]; 
% r_star_max_range = 50;
% r_star_min_range = 49;
% 
% r_cores_init = [0 0 0];
% v_cores_init = [0.1 0 0];
% m_cores = [100];
% spin_dir = "cw";

%two galaxy collision, stars-----------------------------------------------------------------------------------
num_stars_per_gal = [500 500];
r_star_max_range = 50;
r_star_min_range = 20;

r_1_core = 70;
r_2_core = 70;
r = r_1_core + r_2_core;
m_1 = 10;
m_2 = m_1*(r_1_core/r_2_core);
m = m_1 + m_2;

r_cores_init = [r_1_core 0 0; -r_2_core 0 0];
v_cores_init = [0 0.8*sqrt(m_2*r_1_core)/r 0 ; 0 -0.8*sqrt(m_1*r_2_core)/r 0];
m_cores = [m_1 m_2];
spin_dir = {'cw' ,'cw'};

%SIMULATE GALAXY-----------------------------------------------------------------------------------------
[r_stars_init, v_stars_init] = init_stars(num_stars_per_gal,... 
    r_star_max_range, r_star_min_range, r_cores_init, v_cores_init, spin_dir, m_cores);

[t, r_cores, v_cores] = evolve_body(tmax, level, r_cores_init, v_cores_init,...
    m_cores);

[t, r_stars, v_stars] = evolve_stars(tmax, level, r_stars_init, v_stars_init,...
   r_cores, m_cores);

%GRAPHICALLY VISUALIZE RESULTS-----------------------------------------------------------------------------------
if avienable
    aviobj = VideoWriter(avifilename);
    open(aviobj);
end
for i = 1:length(t)
    
    %plot every star at once, then increment time
    cores_x = r_cores(:,1,i);
    cores_y = r_cores(:,2,i);
    cores_z = r_cores(:,3,i);
    
    core_color = 'cyan';
    core_outline_color = 'black';
    core_size = 100;
    scatter3(cores_x,cores_y,cores_z,core_size,'MarkerFaceColor',core_color,'MarkerEdgeColor',core_outline_color);
    hold on;
    
    %check if we have any stars
    if ~isempty(r_stars)
        stars_x = r_stars(:,1,i);
        stars_y = r_stars(:,2,i);
        stars_z = r_stars(:,3,i);
        
        star_color = 'yellow';
        star_outline_color = 'black';
        star_size =7;
        
        scatter3(stars_x,stars_y,stars_z,star_size,'MarkerFaceColor',star_color,'MarkerEdgeColor',star_outline_color);
        hold on; 
    end
        xlabel("X Position");
        ylabel("Y Position");
        zlabel("Z Position");
        titlestr = sprintf('Step: %d', i);
        title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'green');
        lim = 200;
        xlim([-lim lim]);
        ylim([-lim lim]);
        zlim([-lim lim]);
        if(view_xy)
            view(0,90);
        end
        drawnow;
        hold off;
        
% Record video frame if AVI recording is enabled and record 
% multiple copies of the first frame.  Here we record 5 seconds
% worth which will allow the viewer a bit of time to process 
% the initial scene before the animation starts.
    if avienable
        if t == 0
            framecount = 5 * aviframerate ;
        else
            framecount = 1;
        end
        
        for iframe = 1 : framecount
            writeVideo(aviobj, getframe(gcf));
        end
    end
    pause(pausetime);
end

% If we're making a video, finalize the recording and
% write a diagnostic message that a movie file was created.
if avienable
    close(aviobj);
    fprintf('Created video file: %s\n', avifilename);
end
