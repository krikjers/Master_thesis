scenario_name = 'ho_cross_4_obs';

%% Own ship
eta_initial = [-2400;0;0*deg2rad];      %[x, y, psi (rad)]
nu_initial  = [3;0;0];          %[u,v,r]
initial_state = [eta_initial;nu_initial];
waypoints_own_ship = [ -2400, -0;
                      6000,   0]; 
                  


ROLE_os_relative_to_SBMPC_obs(1,:) = [0];  %role value of 1 means that  os is give way vessel relative to sbmpc obs i and therefroe sbmpc obs i is stand on.
HEAD_ON_os_relative_to_SBMPC_obs(1,:) = [0]; 



%% Normal obstacles ships (without SBMPC)
number_of_obstacle_ships = 4;

num_obs_ship_waypoints = 3;

% obs 1
initial_obstacle_ship_states(:,1) = [2300;0;-180*deg2rad;3;0;0]; %[x, y, psi, u, v, r]
waypoints_obstacle_ships(:,:,1)   = [ 2300, 0;    %obstacle ship 1 waypoints
                                        -5000, 0
                                      -5000, 0];
obs_speed_between_waypoints(1,:) =  [3,3];
changing_obs(1) = 0;
ROLE_relative_to_own_ship(1) = 0;
ROLE_relative_to_SBMPC_obs(1,:) = [0]; 
HEAD_ON_relative_to_own_ship(1) = 1; 
HEAD_ON_relative_to_SBMPC_obs(1,:) = [0]; 


% % obs 2
initial_obstacle_ship_states(:,2) = [3100;100;-180*deg2rad;5;0;0];
waypoints_obstacle_ships(:,:,2)   = [3100, 100;    %obstacle ship 2 waypoints 
                                     1600, 100
                                    -2000, 2000];    
                              
obs_speed_between_waypoints(2,:) =  [5,5];
changing_obs(2) = 1;
ROLE_relative_to_own_ship(2) = 0;
ROLE_relative_to_SBMPC_obs(2,:) = [0]; 
HEAD_ON_relative_to_own_ship(2) = 0; 
HEAD_ON_relative_to_SBMPC_obs(2,:) = [0]; 


initial_obstacle_ship_states(:,3) = [500;3000;-90*deg2rad;2;0;0];
waypoints_obstacle_ships(:,:,3)   = [500, 3000;    %obstacle ship 2 waypoints 
                                     500, -5000;
                                    500, -5000];    
                              
obs_speed_between_waypoints(3,:) =  [2,2];
changing_obs(3) = 0;
ROLE_relative_to_own_ship(3) = 0;
ROLE_relative_to_SBMPC_obs(3,:) = [0]; 
HEAD_ON_relative_to_own_ship(3) = 0; 
HEAD_ON_relative_to_SBMPC_obs(3,:) = [0]; 




initial_obstacle_ship_states(:,4) = [2500;600;-180*deg2rad;3;0;0];
waypoints_obstacle_ships(:,:,4)   = [2500, 600;    %obstacle ship 2 waypoints 
                                     -5000, 600;
                                    -5000, 600];    
                              
obs_speed_between_waypoints(4,:) =  [3,3];
changing_obs(4) = 0;
ROLE_relative_to_own_ship(4) = 0;
ROLE_relative_to_SBMPC_obs(4,:) = [0]; 
HEAD_ON_relative_to_own_ship(4) = 0; 
HEAD_ON_relative_to_SBMPC_obs(4,:) = [0]; 


%% SBMPC obstacle ships



%NB!!!!!!!  SBMPC OBSTACLE SHIP MUST FOLLOW STRAIGHT PATH BETWEEN 2 WAYPOINTS IN ORDER TO MAKE THE TRAJ PREDICTION "SBMPC obstacles: own-ship trajectory prediction" WORK!!

number_of_SBMPC_obstacle_ships = 1;
total_number_of_obstacle_ships = number_of_SBMPC_obstacle_ships + number_of_obstacle_ships;
num_SBMPC_obs_ship_waypoints = num_obs_ship_waypoints;


% SBMPC obs 1
initial_SBMPC_obstacle_ship_states(:,1) = [-9000;-9000;0*deg2rad;1;0;0]; %[x, y, psi, u, v, r]
waypoints_SBMPC_obstacle_ships(:,:,1) = [ 9000, -9000;   %obstacle ship 1 waypoints [ 3000, 3000;   %obstacle ship 1 waypoints
                                            9000,  -9000;
                                            9000,  -9000];
SBMPC_obs_speed_between_waypoints(1,:) =  [1,1];  
ROLE_SBMPC_relative_to_own_ship(1) = 0;
ROLE_SBMPC_relative_to_SBMPC_obs(1,:) = [-1];  %role SB obs 1 has relative to SB obs 1,2,3,4, ...        %1 element if total 2 sbmpc obs, 2 element vector if total 3 sbmpc obs ships.
                                              %NB!!!!!! role relative to self is -1 (invalid)
                                                
HEAD_ON_SBMPC_relative_to_own_ship(1) = 0; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(1,:) = [-1];  % 1 if sbmpc obs is head on realtive to SBMPC obs 1,2,3,4,....
                                                 %NB!!! head on relative to self is - 1(invalid)
 



HEAD_ON_realtive_to_own_ship_module = [HEAD_ON_relative_to_own_ship, HEAD_ON_SBMPC_relative_to_own_ship];
HEAD_ON_relative_to_SBMPC_obs_module = [HEAD_ON_os_relative_to_SBMPC_obs; HEAD_ON_relative_to_SBMPC_obs];
ROLE_realtive_to_own_ship_module = [ROLE_relative_to_own_ship, ROLE_SBMPC_relative_to_own_ship];
ROLE_relative_to_SBMPC_obs_module = [ROLE_os_relative_to_SBMPC_obs; ROLE_relative_to_SBMPC_obs];





%% static obstacles
num_boundary_obstacles = 0;
num_circle_obstacles = 0;

boundary_obstacles_params = [400, -600, -400, 400]; %[start_x, start_y, end_x, end_y]. One row for each obstacle!!
circle_obstacle_params    = [450, 0, 1500];          %[radius, center_x, center_y].     One row for each obstacle!!