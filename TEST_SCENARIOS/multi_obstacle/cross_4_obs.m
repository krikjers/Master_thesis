scenario_name = 'cross_4_obs';

%% Own ship
eta_initial = [-3500;0;0*deg2rad];      %[x, y, psi (rad)]
nu_initial  = [5;0;0];          %[u,v,r]
initial_state = [eta_initial;nu_initial];
waypoints_own_ship = [ -3500, -0;
                      6000,   0]; 
                  


ROLE_os_relative_to_SBMPC_obs(1,:) = [1,0,0];  %role value of 1 means that  os is give way vessel relative to sbmpc obs i and therefroe sbmpc obs i is stand on.
HEAD_ON_os_relative_to_SBMPC_obs(1,:) = [0,0,0]; 



%% Normal obstacles ships (without SBMPC)
number_of_obstacle_ships = 1;

num_obs_ship_waypoints = 2;

% obs 1
initial_obstacle_ship_states(:,1) = [-1700;-4300;90*deg2rad;5;0;0]; %[x, y, psi, u, v, r]
waypoints_obstacle_ships(:,:,1)   = [ -1700, -4300;    %obstacle ship 1 waypoints
                                      -1700, 5000];
obs_speed_between_waypoints(1,:) =  [5];
changing_obs(1) = 0;
ROLE_relative_to_own_ship(1) = 0;
ROLE_relative_to_SBMPC_obs(1,:) = [0,0,0]; 
HEAD_ON_relative_to_own_ship(1) = 0; 
HEAD_ON_relative_to_SBMPC_obs(1,:) = [0,0,0]; 



%% SBMPC obstacle ships



%NB!!!!!!!  SBMPC OBSTACLE SHIP MUST FOLLOW STRAIGHT PATH BETWEEN 2 WAYPOINTS IN ORDER TO MAKE THE TRAJ PREDICTION "SBMPC obstacles: own-ship trajectory prediction" WORK!!

number_of_SBMPC_obstacle_ships = 3;
total_number_of_obstacle_ships = number_of_SBMPC_obstacle_ships + number_of_obstacle_ships;
num_SBMPC_obs_ship_waypoints = num_obs_ship_waypoints;


% SBMPC obs 1
initial_SBMPC_obstacle_ship_states(:,1) = [1000;3500;-90*deg2rad;5;0;0]; %[x, y, psi, u, v, r]
waypoints_SBMPC_obstacle_ships(:,:,1) = [ 1000, 3500;   %obstacle ship 1 waypoints [ 3000, 3000;   %obstacle ship 1 waypoints
                                          1000,  -9000];
SBMPC_obs_speed_between_waypoints(1,:) =  [5];  
ROLE_SBMPC_relative_to_own_ship(1) = 0;
ROLE_SBMPC_relative_to_SBMPC_obs(1,:) = [-1,1,1];  %role SB obs 1 has relative to SB obs 1,2,3,4, ...        %1 element if total 2 sbmpc obs, 2 element vector if total 3 sbmpc obs ships.
                                              %NB!!!!!! role relative to self is -1 (invalid)
                                                
HEAD_ON_SBMPC_relative_to_own_ship(1) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(1,:) = [-1,1,0];  % 1 if sbmpc obs is head on realtive to SBMPC obs 1,2,3,4,....
                                                 %NB!!! head on relative to self is - 1(invalid)
 
                                                 
% SBMPC obs 2
initial_SBMPC_obstacle_ship_states(:,2) = [0;-3500;90*deg2rad;5;0;0];
waypoints_SBMPC_obstacle_ships(:,:,2)   = [0,  -3500;    %obstacle ship 2 waypoints 
                                           0, 5000];    
                               %WHEN DONE TESTING, FIRST WAYPOINT CAN BE SUBSTITUTED BY INITIAL OBS POSITION
SBMPC_obs_speed_between_waypoints(2,:) =  [5];
ROLE_SBMPC_relative_to_own_ship(2) = 1;
ROLE_SBMPC_relative_to_SBMPC_obs(2,:) = [1, -1, 0]; 
HEAD_ON_SBMPC_relative_to_own_ship(2) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(2,:) = [1, -1, 0];            



% SBMPC obs 3
initial_SBMPC_obstacle_ship_states(:,3) = [2700;-2700;135*deg2rad;5;0;0];
waypoints_SBMPC_obstacle_ships(:,:,3)   = [2700, -2700;    %obstacle ship 2 waypoints 
                                           -3000, 3000];    
                               %WHEN DONE TESTING, FIRST WAYPOINT CAN BE SUBSTITUTED BY INITIAL OBS POSITION
SBMPC_obs_speed_between_waypoints(3,:) =  [5];
ROLE_SBMPC_relative_to_own_ship(3) = 0;
ROLE_SBMPC_relative_to_SBMPC_obs(3,:) = [0, 1, -1]; 
HEAD_ON_SBMPC_relative_to_own_ship(3) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(3,:) = [0, 0, -1];      



HEAD_ON_realtive_to_own_ship_module = [HEAD_ON_relative_to_own_ship, HEAD_ON_SBMPC_relative_to_own_ship];
HEAD_ON_relative_to_SBMPC_obs_module = [HEAD_ON_os_relative_to_SBMPC_obs; HEAD_ON_relative_to_SBMPC_obs];
ROLE_realtive_to_own_ship_module = [ROLE_relative_to_own_ship, ROLE_SBMPC_relative_to_own_ship];
ROLE_relative_to_SBMPC_obs_module = [ROLE_os_relative_to_SBMPC_obs; ROLE_relative_to_SBMPC_obs];





%% static obstacles
num_boundary_obstacles = 0;
num_circle_obstacles = 0;

boundary_obstacles_params = [400, -600, -400, 400]; %[start_x, start_y, end_x, end_y]. One row for each obstacle!!
circle_obstacle_params    = [450, 0, 1500];          %[radius, center_x, center_y].     One row for each obstacle!!