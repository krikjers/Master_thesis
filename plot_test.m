%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
close all;



own_vessel_y = own_vessel_state(:,2);
own_vessel_x = own_vessel_state(:,1);
s = size(seconds);

obstacle_ships_y = zeros(number_of_SBMPC_obstacle_ships, s(1));
obstacle_ships_x = zeros(number_of_SBMPC_obstacle_ships, s(1));  %%one row r is a vector of x posiitons for obstacle ship r

SBMPC_obstacle_ships_y = zeros(number_of_SBMPC_obstacle_ships, s(1));
SBMPC_obstacle_ships_x = zeros(number_of_SBMPC_obstacle_ships, s(1)); 

for i = 1:number_of_obstacle_ships
    obstacle_ships_y(i,:) = reshape(obstacle_ships_positions(i,2,:), s(1),1);
    obstacle_ships_x(i,:) = reshape(obstacle_ships_positions(i,1,:), s(1),1);
end

for i=1:number_of_SBMPC_obstacle_ships
    SBMPC_obstacle_ships_y(i,:) = reshape(SBMPC_obstacle_ships_positions(i,2,:), s(1),1);
    SBMPC_obstacle_ships_x(i,:) = reshape(SBMPC_obstacle_ships_positions(i,1,:), s(1),1);
end



distance_to_normal_obs = zeros(number_of_obstacle_ships, s(1)); % one row for each obstacle contaisn distance for all seconds in simulation time.
for i=1:number_of_obstacle_ships
    distance_to_normal_obs(i,:) = sqrt( (own_vessel_x - obstacle_ships_x(i,:)').^2 + (own_vessel_y - obstacle_ships_y(i,:)').^2 );
end

distance_to_SBMPC_obs = zeros(number_of_SBMPC_obstacle_ships, s(1));
for i=1:number_of_SBMPC_obstacle_ships 
    distance_to_SBMPC_obs(i,:) = sqrt( (own_vessel_x - SBMPC_obstacle_ships_x(i,:)').^2 + (own_vessel_y - SBMPC_obstacle_ships_y(i,:)').^2 );
end

total_distance = [distance_to_normal_obs; distance_to_SBMPC_obs];
min_distance = min(total_distance(:));
[obstacle_ship_index,time_of_min_distance] = find(total_distance==min_distance);  %NB! if two vessels have same distance from own ship, "obstacle_ship_index" and "time_of_min_distance" are vectors of 2 elements.
first_stop_time = round(time_stop/5);
second_stop_time = time_of_min_distance(1);
third_stop_time = time_stop;


figure('DefaultAxesFontSize',14);
axis equal


subplot(2,3,1);
axis equal;
hold on;
plot(own_vessel_y(1:first_stop_time), own_vessel_x(1:first_stop_time), 'b');
plot(own_vessel_y(first_stop_time), own_vessel_x(first_stop_time), 'b-O');
for i=1:number_of_obstacle_ships
    plot(obstacle_ships_y(i,1:first_stop_time), obstacle_ships_x(i,1:first_stop_time), 'r');
    plot(obstacle_ships_y(i,first_stop_time), obstacle_ships_x(i,first_stop_time), 'r-O');
end 
for i=1:number_of_SBMPC_obstacle_ships
    plot(SBMPC_obstacle_ships_y(i,1:first_stop_time), SBMPC_obstacle_ships_x(i,1:first_stop_time), 'm');
    plot(SBMPC_obstacle_ships_y(i,first_stop_time), SBMPC_obstacle_ships_x(i,first_stop_time), 'm-O');
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

subplot(2,3,2);
axis equal;
hold on;
plot(own_vessel_y(1:second_stop_time), own_vessel_x(1:second_stop_time), 'b');
plot(own_vessel_y(second_stop_time), own_vessel_x(second_stop_time), 'b-O');
for i=1:number_of_obstacle_ships
    plot(obstacle_ships_y(i,1:second_stop_time), obstacle_ships_x(i,1:second_stop_time), 'r');
    plot(obstacle_ships_y(i,second_stop_time), obstacle_ships_x(i,second_stop_time), 'r-O');
end 
for i=1:number_of_SBMPC_obstacle_ships
    plot(SBMPC_obstacle_ships_y(i,1:second_stop_time), SBMPC_obstacle_ships_x(i,1:second_stop_time), 'm');
    plot(SBMPC_obstacle_ships_y(i,second_stop_time), SBMPC_obstacle_ships_x(i,second_stop_time), 'm-O');
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

subplot(2,3,3);
axis equal;
hold on;
plot(own_vessel_y(1:third_stop_time), own_vessel_x(1:third_stop_time), 'b');
plot(own_vessel_y(third_stop_time), own_vessel_x(third_stop_time), 'b-O');
for i=1:number_of_obstacle_ships
    plot(obstacle_ships_y(i,1:third_stop_time), obstacle_ships_x(i,1:third_stop_time), 'r');
    plot(obstacle_ships_y(i,third_stop_time), obstacle_ships_x(i,third_stop_time), 'r-O');
end 
for i=1:number_of_SBMPC_obstacle_ships
    plot(SBMPC_obstacle_ships_y(i,1:third_stop_time), SBMPC_obstacle_ships_x(i,1:third_stop_time), 'm');
    plot(SBMPC_obstacle_ships_y(i,third_stop_time), SBMPC_obstacle_ships_x(i,third_stop_time), 'm-O');
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

subplot(2,3,4);
hold on;
plot(seconds, total_distance);
ylabel('Dist between vessels');






%Plot hazard things
figure('DefaultAxesFontSize',14);
suptitle('Own-ship module');

subplot(6,2,1);
plot(seconds, psi_ca*rad2deg);
ylabel('\psi_{ca} [deg]');


subplot(6,2,2);
plot(seconds, Pr);
ylabel('Pr');

subplot(6,2,3);
plot(seconds, psi_ca_worst*rad2deg);
ylabel('\psi_{ca} WORST [deg]');


subplot(6,2,4);
plot(seconds, Pr_worst);
ylabel('Pr WORST');


subplot(6,2,5);
plot(seconds, f_chosen);
ylabel('f ');

subplot(6,2,6);
plot(seconds, g_chosen);
ylabel('g');

subplot(6,2,7);
plot(seconds, f_worst);

ylabel('f WORST');
subplot(6,2,8);
plot(seconds, g_worst);
ylabel('g WORST');

subplot(6,2,9);
plot(seconds, chosen_scaled_mu);
xlabel('Time [s]');
ylabel('\mu scaled');

subplot(6,2,10);
plot(seconds, scaled_mu_worst);
xlabel('Time [s]');
ylabel('\mu scaled WORST');



figure('DefaultAxesFontSize',14);
suptitle('Own-ship module');

subplot(5,2,1);
plot(seconds, chosen_R);
ylabel('R best');

subplot(5,2,2);
plot(seconds, chosen_C);
ylabel('C best');


subplot(5,2,3);
plot(seconds, R_worst);
ylabel('R worst');

subplot(5,2,4);
plot(seconds, C_worst);
ylabel('C worst');



subplot(5,2,5);
plot(seconds, smallest_hazard);
ylabel('H_{small}');

subplot(5,2,6);
plot(seconds, largest_hazard);
ylabel('H_{big}');

subplot(5,2,7);
xlabel('Time [s]');
plot(seconds, g_chosen);
ylabel('g chosen');

subplot(5,2,8);
xlabel('Time [s]');
plot(seconds, g_worst);
ylabel('g worst');

% subplot(5, 2, 9);
% plot(seconds, chosen_P);
% ylabel('chosen P');

subplot(5,2,10);
plot(seconds, chosen_FC);
ylabel('chosen FC');









%% 

scenario = 7;
chosen_time = 500;
obsatcle_index = 1;

% % %Plot CLOSE
figure('DefaultAxesFontSize',14);
hold on;
grid on;
title("CLOSE test");
CLOSE_reshaped = reshape(CLOSE.signals.values(scenario,obsatcle_index,:,chosen_time+1), 1,num_prediction_time_steps);
plot( [0:T_s:T], CLOSE_reshaped);

% Plot OVERTAKEN
figure('DefaultAxesFontSize',14);
hold on;
grid on;
title("OVERTAKEN test");
OVERTAKEN_reshaped = reshape(OVERTAKEN.signals.values(scenario,obsatcle_index,:,chosen_time+1), 1,num_prediction_time_steps);
plot( [0:T_s:T], OVERTAKEN_reshaped);

%Plot STARBOARD
figure('DefaultAxesFontSize',14);
hold on;
grid on;
title("STARBOARD test");
STARBOARD_reshaped = reshape(STARBOARD.signals.values(scenario,obsatcle_index,:,chosen_time+1), 1,num_prediction_time_steps);
plot( [0:T_s:T], STARBOARD_reshaped);

% %Plot HEAD_ON
% figure('DefaultAxesFontSize',14);
% hold on;
% grid on;
% title("HEAD_ON test");
% HEAD_ON_reshaped = reshape(HEAD_ON.signals.values(scenario,obsatcle_index,:,chosen_time+1), 1,num_prediction_time_steps);
% plot( [0:T_s:T], HEAD_ON_reshaped);

%Plot CROSSED
figure('DefaultAxesFontSize',14);
hold on;
grid on;
title("CROSSED test");
CROSSED_reshaped = reshape(CROSSED.signals.values(scenario,obsatcle_index,:,chosen_time+1), 1,num_prediction_time_steps);
plot( [0:T_s:T], CROSSED_reshaped);


%Plot mu
figure('DefaultAxesFontSize',14);
hold on;
grid on;
title("\mu test");
mu_reshaped = reshape(mu.signals.values(scenario,obsatcle_index,:,chosen_time+1), 1,num_prediction_time_steps);
plot( [0:T_s:T], mu_reshaped);
