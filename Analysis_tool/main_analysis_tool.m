%% initialize
clear all;
scenario_name = 'overtakes_and_ho_2_sbmpc_obs_w_intentions';   % _w_intentions
multiple_obstacles = true; %%%%%%%%%%%%%%%%%%%%%

if (multiple_obstacles == false)
   cd single_scenario
   load(scenario_name);
   cd .. 
else
   cd multi_scenario
   load(scenario_name);
   cd ..
end




close all;
clc;
format short
format bank %2 decimals

rad2deg = 180/pi; 
deg2rad = pi/180;




seconds = t/tsamp;
num_seconds = length(seconds);

own_vessel_x   = own_vessel_state(:,1);
own_vessel_y   = own_vessel_state(:,2);
own_vessel_psi = own_vessel_state(:,3);
own_vessel_u   = own_vessel_state(:,4);
own_vessel_v   = zeros(1, num_seconds);

normal_obstacle_ships_x   = zeros(number_of_obstacle_ships, num_seconds);  %%one row r is a vector of x posiitons for obstacle ship r
normal_obstacle_ships_y   = zeros(number_of_obstacle_ships, num_seconds);
normal_obstacle_ships_psi = zeros(number_of_obstacle_ships, num_seconds);
normal_obstacle_ships_u   = zeros(number_of_obstacle_ships, num_seconds);
normal_obstacle_ships_v   = zeros(number_of_obstacle_ships, num_seconds);

SBMPC_obstacle_ships_x_   = zeros(number_of_SBMPC_obstacle_ships, num_seconds); 
SBMPC_obstacle_ships_y_   = zeros(number_of_SBMPC_obstacle_ships, num_seconds);
SBMPC_obstacle_ships_psi_ = zeros(number_of_SBMPC_obstacle_ships, num_seconds);
SBMPC_obstacle_ships_u_   = zeros(number_of_SBMPC_obstacle_ships, num_seconds);
SBMPC_obstacle_ships_v_   = zeros(number_of_SBMPC_obstacle_ships, num_seconds);

for i = 1:number_of_obstacle_ships
    normal_obstacle_ships_y(i,:)   = reshape(obstacle_ships_positions(i,2,:), num_seconds,1);
    normal_obstacle_ships_x(i,:)   = reshape(obstacle_ships_positions(i,1,:), num_seconds,1);
    normal_obstacle_ships_psi(i,:) = reshape(obstacle_ships_psi(:,i), num_seconds,1);
    normal_obstacle_ships_u(i,:)   = reshape(obstacle_ships_u(:,i), num_seconds,1);
    normal_obstacle_ships_v(i,:)   = zeros(1, num_seconds);
end

for i=1:number_of_SBMPC_obstacle_ships
    SBMPC_obstacle_ships_y_(i,:)   = reshape(SBMPC_obstacle_ships_positions(i,2,:), num_seconds,1);
    SBMPC_obstacle_ships_x_(i,:)   = reshape(SBMPC_obstacle_ships_positions(i,1,:), num_seconds,1);
    SBMPC_obstacle_ships_psi_(i,:) = reshape(SBMPC_obstacle_ships_psi(:,i), num_seconds,1);
    SBMPC_obstacle_ships_u_(i,:)   = reshape(SBMPC_obstacle_ships_u(:,i), num_seconds,1);
    SBMPC_obstacle_ships_v_(i,:)   = zeros(1, num_seconds);
end

% combine normal obs and sbmpc obs data
% data for normal obs first, then sbmpc obs

obstacle_ships_X   = [normal_obstacle_ships_x; SBMPC_obstacle_ships_x_];
obstacle_ships_Y   = [normal_obstacle_ships_y; SBMPC_obstacle_ships_y_];
obstacle_ships_Psi = [normal_obstacle_ships_psi; SBMPC_obstacle_ships_psi_];
obstacle_ships_U   = [normal_obstacle_ships_u; SBMPC_obstacle_ships_u_];
obstacle_ships_V   = [normal_obstacle_ships_v; SBMPC_obstacle_ships_v_];


beta  = zeros(1,number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
alpha = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
num_rules = 5;
rules = zeros(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships, num_rules);

S_safety = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S_r      = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S_Theta  = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P8_delay = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P8_psi_app = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P8_U_app  = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P8_app    = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P8_r = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S8   = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);

P13_ahead = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S13       = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);

P14_Theta = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S14_Theta = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P14_nst   = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S14       = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);

P15_ahead = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S15       = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);

S16       = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);

P17_Delta_psi = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P17_Delta_U   = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P17_nst       = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
P17_Delta     = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S17           = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);

S_circle = ones(1, num_circle_obstacles)*(-1);
S_boundary = ones(1, num_boundary_obstacles)*(-1);

r_cpa = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
t_cpa = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
beta_cpa  = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
alpha_cpa = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);


S_cpa  =  ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
S_tcpa =  ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
num_times_cpa_alarm_is_on  =  zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
num_times_tcpa_alarm_is_on =  zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
max_cpa_alarm_duration  =  zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
max_tcpa_alarm_duration =  zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);

S_alarm = ones(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)*(-1);
num_times_alarm_is_on = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
max_alarm_duration    = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);


t_maneuver = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
seconds_indexes = 1:length(seconds);
r_maneuver = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);

distance_to_obstacle = zeros(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships, num_seconds);

obstacle_ships_U_min = zeros(1, total_number_of_obstacle_ships);
U_t_maneuver = zeros(1,total_number_of_obstacle_ships);


%safety score
contact_angle_cut = 90*deg2rad;   %alpha_cut
relative_bearing_cut = 90*deg2rad; %beta_cut

N_close = findNumberOfCloseVesselsAtStart( own_vessel_x, own_vessel_y, obstacle_ships_X, obstacle_ships_Y, total_number_of_obstacle_ships, d_cl );

R_min1 = 1000;
R_nm1 = 600;
R_col1 = 200;
R_min2 = 750;
R_nm2 = 400;
R_col2 = 100;
R_min3 = 300;
R_nm3 = 100;
R_col3 = 75;
gamma_nm = 0.4;
gamma_col = 0.6;
r_theta = 0.8;

gamma_r = 0.65;
gamma_Theta = 0.35;



%type of collision situation
alpha_13_crit = 45*deg2rad;
alpha_14_crit = 13*deg2rad;
alpha_15_crit = 10*deg2rad;



%Rule 8 / 17
R_2 = 2250;
R_1 = 1500;
gamma8_app = 0.33;
gamma8_r = 0.33;
gamma8_delay = 0.33;
Delta_psi_app = 30*deg2rad;
Delta_psi_md = 4*deg2rad;
Delta_U_app = 0.5;
Delta_U_md = 0.2;

L_min = 300;
L_max = 750;
gamma17_nst = 0.5;
gamma17_safety   = 0.7;
gamma17_Delta    = 0.5;
gamma17_Delta_U  = 0.25;
gamma17_Delta_psi = 1.5;

gamma_psi_app = 0.7;
gamma_U_app = 0.3;


%rule 13
gamma13_ahead = 0.3;


%rule 14
gamma14_nst   = 0.4;
gamma8_psi_app = 0.27;
d_T = 100;


%rule 15
gamma15_ahead = 0.5;
T_ahead_low  = -25*deg2rad;
T_ahead_high = 165*deg2rad;


% static obstacles
R_c_min = 125;
R_c_nm  = 75;
R_c_col = 50;
gamma_c_nm  = 0.4;
gamma_c_col = 0.6;
R_b_min = 125;
R_b_nm  = 75;
R_b_col = 50;
gamma_b_nm  = 0.4;
gamma_b_col = 0.6;


%CPA/TCPA alarms
L_cpa  = R_nm2;
L_tcpa = 400; %sec

gamma_nto_cpa  = 0.25;
gamma_nto_tcpa = 0.25;
gamma_duration_cpa  = 0.4;
gamma_duration_tcpa = 0.4;

L_tcpa_upper_limit = 600;
L_cpa_upper_limit  = 3000;

gamma_nto = 0.25;
gamma_duration = 0.5;

%% analysis tool
clc;

r_c_cpa = ones(1,num_circle_obstacles )*inf;
r_b_cpa = ones(1,num_boundary_obstacles)*inf;
for t = 1:length(seconds)
    for obstacle_index = 1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
        distance_to_obstacle(obstacle_index,t) = sqrt( (obstacle_ships_X(obstacle_index, t) - own_vessel_x(t))^2 + (obstacle_ships_Y(obstacle_index, t) - own_vessel_y(t))^2 ); 
    end
    
    x_bow = own_vessel_x(t) + cos(own_vessel_psi(t))*vessel_length/2;
    y_bow = own_vessel_y(t) + sin(own_vessel_psi(t))*vessel_length/2;
    for circle_obs_index = 1:num_circle_obstacles
        circle_radius = circle_obstacle_params(circle_obs_index, 1);
        circle_x = circle_obstacle_params(circle_obs_index, 2);
        circle_y = circle_obstacle_params(circle_obs_index, 3);
        distance_to_circle = sqrt( (circle_x - x_bow)^2 + ( circle_y - y_bow)^2) - circle_radius;
        r_c_cpa(circle_obs_index) = min(r_c_cpa(circle_obs_index), distance_to_circle);
    end
    
    for boundary_obs_index = 1:num_boundary_obstacles
        start_x = boundary_obstacles_params(boundary_obs_index,1);
        start_y = boundary_obstacles_params(boundary_obs_index,2);
        end_x   = boundary_obstacles_params(boundary_obs_index,3);
        end_y   = boundary_obstacles_params(boundary_obs_index,4);        
        dist_bow_to_line = dist_from_bow_to_line(x_bow, y_bow, start_x, start_y, end_x, end_y);
        r_b_cpa(boundary_obs_index) = min(r_b_cpa, dist_bow_to_line );
    end
    
end
for obstacle_index = 1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
    r_cpa(obstacle_index) = min(distance_to_obstacle(obstacle_index,:));
    t_cpa_vector = find(distance_to_obstacle(obstacle_index,:) == r_cpa(obstacle_index));
    t_cpa(obstacle_index) = t_cpa_vector(1);
    [beta_cpa(obstacle_index), alpha_cpa(obstacle_index)] = calculateBearingAndContact( own_vessel_x(t_cpa(obstacle_index)), own_vessel_y(t_cpa(obstacle_index)), own_vessel_psi(t_cpa(obstacle_index)), obstacle_ships_X(obstacle_index, t_cpa(obstacle_index)), obstacle_ships_Y(obstacle_index, t_cpa(obstacle_index)), obstacle_ships_Psi(obstacle_index, t_cpa(obstacle_index))  );

end

epsilon_psi = 3*deg2rad;
epsilon_U = 1;
t_init = 1;



Delta_psi_abs = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
Delta_psi = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
Delta_U_max = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);
t_Delta_psi_abs = zeros(1, number_of_obstacle_ships + number_of_SBMPC_obstacle_ships);

t_detected = zeros(1, total_number_of_obstacle_ships);
r_detect   = zeros(1, total_number_of_obstacle_ships);
t = 1;



for obs_index = 1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
    if( t_detect.signals.values(1,obs_index, end) == -1 )
        t_detected(obs_index) = t_detect.signals.values(1,obs_index, end);
    else
        t_detected(obs_index) = round(t_detect.signals.values(1,obs_index, end)) + 1;  %the own ship module in the simulator stores t_detect as the time when distance between predicted obstacle pos and own ship predicted pos is < d_safe = 1025 m
                                                                  %+1 since time in simulator starts at 0.     
    end
    
    %this particular scenario had trouble with detecting correct type of
    %situation!!!!!!
    if (obs_index == 3 && ( strcmp(scenario_name,'overtakes_and_ho_2_sbmpc_obs_w_intentions' ) || strcmp(scenario_name, 'overtakes_and_ho_2_sbmpc_obs') || strcmp(scenario_name, 'overtakes_and_ho_2_sbmpc_obs_NO_ROLE_VAR') || strcmp(scenario_name, 'overtakes_and_ho_2_sbmpc_obs_NO_ROLE_VAR_w_intentions')) )
       t_detected(obs_index) = 150;  
    end
    
    if (obs_index == 2 && strcmp(scenario_name, 'cross_4_obs' ))
            t_detected(obs_index) = 1;
    end
    
    if (obs_index == 3 && (strcmp(scenario_name, 'overtakes_and_ho_2_sbmpc_obs_w_intentions' )  ||  strcmp(scenario_name, 'overtakes_and_ho_2_sbmpc_obs')   ))
            t_detected(obs_index) = 130;
    end
    
    if (obs_index == 2 && strcmp(scenario_name, 'ho_overtakes_sbmpc_crossing_3_mixed_obs_w_intentions') )
        t_detected(obs_index) = 30;
    end
    
    if(obs_index == 4 && (strcmp(scenario_name, 'ho_cross_4_obs') || strcmp(scenario_name, 'ho_cross_4_obs_w_intentions')))
       t_detected(obs_index) = 20; 
    end
    if(obs_index == 3 && (strcmp(scenario_name, 'ho_cross_4_obs') || strcmp(scenario_name, 'ho_cross_4_obs_w_intentions')))
       t_detected(obs_index) = 1; 
    end
    
    if (strcmp(scenario_name, 'plot_explanation') || strcmp(scenario_name, 'plot_explanation_w_intentions') )
       t_detected(obs_index) = 1; 
    end
    

    %t_detected(obs_index) = 1; %%%%%%%%%%%%%%%%%%%%%
    
    if ( t_detected(obs_index) ~= -1 )
        
        [ t_maneuver(obs_index), r_maneuver(obs_index)  ] = calculateManeuverStart( t_detected(obs_index), own_vessel_psi, epsilon_psi, own_vessel_u, epsilon_U, distance_to_obstacle(obs_index,:),total_number_of_obstacle_ships, seconds  );
        if(t_maneuver(obs_index) > t_cpa(obs_index))
           break;   
        end
        r_detect(obs_index) =  distance_to_obstacle(obs_index, t_detected(obs_index));

        
        if (t_maneuver(obs_index) == -1)  %NO MANEUVER WAS DETECTED
            disp("ERROR!!!!! own ship did not maneuver");
        end
   
        
        [ Delta_psi(obs_index), Delta_psi_abs(obs_index), t_Delta_psi_abs(obs_index), Delta_U_max(obs_index) ] = calculateChangeVariables( t_detected(obs_index), t_cpa(obs_index), own_vessel_psi, own_vessel_u  );
        
         % determine which rules applies
        [beta(obs_index), alpha(obs_index)] = calculateBearingAndContact( own_vessel_x(t_detected(obs_index)), own_vessel_y(t_detected(obs_index)), own_vessel_psi(t_detected(obs_index)), obstacle_ships_X(obs_index, t_detected(obs_index)), obstacle_ships_Y(obs_index, t_detected(obs_index)), obstacle_ships_Psi(obs_index, t_detected(obs_index))  );
        [rule13, rule14, rule15, rule16, rule17] = typeOfCollisionSituation( alpha(obs_index), beta(obs_index), alpha_13_crit, alpha_14_crit, alpha_15_crit, own_vessel_u(t_detected(obs_index)), obstacle_ships_U(obs_index, t_detected(obs_index)),own_vessel_x(t_detected(obs_index)), own_vessel_y(t_detected(obs_index)), obstacle_ships_X(obs_index, t_detected(obs_index)), obstacle_ships_Y(obs_index, t_detected(obs_index)), d_cl(obs_index) );
        
        if (obs_index == 2 && ( strcmp(scenario_name, 'ho_overtakes_sbmpc_crossing_3_mixed_obs') || strcmp(scenario_name, 'ho_overtakes_sbmpc_crossing_3_mixed_obs_w_intentions') ))
            rule15 = 1;
            rule16 = 1;
        end
        
        rules(obs_index, :) = [rule13, rule14, rule15, rule16, rule17];                   

        %metrics
        [S_safety(obs_index), S_r(obs_index), S_Theta(obs_index) ]  = safetyMetric( relative_bearing_cut, contact_angle_cut, beta_cpa(obs_index), alpha_cpa(obs_index), r_cpa(obs_index), R_min1, R_nm1, R_col1, R_min2, R_nm2, R_col2, R_min3, R_nm3, R_col3, gamma_nm, gamma_col, gamma_r,gamma_Theta );
        for circle_obs_index = 1:num_circle_obstacles 
           [ S_circle(circle_obs_index) ]    = staticCircleObstaclesMetric(r_c_cpa(circle_obs_index), R_c_min, R_c_nm, R_c_col, gamma_c_nm, gamma_c_col, num_circle_obstacles); 
        end

        for boundary_obs_index = 1:num_boundary_obstacles
           [ S_boundary(boundary_obs_index) ]  = staticBoundaryObstaclesMetric(r_b_cpa(boundary_obs_index), R_b_min, R_b_nm, R_b_col, gamma_b_nm, gamma_b_col, num_boundary_obstacles);
        end

        [ S_cpa(obs_index), S_tcpa(obs_index), num_times_cpa_alarm_is_on(obs_index), num_times_tcpa_alarm_is_on(obs_index), max_cpa_alarm_duration(obs_index), max_tcpa_alarm_duration(obs_index)] = alarmsMetrics( num_seconds, obstacle_ships_X(obs_index,:), obstacle_ships_Y(obs_index,:), obstacle_ships_U(obs_index,:), obstacle_ships_Psi(obs_index,:), own_vessel_x, own_vessel_y, own_vessel_u, own_vessel_psi, L_cpa, L_tcpa, gamma_nto_cpa, gamma_nto_tcpa, gamma_duration_cpa, gamma_duration_tcpa, t_cpa(obs_index), L_tcpa_upper_limit, L_cpa_upper_limit );
        [ S_alarm(obs_index), num_times_alarm_is_on(obs_index), max_alarm_duration(obs_index)] = alarmsMetricsNew( num_seconds, obstacle_ships_X(obs_index,:), obstacle_ships_Y(obs_index,:), obstacle_ships_U(obs_index,:), obstacle_ships_Psi(obs_index,:), own_vessel_x, own_vessel_y, own_vessel_u, own_vessel_psi, L_cpa, L_tcpa, gamma_nto_cpa, gamma_nto_tcpa,gamma_duration_cpa, gamma_duration_tcpa, t_cpa(obs_index), L_tcpa_upper_limit, L_cpa_upper_limit, gamma_nto, gamma_duration);

        if (rule17 == 1)
            S8(obs_index)  = -1;                                       
            S14(obs_index) = -1;
            S16(obs_index) = -1; %action by give way
            [ P17_nst(obs_index), P17_Delta_psi(obs_index), P17_Delta_U(obs_index), P17_Delta(obs_index), S17(obs_index)]   = rule17Metrics( Delta_psi(obs_index), Delta_psi_md, Delta_psi_app, Delta_U_md, Delta_U_app, Delta_U_max(obs_index), own_vessel_u(1), rule15, rule17, r_maneuver(obs_index), L_min, L_max, S_safety(obs_index), gamma17_safety, gamma17_nst, gamma17_Delta, d_T, own_vessel_x, own_vessel_y, t_cpa(obs_index), own_vessel_psi(1), gamma17_Delta_U, gamma17_Delta_psi);
            [P13_ahead(obs_index), S13(obs_index)]      = rule13Metrics( rule13, rule16, rule17, S16(obs_index), S17(obs_index), gamma13_ahead, alpha_cpa(obs_index)  );                                    
            [P15_ahead(obs_index), S15(obs_index) ] = rule15Metrics( alpha_cpa(obs_index), T_ahead_low, T_ahead_high, S16(obs_index), S17(obs_index), gamma15_ahead, rule15, rule16, rule17  );    
        else
            U_t_maneuver(obs_index) = own_vessel_u(t_maneuver(obs_index));
            own_ship_U_min = calculateUMin( t_maneuver(obs_index), t_cpa(obs_index), own_vessel_u); 
            
            [P8_delay(obs_index), P8_psi_app(obs_index), P8_U_app(obs_index), P8_app(obs_index), P8_r(obs_index), S8(obs_index)] = rule8Metrics( r_maneuver(obs_index), r_detect(obs_index), Delta_psi_abs(obs_index), Delta_psi_app, Delta_psi_md, Delta_U_app, U_t_maneuver(obs_index), own_ship_U_min, gamma8_app, gamma8_r, gamma8_delay, S_r(obs_index), rule17, gamma_psi_app, gamma_U_app )   ;
            [P14_Theta(obs_index), S14_Theta(obs_index), P14_nst(obs_index), S14(obs_index) ]  = rule14Metrics( alpha_cpa(obs_index), beta_cpa(obs_index), d_T, own_vessel_x, own_vessel_y, t_maneuver(obs_index), t_cpa(obs_index), own_vessel_u(1), own_vessel_psi(1), gamma14_nst, gamma8_delay, gamma8_psi_app, P8_psi_app(obs_index), P8_delay(obs_index), rule14 );                                                                                                                                                                                                     
            [S16(obs_index) ]     = rule16Metric( S_safety(obs_index), P8_delay(obs_index), P8_app(obs_index), rule16 ); 

            
            
            
            [ P17_nst(obs_index), P17_Delta_psi(obs_index), P17_Delta_U(obs_index), P17_Delta(obs_index), S17(obs_index)]   = rule17Metrics( Delta_psi(obs_index), Delta_psi_md, Delta_psi_app, Delta_U_md, Delta_U_app, Delta_U_max(obs_index), own_vessel_u(1), rule15, rule17, r_maneuver(obs_index), L_min, L_max, S_safety(obs_index), gamma17_safety, gamma17_nst, gamma17_Delta, d_T, own_vessel_x, own_vessel_y, t_cpa(obs_index), own_vessel_psi(1), gamma17_Delta_U, gamma17_Delta_psi);
            [P13_ahead(obs_index), S13(obs_index)]      = rule13Metrics( rule13, rule16, rule17, S16(obs_index), S17(obs_index), gamma13_ahead, alpha_cpa(obs_index)  );                                                                           
            [P15_ahead(obs_index), S15(obs_index) ] = rule15Metrics( alpha_cpa(obs_index), T_ahead_low, T_ahead_high, S16(obs_index), S17(obs_index), gamma15_ahead, rule15, rule16, rule17  );       
        end
    end
    
    
end % end for



disp(scenario_name);



    disp("Static obstacles metrics: ");
    if (num_circle_obstacles > 0)
        disp(['   S_circle = ', num2str(min(S_circle))]);
    end
    if (num_boundary_obstacles > 0)
         disp(['   S_boundary = ', num2str(min(S_boundary))]);
    end

if (multiple_obstacles == false)
    for obs_index = 1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
        %Only data for detected obs ships are displyed
        if(t_detected(obs_index) ~= -1)
            disp([newline, 'Obstacle: ', num2str(obs_index), ' (t_detect = ', num2str(t_detected(obs_index)), ')']);  

            if (rules(obs_index, 1) == 1 && rules(obs_index, 5) == 1)
                disp("Own-ship is overtaken");
            elseif(rules(obs_index, 1) == 1 && rules(obs_index, 4) == 1)
                disp("Own-ship overtakes");
            elseif(rules(obs_index, 2) == 1 && rules(obs_index, 4) == 1) 
                disp("Head-on");
            elseif(rules(obs_index, 3) == 1 && rules(obs_index, 4) == 1) 
                disp("Crossing, own-ship is give-way");
            elseif(rules(obs_index, 3) == 1 && rules(obs_index, 5) == 1) 
                disp("Crossing, own-ship is stand-on");
            else
                disp("No situation");
            end

            activeCOLREGs = getActiveRulesString(rules(obs_index, :));
            disp('Active COLREGs: ');
            disp( activeCOLREGs);
            disp(['Safety:   ', 'S_safety = ', num2str(round(S_safety(obs_index),2)), newline, '   S_r = ', num2str(round(S_r(obs_index),2)), ' (r_cpa = ', num2str(r_cpa(obs_index)), ')', newline, '   S_Theta = ', num2str( round(S_Theta(obs_index),2))]);
            
            if(rules(obs_index, 5) == 0)
                disp([newline, 'Rule 8:   ', 'S8 = ', num2str(S8(obs_index)),  newline, '   P8_delay = ', num2str(P8_delay(obs_index)), newline, '   P8_psi_app = ', num2str(P8_psi_app(obs_index)), newline, '   P8_U_app = ', num2str( P8_U_app(obs_index)), newline, '   P8_app = ', num2str(P8_app(obs_index)), newline, '   P8_r = ', num2str(P8_r(obs_index))]); 
            elseif(rules(obs_index, 5) == 1)
                disp([newline, 'Rule 8:   ', 'S8 = ', num2str(S8(obs_index))]);
            end
            if (rules(obs_index, 1) == 1) 
                disp([newline, 'Rule 13:   ', 'S13 = ', num2str(S13(obs_index))    , newline, '   P13_ahead = ', num2str(P13_ahead(obs_index)), newline]);
            end
            if (rules(obs_index, 2) == 1) 
                disp([newline, 'Rule 14:   ', 'S14 = ', num2str( S14(obs_index))     , newline, '   P14_Theta = ', num2str(P14_Theta(obs_index)), newline, '   P14_nst = ', num2str(P14_nst(obs_index))]);
            end
            if (rules(obs_index, 3) == 1) 
                disp([newline, 'Rule 15:   ', 'S15 = ', num2str(S15(obs_index))    , newline, '   P15_ahead = ', num2str(P15_ahead(obs_index))]);
            end
            if (rules(obs_index, 4) == 1) 
                disp([newline, 'Rule 16:   ',    'S16 = ', num2str(S16(obs_index))]);
            end
            if (rules(obs_index, 5) == 1) 
                disp([newline, 'Rule 17:   ',  'S17 = ', num2str(S17(obs_index)), newline, '   P17_nst = ', num2str(P17_nst(obs_index)), newline, '   P17_Delta_psi = ', num2str(P17_Delta_psi(obs_index)), newline, '   P17_Delta_U = ', num2str( P17_Delta_U(obs_index)), newline, '   P17_Delta = ', num2str(P17_Delta(obs_index)), newline]);    
            end
            disp([newline, 'CPA/TCPA alarms:   ',  'S_alarms = ', num2str(S_alarm(obs_index))   , newline,   '   Num times alarm on = ', num2str(num_times_alarm_is_on(obs_index)), newline, '   Max alarm duration = ', num2str(max_alarm_duration(obs_index)) , newline, 'OLD COMPUTATION METHOD:', newline '   S_cpa = ', num2str(S_cpa(obs_index)), newline, '   S_tpca = ', num2str(S_tcpa(obs_index)) ]);

            disp("------------------------------------------");
        end

    end


elseif(multiple_obstacles == true)
    for obs_index = 1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
        if(t_detected(obs_index) ~= -1)
            disp(['Obstacle: ', num2str(obs_index), ' (t_detect = ', num2str(t_detected(obs_index)), ')']); 
            if (rules(obs_index, 1) == 1 && rules(obs_index, 5) == 1)
                disp("Own-ship is overtaken");
            elseif(rules(obs_index, 1) == 1 && rules(obs_index, 4) == 1)
                disp("Own-ship overtakes");
            elseif(rules(obs_index, 2) == 1 && rules(obs_index, 4) == 1) 
                disp("Head-on");
            elseif(rules(obs_index, 3) == 1 && rules(obs_index, 4) == 1) 
                disp("Crossing, own-ship is give-way");
            elseif(rules(obs_index, 3) == 1 && rules(obs_index, 5) == 1) 
                disp("Crossing, own-ship is stand-on");
            else
                disp("No situation");
            end
            
        activeCOLREGs = getActiveRulesString(rules(obs_index, :));
        disp('Active COLREGs: ');
        disp( activeCOLREGs);
        disp(['Safety: ', newline '   S_safety = ', num2str(round(S_safety(obs_index),2)), newline, '   S_r = ', num2str(round(S_r(obs_index),2)), ' (r_cpa = ', num2str(r_cpa(obs_index)), ')', newline, '   S_Theta = ', num2str( round(S_Theta(obs_index),2))]);
        %disp([newline, 'CPA/TCPA alarms', newline, '   S_alarms = ', num2str(S_alarm(obs_index))   , newline, '   S_cpa = ', num2str(S_cpa(obs_index)), newline, '   S_tpca = ', num2str(S_tcpa(obs_index))]);
        disp([newline, 'Rule 8: ', newline, '   P8_delay = ', num2str(P8_delay(obs_index)), newline, '   P8_psi_app = ', num2str(P8_psi_app(obs_index)), newline, '   P8_U_app = ', num2str( P8_U_app(obs_index)), newline, '   P8_app = ', num2str(P8_app(obs_index)), newline, '   P8_r = ', num2str(P8_r(obs_index)), newline,'   S8 = ', num2str(S8(obs_index)),]); 
        if(rules(obs_index, 5) == 0)
                disp([newline, 'Rule 8:  ',   'S8 = ', num2str(S8(obs_index)), newline, '   P8_delay = ', num2str(P8_delay(obs_index)), newline, '   P8_psi_app = ', num2str(P8_psi_app(obs_index)), newline, '   P8_U_app = ', num2str( P8_U_app(obs_index)), newline, '   P8_app = ', num2str(P8_app(obs_index)), newline, '   P8_r = ', num2str(P8_r(obs_index))]); 
            elseif(rules(obs_index, 5) == 1)
                disp([newline, 'Rule 8:   ', 'S8 = ', num2str(S8(obs_index))]);
            end
            if (rules(obs_index, 1) == 1) 
                disp([newline, 'Rule 13:   ', 'S13 = ', num2str(S13(obs_index)), newline, '   P13_ahead = ', num2str(P13_ahead(obs_index))]);
            end
            if (rules(obs_index, 2) == 1) 
                disp([newline, 'Rule 14:   ', 'S14 = ', num2str( S14(obs_index)) , newline, '   P14_Theta = ', num2str(P14_Theta(obs_index)), newline, '   P14_nst = ', num2str(P14_nst(obs_index))]);
            end
            if (rules(obs_index, 3) == 1) 
                disp([newline, 'Rule 15:   ', 'S15 = ', num2str(S15(obs_index)), newline, '   P15_ahead = ', num2str(P15_ahead(obs_index))]);
            end
            if (rules(obs_index, 4) == 1) 
                disp([newline, 'Rule 16:   ', 'S16 = ', num2str(S16(obs_index))]);
            end
            if (rules(obs_index, 5) == 1) 
                disp([newline, 'Rule 17:   ', 'S17 = ', num2str(S17(obs_index)), newline,  '   P17_nst = ', num2str(P17_nst(obs_index)), newline, '   P17_Delta_psi = ', num2str(P17_Delta_psi(obs_index)), newline, '   P17_Delta_U = ', num2str( P17_Delta_U(obs_index)), newline, '   P17_Delta = ', num2str(P17_Delta(obs_index))]);    
            end

        disp("------------------------------------------");    
        end

    end
end
    








analysis_plot;
