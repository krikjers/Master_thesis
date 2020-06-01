clearvars -except sc_sim_step
clc;
format short
format bank %2 decimals


%% Common parameters for all modules
time_step = 0.1;     %time step in simulation
time_stop = 1500;     %when to end simulation
tsamp = 1;           %how often to store state per second (NOT ode solder time step)
rad2deg = 180/pi;
deg2rad = pi/180;


%% Scenarios
cd TEST_SCENARIOS

cd single_obstacle
%head_on_w_SBMPC_obs
%head_on_w_changing_normal_ship


%crossing_w_sbmpc_obs_on_right_2
%crossing_w_changing_normal_obs_on_right_2
%crossing_w_changing_normal_obs_on_left
%crossing_w_changing_normal_obs_on_left_w_circle

%overtakes_normal_obs
%overtakes_normal_obs_w_boundary_obs
%overtaken_by_normal_obs
cd ..
cd multi_obstacle

%2 obs
%cross_mixed_w_circle
%cross_right_and_overtaken
%overtakes_and_ho_2_sbmpc_obs

% 3 obs
%%%%%%%%%%%%%ho_and_2_crossings_3_ships
%ho_overtaken_cross_w_boundary_3_obs
%ho_overtakes_sbmpc_crossing_3_mixed_obs

% 4 obs
%ho_cross_4_obs
%cross_4_obs

%plot_explanation
cd ..
cd ..


%% Parameters common for vessels
 vessel_length = 116;
 vessel_width = 25;

% Scalars for scaling damping matrix
K_sway = 100;
K_yaw = 180;

% Scalars for scaling time constants
T_k_surge = 1;
T_k_sway  = 1;
T_k_yaw   = 1.5; 

% Guidance parameters
Delta_guidance = 1000;  
radius_of_acceptance = 300; %fossen recomends this value to be 2*ship length, 
beta = 0;                   %sideslip angle

% Reference model parameters
omega_1 = 0.035;   %higher value gives faster response
omega_2 = 0.14;
omega_3 = 0.19;   
zeta_1  = 1;
zeta_2  = 1;
zeta_3 = 1;

Omega_matrix = [ omega_1   0          0;
                 0         omega_2    0;
                 0         0          omega_3];
                          
Delta_matrix = [ zeta_1    0         0;
                 0         zeta_2    0;
                 0         0         zeta_3];
            
% Vessel model parameters
psvParameters = coder.load('PSVparameters');
psvModelConfig = psvParameters.model_config;
state_dimension = 6;

% Control parameters
lambda_1    = 0.1; 
lambda_2    = 0.11;
lambda_3    = 0.1;

Lambda = diag([lambda_1 lambda_2 lambda_3]);
Kp_feedback_linearization = 1*Lambda;
kp_heading      = 0.054; 

% Force saturation 
Xmax =  450000;
Ymax =  120000; 
Nmax =  35E6;


%% own ship stuff
own_ship_reference_psi_init = eta_initial(3);

own_ship_reference_speed = nu_initial(1);


%%  Normal Obstacle ship stuff

if (number_of_obstacle_ships > 0)
    for i=1:number_of_obstacle_ships
        initial_obstacle_ship_states_dot(:,i) = [0;0;0;0;0;0]; %[x_dot, y_dot, psi_dot, u_dot, v_dot, r_dot]
    end % end for


    U_init = zeros(1, number_of_obstacle_ships);
    V_init = zeros(1, number_of_obstacle_ships);
    Psi_init = zeros(1, number_of_obstacle_ships);

    obstacle_ships_position_matrix_init = zeros(number_of_obstacle_ships, 2);   %each row r contains x and y position for obstacle ship r

    % Psi reference model for obstacle ships
    initial_reference_psi_vector = initial_obstacle_ship_states(3,:);   %row vector
    initial_desired_psi_vector = initial_reference_psi_vector;          %row vector
    x_d_vector_length_psi_reference_model = 9;
    initial_x_d_psi_matrix = zeros(x_d_vector_length_psi_reference_model, int8(number_of_obstacle_ships)); %contains x_d for obstacle ship i in column i. x_d vector is [x,y,psi, x_dot, y_dot, psi_dot, x_ddot, y_ddot, psi_ddot]
    for i=1:number_of_obstacle_ships
       x =  initial_obstacle_ship_states(1,i);
       y = initial_obstacle_ship_states(2,i);
       psi = initial_obstacle_ship_states(3,i);
       x_dot = initial_obstacle_ship_states_dot(1,i);
       y_dot = initial_obstacle_ship_states_dot(2,i);
       psi_dot = initial_obstacle_ship_states_dot(3,i);
       x_ddot = 0;
       y_ddot = 0;
       psi_ddot = 0;
       initial_x_d_psi_matrix(:,i) = [x;y;psi;x_dot;y_dot;psi_dot;x_ddot;y_ddot;psi_ddot];    
    end


    state_vector_init = zeros(number_of_obstacle_ships, 1);

    % Speed reference model for obstacle ships
    reference_speed_obstacles  = zeros(1, number_of_obstacle_ships);
    initial_reference_u_vector = zeros(1, number_of_obstacle_ships);
    for i=1:number_of_obstacle_ships
        reference_speed_obstacles(i)  = initial_obstacle_ship_states(4,i);
        initial_reference_u_vector(i) = reference_speed_obstacles(i);
    end

    initial_desired_u_vector = initial_reference_u_vector;
    x_d_vector_length_u_reference_model = 6;
    initial_x_d_u_matrix = zeros(x_d_vector_length_u_reference_model, int8(number_of_obstacle_ships));   %contains x_d for obstacle ship i in column i. x_d vector is [u,v,r, u_dot, v_dot, r_dot] 
    for i = 1:number_of_obstacle_ships
        u = initial_obstacle_ship_states(4, i);
        v = initial_obstacle_ship_states(5,i);
        r = initial_obstacle_ship_states(6,i);
        u_dot = initial_obstacle_ship_states_dot(4,i);
        v_dot = initial_obstacle_ship_states_dot(5,i);
        r_dot = initial_obstacle_ship_states_dot(6,i);
        initial_x_d_u_matrix(:,i) = [u;v;r;u_dot;v_dot;r_dot];
    end

    % Guidance for obstacle ships
    initial_next_waypoint_indexes = ones(1,number_of_obstacle_ships)*2;


    size_obstacles_wp = size(waypoints_obstacle_ships(:,:,1));
    size_obs_speed_wp = size(obs_speed_between_waypoints);
    assert(size_obs_speed_wp(2) == num_obs_ship_waypoints - 1 );
    assert(size_obs_speed_wp(1) == number_of_obstacle_ships );
    assert(size_obstacles_wp(1) == num_obs_ship_waypoints);
    assert(length(ROLE_realtive_to_own_ship_module) == number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
    assert(length(HEAD_ON_realtive_to_own_ship_module) == number_of_obstacle_ships + number_of_SBMPC_obstacle_ships); 
    size_role_SBMPC = size(ROLE_relative_to_SBMPC_obs_module);
    size_HEAD_ON_SBMPC = size(HEAD_ON_relative_to_SBMPC_obs_module);
    assert( size_role_SBMPC(1) == 1 + number_of_obstacle_ships);
    assert(size_role_SBMPC(2) == number_of_SBMPC_obstacle_ships);
    assert(size_role_SBMPC(1) == size_HEAD_ON_SBMPC(1));
    assert(size_role_SBMPC(2) == size_HEAD_ON_SBMPC(2));   
    assert(length(changing_obs) == number_of_obstacle_ships); 
    assert(length(ROLE_SBMPC_relative_to_SBMPC_obs) == number_of_SBMPC_obstacle_ships);
  
    obstacle_waypoint_matrix = waypoints_obstacle_ships;

end % end if




%% SBMPC obstacle ship stuff

SBMPC_reference_psi_init = initial_SBMPC_obstacle_ship_states(3,:);

if (number_of_SBMPC_obstacle_ships > 0)
    for i=1:number_of_SBMPC_obstacle_ships
        initial_SBMPC_obstacle_ship_states_dot(:,i) = [0;0;0;0;0;0]; %[x_dot, y_dot, psi_dot, u_dot, v_dot, r_dot]
    end % end for


    SBMPC_obstacle_ships_position_matrix_init = zeros(number_of_SBMPC_obstacle_ships, 2);   %each row r contains x and y position for obstacle ship r

    % Psi reference model for SBMPC obstacle ships
    initial_SBMPC_reference_psi_vector = initial_SBMPC_obstacle_ship_states(3,:);   %row vector
    initial_SBMPC_desired_psi_vector = initial_SBMPC_reference_psi_vector;          %row vector
    SBMPC_x_d_vector_length_psi_reference_model = 9;
    initial_SBMPC_x_d_psi_matrix = zeros(SBMPC_x_d_vector_length_psi_reference_model, int8(number_of_SBMPC_obstacle_ships)); %contains x_d for obstacle ship i in column i. x_d vector is [x,y,psi, x_dot, y_dot, psi_dot, x_ddot, y_ddot, psi_ddot]
    for i=1:number_of_SBMPC_obstacle_ships
       x =  initial_SBMPC_obstacle_ship_states(1,i);
       y =  initial_SBMPC_obstacle_ship_states(2,i);
       psi = initial_SBMPC_obstacle_ship_states(3,i);
       x_dot = initial_SBMPC_obstacle_ship_states_dot(1,i);
       y_dot = initial_SBMPC_obstacle_ship_states_dot(2,i);
       psi_dot = initial_SBMPC_obstacle_ship_states_dot(3,i);
       x_ddot = 0;
       y_ddot = 0;
       psi_ddot = 0;
       initial_SBMPC_x_d_psi_matrix(:,i) = [x;y;psi;x_dot;y_dot;psi_dot;x_ddot;y_ddot;psi_ddot];    
    end


    SBMPC_state_vector_init = zeros(number_of_SBMPC_obstacle_ships, 1);

    % Speed reference model for SBMPC obstacle ships
    reference_speed_SBMPC_obstacles  = zeros(1, number_of_SBMPC_obstacle_ships);
    initial_SBMPC_reference_u_vector = zeros(1, number_of_SBMPC_obstacle_ships);
    for i=1:number_of_SBMPC_obstacle_ships
        reference_speed_SBMPC_obstacles(i)  = initial_SBMPC_obstacle_ship_states(4,i);
        initial_SBMPC_reference_u_vector(i) = reference_speed_SBMPC_obstacles(i);
    end

    initial_SBMPC_desired_u_vector = initial_SBMPC_reference_u_vector;
    SBMPC_x_d_vector_length_u_reference_model = 6;
    initial_SBMPC_x_d_u_matrix = zeros(SBMPC_x_d_vector_length_u_reference_model, int8(number_of_SBMPC_obstacle_ships));   %contains x_d for obstacle ship i in column i. x_d vector is [u,v,r, u_dot, v_dot, r_dot] 
    for i = 1:number_of_SBMPC_obstacle_ships
        u = initial_SBMPC_obstacle_ship_states(4, i);
        v = initial_SBMPC_obstacle_ship_states(5,i);
        r = initial_SBMPC_obstacle_ship_states(6,i);
        u_dot = initial_SBMPC_obstacle_ship_states_dot(4,i);
        v_dot = initial_SBMPC_obstacle_ship_states_dot(5,i);
        r_dot = initial_SBMPC_obstacle_ship_states_dot(6,i);
        initial_SBMPC_x_d_u_matrix(:,i) = [u;v;r;u_dot;v_dot;r_dot];
    end

    % Guidance for obstacle ships
    initial_SBMPC_next_waypoint_indexes = ones(1,number_of_SBMPC_obstacle_ships)*2;

    size_obstacles_wp = size(waypoints_SBMPC_obstacle_ships(:,:,1));
    size_obs_speed_wp = size(SBMPC_obs_speed_between_waypoints);
    assert(size_obs_speed_wp(2) == num_SBMPC_obs_ship_waypoints - 1 );
    assert(size_obs_speed_wp(1) == number_of_SBMPC_obstacle_ships );
    assert(size_obstacles_wp(1) == num_SBMPC_obs_ship_waypoints);
    %assert(length(ROLE) == number_of_obstacle_ships);

    SBMPC_obstacle_waypoint_matrix = waypoints_SBMPC_obstacle_ships;  
    chosen_scenario_index_out_init = ones(1, number_of_SBMPC_obstacle_ships)*7; 
    data_out_init = zeros(1, number_of_SBMPC_obstacle_ships);
end % end if


%% SBMPC parameters

% General parameters
T_s = 0.5; % discretization interval
T   = 600;   %Prediction horizon length
propulsion_commands = [1, 0.5];
heading_angle_offset_commands = [-90, -75, -60, -45, -30, -15, 0, 15, 30, 45, 60, 75, 90]*deg2rad;
number_of_control_behaviors = length(propulsion_commands)*length(heading_angle_offset_commands);
num_prediction_time_steps = T/T_s + 1;
seconds_between_prediction = 10;


% Obstacles ships

for obs_ship_index = 1:number_of_obstacle_ships
    obstacle_ships_u_TEST(obs_ship_index) = initial_obstacle_ship_states(4, obs_ship_index);
    obstacle_ships_v_TEST(obs_ship_index) = initial_obstacle_ship_states(5, obs_ship_index);
    obstacle_ships_headings_TEST(obs_ship_index) = initial_obstacle_ship_states(3, obs_ship_index);
    obstacle_ships_x_sim_init(obs_ship_index) = initial_obstacle_ship_states(1, obs_ship_index);
    obstacle_ships_y_sim_init(obs_ship_index) = initial_obstacle_ship_states(2, obs_ship_index);
end % end for
obs_next_waypoint_indexes = ones(1,number_of_obstacle_ships)*2;


obstacle_ship_positions_sim_init = zeros(number_of_obstacle_ships,2);
for i=1:number_of_obstacle_ships
   obstacle_ship_positions_sim_init(i,1) = initial_obstacle_ship_states(1,i);
   obstacle_ship_positions_sim_init(i,2) = initial_obstacle_ship_states(2,i);
end


assert(number_of_obstacle_ships == length(obstacle_ships_u_TEST));




%%  SBMPC TUNING            
 
% Hazard computation 
phi_overtaken = 68.5*deg2rad;
phi_head_on = 22.5*deg2rad;
phi_crossed = 68.5*deg2rad;
phi_ahead = 20*deg2rad;

% f
k_Pr = 33; 
Delta_Pr = 13;  
k_psi_port = 0.65;
k_psi_starboard = 0.3; %0.4
k_Delta_psi_port = 0.55;
k_Delta_psi_starboard = 0.2; %0.3
%NB!!!!!! k_psi must be bigger than k_Delta_psi. this is necessary to make the vessel converge back to the path after R = 0.

% Role
k_role = 4.5;
L_role = 750;

% g
k_circle = 105;    %95
p_circle = 0.2;    %0.25
q_circle = 3.5;    %3
L_C = 500;
circle_safety_margin = 4*25;  

k_boundary = 95;   
p_boundary = 0.25;
q_boundary = 3;
boundary_margin = 125; %3*vessel_width; 

% C
K_coll_factor = 0.02;
K_coll = ones(1,total_number_of_obstacle_ships)*K_coll_factor; %row vector, one element for each obstacle

% R 
p = 0.5;           % p >= 1/2!!
q = 4.65;          %q >= 1!!!
r = 15;  %12
d_safe_factor = 1025;  
d_safe = ones(1,total_number_of_obstacle_ships)*d_safe_factor; %row vector, one element for each obstacle

k_FC = 275;
L_FC = 600;  %NB! L_FC MUST BE < d_safe

% mu
kappa_factor = 25;
kappa = ones(1,total_number_of_obstacle_ships)*kappa_factor;
d_cl_factor = 2500;
d_cl = ones(1,total_number_of_obstacle_ships)*d_cl_factor;



%% Obstacle prediction using intentions.

 predicted_next_waypoints_init = zeros(1,number_of_obstacle_ships);

 obstacle_ships_next_waypoints_scaled_init = zeros(1,number_of_obstacle_ships);
 
 psi = zeros(number_of_obstacle_ships, num_obs_ship_waypoints-1);  %one row for each obstacle ship
 U   = zeros(number_of_obstacle_ships, num_obs_ship_waypoints - 1);
 S   = zeros(number_of_obstacle_ships, num_obs_ship_waypoints - 1);
 T_waypoints = zeros(number_of_obstacle_ships, num_obs_ship_waypoints - 1);
 U_hat = zeros(number_of_obstacle_ships, num_prediction_time_steps);
 psi_hat = zeros(number_of_obstacle_ships, num_prediction_time_steps);
 
for obs_ship_index = 1:number_of_obstacle_ships    
    obs_i_waypoints = waypoints_obstacle_ships(:,:,obs_ship_index); 
    for a = 1:(num_obs_ship_waypoints - 1)
        y_a = obs_i_waypoints(a, 2);
        y_b = obs_i_waypoints(a+1, 2);
        x_a = obs_i_waypoints(a, 1);
        x_b = obs_i_waypoints(a+1, 1);
        
        U(obs_ship_index, a) = obs_speed_between_waypoints(obs_ship_index, a);
        psi(obs_ship_index, a) = atan2(y_b - y_a, x_b - x_a);
        S(obs_ship_index, a) = sqrt( (y_b - y_a)^2 + (x_b - x_a)^2 );        
        if (a == 1)
            T_waypoints(obs_ship_index, a) = 0;  %start at 1 due to loop in SBMPC start at t = 1
        else
            T_waypoints(obs_ship_index, a) = T_waypoints(obs_ship_index, a-1) + (S(obs_ship_index, a-1))/(U(obs_ship_index, a-1));
        end % end if   
    end % end for
    T_waypoints(obs_ship_index, num_obs_ship_waypoints) = T_waypoints(obs_ship_index, num_obs_ship_waypoints-1) + (S(obs_ship_index, num_obs_ship_waypoints-1))/(U(obs_ship_index, num_obs_ship_waypoints-1));
   
end % end for


%% Static obstacles initialization
% Boundary obstacles
if(num_boundary_obstacles == 0)
    boundary_obstacle_start_positions = [0,0];
    boundary_obstacle_end_positions   = [0,0];
    own_ship_boundary_collisions_init = 0;
    obstacle_ships_boundary_collisions_init = 0;
    boundary_obstacles_parameters = [0,0,0,0];
else
    boundary_obstacles_parameters = boundary_obstacles_params;
                                                                                                
    for i=1:num_boundary_obstacles
       boundary_obstacle_start_positions(i,:) = [boundary_obstacles_parameters(i,1), boundary_obstacles_parameters(i,2)];   % matrix where each row r contains x and y start position for obstacle r  
       boundary_obstacle_end_positions(i,:)   = [boundary_obstacles_parameters(i,3), boundary_obstacles_parameters(i,4)];   % matrix where each row r contains x and y end position for obstacle r
    end
    own_ship_boundary_collisions_init = zeros(1, num_boundary_obstacles);  % row vector of zeros, number of elements is equal to number of boundary obstacles 
    obstacle_ships_boundary_collisions_init = zeros(number_of_obstacle_ships, num_boundary_obstacles);
end


% Circle obstacles
if (num_circle_obstacles == 0)
    radius = 0;
    center_x = 0;
    center_y = 0;
    own_ship_circle_collisions_init = 0; 
    obstacle_ships_circle_collisions_init = 0;
    circle_obstacle_parameters = [0,0,0];
else
    circle_obstacle_parameters = circle_obstacle_params;
    
    radius = zeros(1,num_circle_obstacles);
    center_x = zeros(1, num_circle_obstacles);
    center_y = zeros(1, num_circle_obstacles);
    for i=1:num_circle_obstacles
        radius(i) =  circle_obstacle_parameters(i, 1);
        center_x(i) = circle_obstacle_parameters(i, 2);
        center_y(i) = circle_obstacle_parameters(i,3);
    end
    own_ship_circle_collisions_init = zeros(1, num_circle_obstacles);  %row vector
    obstacle_ships_circle_collisions_init = zeros(number_of_obstacle_ships, num_circle_obstacles);  %matrix, each row represents one obstacle ship and each column represent circile obstacle.
end

       
%% plot scenario
figure('DefaultAxesFontSize',14);
axis equal   
hold on;

plot(eta_initial(2), eta_initial(1), 'b-O');
wp = waypoints_own_ship;
s = size(waypoints_own_ship);
for a = 1:(s(1))
    plot(wp(a,2), wp(a,1), 'b-x');
end  
plot([eta_initial(2), eta_initial(2) + eta_initial(3)*50],[eta_initial(1), eta_initial(1) + eta_initial(3)*50], 'b');

for i=1:number_of_obstacle_ships
    plot(initial_obstacle_ship_states(2,i), initial_obstacle_ship_states(1,i), 'r-O');
    wp = waypoints_obstacle_ships(:,:,i);
    for a = 1:num_obs_ship_waypoints
        plot(wp(a,2), wp(a,1), 'r-x');
    end  
end
for i=1:number_of_SBMPC_obstacle_ships
   plot(initial_SBMPC_obstacle_ship_states(2,i), initial_SBMPC_obstacle_ship_states(1,i), 'm-O'); 
   wp = waypoints_SBMPC_obstacle_ships(:,:,i);
    for a = 1:num_obs_ship_waypoints
        plot(wp(a,2), wp(a,1), 'm-x');
    end  
end


if (num_circle_obstacles > 0)
    for i = 1:num_circle_obstacles
        d = radius(i)*2;
        px = center_y(i)-radius(i);
        py = center_x(i)-radius(i);
        h = rectangle('Position',[px py d d],'Curvature',[1,1]);
        daspect([1,1,1])
    end 
end
if (num_boundary_obstacles > 0)
    for i = 1:num_boundary_obstacles       
        line_start_position = boundary_obstacle_start_positions(i,:);
        start_x = line_start_position(1);
        start_y = line_start_position(2);

        line_end_position = boundary_obstacle_end_positions(i,:);
        end_x = line_end_position(1);
        end_y = line_end_position(2);
        plot([start_y end_y], [start_x end_x], 'k')   
    end
end % end if
