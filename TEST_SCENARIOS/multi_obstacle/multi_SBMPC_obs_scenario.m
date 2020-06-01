scenario_name = 'multi_SBMPC_obs_scenario';

%% Own ship
eta_initial = [-2500;-2282;20*deg2rad];      %[x, y, psi (rad)]
nu_initial  = [5;0;0];          %[u,v,r]
initial_state = [eta_initial;nu_initial];
waypoints_own_ship = [ -2500, -2282;
                      4077,   112]; 
                  


ROLE_os_relative_to_SBMPC_obs(1,:) = [0,1];  %role value of 1 means that  os is give way vessel relative to sbmpc obs i and therefroe sbmpc obs i is stand on.
HEAD_ON_os_relative_to_SBMPC_obs(1,:) = [0,0]; 



%% Normal obstacles ships (without SBMPC)
number_of_obstacle_ships = 1;

num_obs_ship_waypoints = 2;

% obs 1
initial_obstacle_ship_states(:,1) = [5000;5000;-180*deg2rad;5;0;0]; %[x, y, psi, u, v, r]
waypoints_obstacle_ships(:,:,1)   = [ 5000, 5000;    %obstacle ship 1 waypoints
                                      -5000, 5000];
obs_speed_between_waypoints(1,:) =  [5];
changing_obs(1) = 1;
ROLE_relative_to_own_ship(1) = 0;
ROLE_relative_to_SBMPC_obs(1,:) = [0,0]; 
HEAD_ON_relative_to_own_ship(1) = 0; 
HEAD_ON_relative_to_SBMPC_obs(1,:) = [0,0]; 

%I DON'T THINK I WILL USE ROLE AND HEAD ON OBS FOR NORMAL OBSTACLES.


% obs 2
% % initial_obstacle_ship_states(:,2) = [100;100;0*deg2rad;5;0;0];
% % waypoints_obstacle_ships(:,:,2)   = [100, 100;    %obstacle ship 2 waypoints 
% %                                     5100, 100];    
% %                                %WHEN DONE TESTING, FIRST WAYPOINT CAN BE SUBSTITUTED BY INITIAL OBS POSITION
% % obs_speed_between_waypoints(2,:) =  [5];
% ROLE_relative_to_own_ship(2) = 0;
% ROLE_relative_to_SBMPC_obs(2,:) = [0]; 
% HEAD_ON_relative_to_own_ship(2) = 0; 
% HEAD_ON_relative_to_SBMPC_obs(2,:) = [0]; 




%% SBMPC obstacle ships



%NB!!!!!!!  SBMPC OBSTACLE SHIP MUST FOLLOW STRAIGHT PATH BETWEEN 2 WAYPOINTS IN ORDER TO MAKE THE TRAJ PREDICTION "SBMPC obstacles: own-ship trajectory prediction" WORK!!

number_of_SBMPC_obstacle_ships = 2;
total_number_of_obstacle_ships = number_of_SBMPC_obstacle_ships + number_of_obstacle_ships;
num_SBMPC_obs_ship_waypoints = num_obs_ship_waypoints;


% SBMPC obs 1
initial_SBMPC_obstacle_ship_states(:,1) = [0;-2500;90*deg2rad;5;0;0]; %[x, y, psi, u, v, r]
waypoints_SBMPC_obstacle_ships(:,:,1) = [ 0, -2500;   %obstacle ship 1 waypoints [ 3000, 3000;   %obstacle ship 1 waypoints
                                          0,  4500];
SBMPC_obs_speed_between_waypoints(1,:) =  [5];  
ROLE_SBMPC_relative_to_own_ship(1) = 1;
ROLE_SBMPC_relative_to_SBMPC_obs(1,:) = [-1,1];  %role SB obs 1 has relative to SB obs 1,2,3,4, ...        %1 element if total 2 sbmpc obs, 2 element vector if total 3 sbmpc obs ships.
                                              %NB!!!!!! role relative to self is -1 (invalid)
                                                
HEAD_ON_SBMPC_relative_to_own_ship(1) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(1,:) = [-1,0];  % 1 if sbmpc obs is head on realtive to SBMPC obs 1,2,3,4,....
                                                 %NB!!! head on relative to self is - 1(invalid)
 
% 
% 
% SBMPC obs 2
initial_SBMPC_obstacle_ship_states(:,2) = [-1767;1767;-45*deg2rad;5;0;0];
waypoints_SBMPC_obstacle_ships(:,:,2)   = [-1767, 1767;    %obstacle ship 2 waypoints 
                                           3182, -3182];    
                               
SBMPC_obs_speed_between_waypoints(2,:) =  [5];
ROLE_SBMPC_relative_to_own_ship(2) = 0;
ROLE_SBMPC_relative_to_SBMPC_obs(2,:) = [0,-1];   %%role SB obs 2 has relative to SB obs 1,3,4, ...
HEAD_ON_SBMPC_relative_to_own_ship(2) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(2,:) = [0,-1]; 



HEAD_ON_realtive_to_own_ship_module = [HEAD_ON_relative_to_own_ship, HEAD_ON_SBMPC_relative_to_own_ship];
HEAD_ON_relative_to_SBMPC_obs_module = [HEAD_ON_os_relative_to_SBMPC_obs; HEAD_ON_relative_to_SBMPC_obs];
ROLE_realtive_to_own_ship_module = [ROLE_relative_to_own_ship, ROLE_SBMPC_relative_to_own_ship];
ROLE_relative_to_SBMPC_obs_module = [ROLE_os_relative_to_SBMPC_obs; ROLE_relative_to_SBMPC_obs];





%% static obstacles
num_boundary_obstacles = 0;
num_circle_obstacles = 0;

boundary_obstacles_params = [400, -600, -400, 400]; %[start_x, start_y, end_x, end_y]. One row for each obstacle!!
circle_obstacle_params    = [450, 0, 1500];          %[radius, center_x, center_y].     One row for each obstacle!!