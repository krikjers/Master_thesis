scenario_name = 'head_on_w_changing_normal_ship';

%% Own ship
eta_initial = [-3500;0;0];      %[x, y, psi (rad)]
nu_initial  = [5;0;0];          %[u,v,r]
initial_state = [eta_initial;nu_initial];
waypoints_own_ship = [ -3500,  0;
                      10000,   0]; 
                  


ROLE_os_relative_to_SBMPC_obs(1,:) = [0];  %role value of 1 means that  os is give way vessel relative to sbmpc obs i
HEAD_ON_os_relative_to_SBMPC_obs(1,:) = [0]; 



%% Normal obstacles ships (without SBMPC)
number_of_obstacle_ships = 1;

num_obs_ship_waypoints = 3;

% obs 1
initial_obstacle_ship_states(:,1) = [4500;0;-180*deg2rad;5;0;0]; %[x, y, psi, u, v, r]
waypoints_obstacle_ships(:,:,1)   = [ 4500, 0;    %obstacle ship 1 waypoints
                                    1500,0;
                                    -2000, 2000];
obs_speed_between_waypoints(1,:) =  [5,5];
changing_obs(1) = 1;
ROLE_relative_to_own_ship(1) = 0;
ROLE_relative_to_SBMPC_obs(1,:) = [0]; 
HEAD_ON_relative_to_own_ship(1) = 0; 
HEAD_ON_relative_to_SBMPC_obs(1,:) = [0]; 

%I DON'T THINK I WILL USE ROLE AND HEAD ON OBS FOR NORMAL OBSTACLES.


% obs 2
% % initial_obstacle_ship_states(:,2) = [100;100;0*deg2rad;5;0;0];
% % waypoints_obstacle_ships(:,:,2)   = [100, 100;    %obstacle ship 2 waypoints 
% %                                     5100, 100];    
% %                                %WHEN DONE TESTING, FIRST WAYPOINT CAN BE SUBSTITUTED BY INITIAL OBS POSITION
% % obs_speed_between_waypoints(2,:) =  [5];
%changing_obs(2) = 1;
% ROLE_relative_to_own_ship(2) = 0;
% ROLE_relative_to_SBMPC_obs(2,:) = [0]; 
% HEAD_ON_relative_to_own_ship(2) = 0; 
% HEAD_ON_relative_to_SBMPC_obs(2,:) = [0]; 




%% SBMPC obstacle ships



%NB!!!!!!!  SBMPC OBSTACLE SHIP MUST FOLLOW STRAIGHT PATH BETWEEN 2 WAYPOINTS IN ORDER TO MAKE THE TRAJ PREDICTION "SBMPC obstacles: own-ship trajectory prediction" WORK!!

number_of_SBMPC_obstacle_ships = 1;
total_number_of_obstacle_ships = number_of_SBMPC_obstacle_ships + number_of_obstacle_ships;
num_SBMPC_obs_ship_waypoints = num_obs_ship_waypoints;


% SBMPC obs 1
initial_SBMPC_obstacle_ship_states(:,1) = [-5000;-5000;-180*deg2rad;5;0;0]; %[x, y, psi, u, v, r]
waypoints_SBMPC_obstacle_ships(:,:,1) = [ -5000, -5000;   %obstacle ship 1 waypoints [ 3000, 3000;   %obstacle ship 1 waypoints
                                          -10000,-5000;
                                        -10000, -5000];
SBMPC_obs_speed_between_waypoints(1,:) =  [5,5];
ROLE_SBMPC_relative_to_own_ship(1) = 1;
ROLE_SBMPC_relative_to_SBMPC_obs(1,:) = [-1]; 
HEAD_ON_SBMPC_relative_to_own_ship(1) = 1; 
HEAD_ON_SBMPC_relative_to_SBMPC_obs(1,:) = [-1]; 

% 
% 
% 
% SBMPC obs 2
% initial_SBMPC_obstacle_ship_states(:,2) = [100;100;0*deg2rad;5;0;0];
% waypoints_SBMPC_obstacle_ships(:,:,2)   = [100,  100;    %obstacle ship 2 waypoints 
%                                            7100, 100];    
%                                %WHEN DONE TESTING, FIRST WAYPOINT CAN BE SUBSTITUTED BY INITIAL OBS POSITION
% SBMPC_obs_speed_between_waypoints(2,:) =  [5];
%ROLE_SBMPC_relative_to_own_ship(2) = 0;
%%%%%%%ROLE_SBMPC_relative_to_SBMPC_obs(2,:) = [0]; 
%HEAD_ON_SBMPC_relative_to_own_ship(2) = 0; 
%%%%%%HEAD_ON_SBMPC_relative_to_SBMPC_obs(2,:) = [0]; 



HEAD_ON_realtive_to_own_ship_module = [HEAD_ON_relative_to_own_ship, HEAD_ON_SBMPC_relative_to_own_ship];
HEAD_ON_relative_to_SBMPC_obs_module = [HEAD_ON_os_relative_to_SBMPC_obs; HEAD_ON_relative_to_SBMPC_obs];
ROLE_realtive_to_own_ship_module = [ROLE_relative_to_own_ship, ROLE_SBMPC_relative_to_own_ship];
ROLE_relative_to_SBMPC_obs_module = [ROLE_os_relative_to_SBMPC_obs; ROLE_relative_to_SBMPC_obs];



%% static obstacles
num_boundary_obstacles = 0;
num_circle_obstacles = 0;

boundary_obstacles_params = [400, -600, -400, 400]; %[start_x, start_y, end_x, end_y]. One row for each obstacle!!
circle_obstacle_params    = [450, 0, 1500];          %[radius, center_x, center_y].     One row for each obstacle!!