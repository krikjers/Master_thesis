function [ S_cpa, S_tcpa, num_times_cpa_alarm_is_on, num_times_tcpa_alarm_is_on, max_cpa_alarm_duration, max_tcpa_alarm_duration] = alarmsMetrics( num_seconds, obs_x, obs_y, obs_U, obs_psi, x, y, U, psi, L_cpa, L_tcpa, gamma_nto_cpa, gamma_nto_tcpa,gamma_duration_cpa, gamma_duration_tcpa, real_t_cpa, L_tcpa_upper_limit, L_cpa_upper_limit)

num_times_tcpa_alarm_is_on = 0;
num_times_cpa_alarm_is_on  = 0;
t_cpa_start  = 0;
t_tcpa_start = 0;
cpa_alarm  = false; %start at false
tcpa_alarm = false; %start at false

max_cpa_alarm_duration  = 0;
max_tcpa_alarm_duration = 0;

t_cpa_end = -1;
t_tcpa_end = -1;

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

        
        if (r_cpa < L_cpa && tcpa < L_tcpa_upper_limit && cpa_alarm == false)
            t_cpa_start = t;
            cpa_alarm = true;
           
            num_times_cpa_alarm_is_on = num_times_cpa_alarm_is_on + 1;
        end % end if
        
        if(tcpa < L_tcpa && r_cpa < L_cpa_upper_limit && tcpa_alarm == false)
            t_tcpa_start = t;
            tcpa_alarm = true;
            num_times_tcpa_alarm_is_on = num_times_tcpa_alarm_is_on +1;
        end
               
        
        if (r_cpa > L_cpa && cpa_alarm == true)
           cpa_alarm = false;
           t_cpa_end = t;
           max_cpa_alarm_duration = max(max_cpa_alarm_duration, (t_cpa_end - t_cpa_start));
           
        end
        if (tcpa > L_tcpa && tcpa_alarm == true)
            tcpa_alarm = false;
            t_tcpa_end = t;
            max_tcpa_alarm_duration = max(max_tcpa_alarm_duration, (t_tcpa_end - t_tcpa_start));
        end
        

end % end for t

if (cpa_alarm == true)
    max_cpa_alarm_duration = max(max_cpa_alarm_duration, (t - t_cpa_start));
end

if (tcpa_alarm == true)
    max_tcpa_alarm_duration = max(max_tcpa_alarm_duration, (t - t_tcpa_start));
end

% % if (num_times_cpa_alarm_is_on == 0)
% %     max_cpa_alarm_duration = 0;
% % end
% % if (num_times_tcpa_alarm_is_on == 0)
% %     max_tcpa_alarm_duration = 0;
% % end

S_cpa  = max(0, 1 - gamma_nto_cpa*num_times_cpa_alarm_is_on   - gamma_duration_cpa*(max_cpa_alarm_duration/num_seconds));
S_tcpa = max(0, 1 - gamma_nto_tcpa*num_times_tcpa_alarm_is_on - gamma_duration_tcpa*(max_tcpa_alarm_duration/num_seconds));



end

