function [ S_alarm, num_times_alarm_is_on, max_alarm_duration] = alarmsMetricsNew( num_seconds, obs_x, obs_y, obs_U, obs_psi, x, y, U, psi, L_cpa, L_tcpa, gamma_nto_cpa, gamma_nto_tcpa,gamma_duration_cpa, gamma_duration_tcpa, real_t_cpa, L_tcpa_upper_limit, L_cpa_upper_limit, gamma_nto, gamma_duration)

%CALLED: alarmsMetricsNew( num_seconds, obstacle_ships_X(obs_index,:), obstacle_ships_Y(obs_index,:), obstacle_ships_U(obs_index,:), obstacle_ships_Psi(obs_index,:), own_vessel_x, own_vessel_y, own_vessel_u, own_vessel_psi, L_cpa, L_tcpa, gamma_nto_cpa, gamma_nto_tcpa,gamma_duration_cpa, gamma_duration_tcpa, t_cpa(obs_index), L_tcpa_upper_limit, L_cpa_upper_limit, gamma_nto, gamma_duration);


num_times_alarm_is_on = 0;

alarm_start  = 0;
alarm_end = -1;
alarm_on  = false; 

max_alarm_duration  = 0;

is_target_tracked = false;

for t = 1:(real_t_cpa-2)   %only compute up until own ship is at real cpa with obs ship. after this point in time in the scenario, r_cpa will only increase, but tcpa will remain at 1 sec. when tcpa remains at 1 sec it creates some bugs.
                           % - 2 is used because if real_t_cpa == num_seconds, it gives error
        counter = 0;
        obstacle_predicted_x = zeros(1, length((t+1):num_seconds-1));
        obstacle_predicted_y = zeros(1, length((t+1):num_seconds-1));
        own_ship_predicted_x = zeros(1, length((t+1):num_seconds-1));
        own_ship_predicted_y = zeros(1, length((t+1):num_seconds-1));
        distance_to_obstacle = zeros(1, length((t+1):num_seconds-1));
        for t_pred=(t+1):(num_seconds-1)
            counter = counter + 1;
            obstacle_predicted_x(counter) = obs_x(t) + obs_U(t)*cos(obs_psi(t))*(t_pred-t);    %vector of all x values from now until end of scenario
            obstacle_predicted_y(counter) = obs_y(t) + obs_U(t)*sin(obs_psi(t))*(t_pred-t);
            own_ship_predicted_x(counter) = x(t) + U(t)*cos(psi(t))*(t_pred-t);
            own_ship_predicted_y(counter) = y(t) + U(t)*sin(psi(t))*(t_pred-t);
            distance_to_obstacle(counter) = sqrt( (obstacle_predicted_x(counter) - own_ship_predicted_x(counter))^2 + (obstacle_predicted_y(counter) - own_ship_predicted_y(counter))^2 ); 
        end

        r_cpa = min(distance_to_obstacle);
        tcpa_vec  = find(distance_to_obstacle == r_cpa);
        tcpa = tcpa_vec(1); % find() can return more than 1 element.
        
        
        %Alarms can only be given if the target is tracked.
        if (r_cpa <= L_cpa_upper_limit && tcpa <= L_tcpa_upper_limit)
            is_target_tracked = true;
        else
            is_target_tracked = false;
        end
        
        if ( (r_cpa < L_cpa || tcpa < L_tcpa) && alarm_on == false && is_target_tracked == true)
            alarm_start = t;
            alarm_on = true;   
            num_times_alarm_is_on = num_times_alarm_is_on + 1;
        end % end if
        

        if (r_cpa > L_cpa && tcpa > L_tcpa && alarm_on == true)
           alarm_on = false;
           alarm_end = t;
           max_alarm_duration = max(max_alarm_duration, (alarm_end - alarm_start));
           
        end


end % end for t

if (alarm_on == true) 
    max_alarm_duration = max(max_alarm_duration, (t - alarm_start));
end


S_alarm  = max(0, 1 - gamma_nto*num_times_alarm_is_on   - gamma_duration*(max_alarm_duration/num_seconds));
end

