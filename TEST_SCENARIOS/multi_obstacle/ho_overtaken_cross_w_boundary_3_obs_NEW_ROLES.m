scenario_name = 'ho_overtaken_cross_w_boundary_3_obs_NEW_ROLES';

%% Own ship
eta_initial = [-3000;0;0];      %[x, y, psi (rad)]
nu_initial  = [4;0;0];          %[u,v,r]
initial_state = [eta_initial;nu_initial];
waypoints_own_ship = [ -3000,  0;
                      10000,   0]; 
                  


ROLE_os_relative_to_SBMPC_obs(1,:) = [0,0];  %role value of 1 means that  os is give way vessel relative to sbmpc obs i and therefroe sbmpc obs i is stand on.
HEAD_ON_os_relative_to_SBMPC_obs(1,:) = [0,0]; 




%% Normal obstacles ships (without SBMPC)
number_of_obstacle_ships = 1;

num_obs_ship_waypoints = 2;

% obs 1
initial_obstacle_ship_states(:,1) = [2800;1500;-180*deg2rad;4;0;0]; %[x, y, psi, u, v, r
waypoints_obstacle_ships(:,:,1)   = [ 2800, 1500;    %obstacle ship 1 waypoints
                                      -5000, 1500];
obs_speed_between_waypoints(1,:) =  [4];
changing_obs(1) = 0;
ROLE_relative_to_own_ship(1) = 0;
ROLE_relative_to_SBMPC_obs(1,:) = [0,0]; 
HEAD_ON_relative_to_own_ship(1) = 0; 
HEAD_ON_relative_to_SBMPC_obs(1,:) = [0,0]; 





%% SBMPC obstacle ships



number_of_SBMPC_obstacle_ships = 2;
total_number_of_obstacle_ships = number_of_SBMPC_obstacle_ships + number_of_obstacle_ships;
num_SBMPC_obs_ship_waypoints = num_obs_ship_waypoints;

% SBMPC obs 1
initial_SBMPC_obstacle_ship_states(:,1) = [-5000;1500;0*deg2rad;4;0;0]; %[x, y, psi, u, v, r]
waypoints_SBMPC_obstacle_ships(:,:,1) =   [-5000, 1500;   %obstacle ship 1 waypoints [ 3000, 3000;   %obstacle ship 1 waypoints
                                          7000,1500];
SBMPC_obs_speed_between_waypoints(1,:) =  [4];
ROLE_SBMPC_relative_to_own_ship(1) = 0;
ROLE_SBMPC_relative_to_SBMPC_obs(1,:) = [-1, 0]; 
HEAD_ON_SBMPC_relative_to_own_ship(1) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(1,:) = [-1, 0]; 




% SBMPC obs 2
initial_SBMPC_obstacle_ship_states(:,2) = [2000;-2000;110*deg2rad;2;0;0];
waypoints_SBMPC_obstacle_ships(:,:,2)   = [2000 ,  -2000;    %obstacle ship 2 waypoints 
                                            -565, 5050];    
                               %WHEN DONE TESTING, FIRST WAYPOINT CAN BE SUBSTITUTED BY INITIAL OBS POSITION
SBMPC_obs_speed_between_waypoints(2,:) =  [2];
ROLE_SBMPC_relative_to_own_ship(2) = 0;
ROLE_SBMPC_relative_to_SBMPC_obs(2,:) = [0, -1]; 
HEAD_ON_SBMPC_relative_to_own_ship(2) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(2,:) = [0, -1]; 




%%%NB!!!!!!! currently not implemented role and head on value for an sbmpc obs relative to other sbmpc obs.
HEAD_ON_realtive_to_own_ship_module = [HEAD_ON_relative_to_own_ship, HEAD_ON_SBMPC_relative_to_own_ship];
HEAD_ON_relative_to_SBMPC_obs_module = [HEAD_ON_os_relative_to_SBMPC_obs; HEAD_ON_relative_to_SBMPC_obs];
ROLE_realtive_to_own_ship_module = [ROLE_relative_to_own_ship, ROLE_SBMPC_relative_to_own_ship];
ROLE_relative_to_SBMPC_obs_module = [ROLE_os_relative_to_SBMPC_obs; ROLE_relative_to_SBMPC_obs];



%% static obstacles
num_boundary_obstacles = 1;
num_circle_obstacles = 0;

boundary_obstacles_params = [-3000, -1500, 0, 1000]; %[start_x, start_y, end_x, end_y]. One row for each obstacle!!
circle_obstacle_params    = [450, 0, 1500];          %[radius, center_x, center_y].     One row for each obstacle!!