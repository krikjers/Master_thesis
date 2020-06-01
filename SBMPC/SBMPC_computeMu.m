function [CLOSE,d_0, OVERTAKEN, STARBOARD,HEAD_ON,CROSSED, mu ] = SBMPC_computeMu(CLOSE_init,OVERTAKEN_init,STARBOARD_init,HEAD_ON_init,CROSSED_init,mu_init,d_0_init, scenario_index, obstacle_ship_index, t, own_ship_x_predicted, own_ship_speed,own_ship_heading_predicted, obstacle_ships_x_predicted, own_ship_y_predicted, obstacle_ships_y_predicted, obstacle_ship_speed, V_0, V_i, phi_overtaken,phi_head_on,phi_ahead,phi_crossed, d_cl)
    % t is prediction_time_step
    CLOSE = CLOSE_init; %3D matrix, 1. dim: scenario, 2. dim: obstacle, 3. dim: prediction horizon time step.
    OVERTAKEN = OVERTAKEN_init;
    STARBOARD = STARBOARD_init;
    HEAD_ON = HEAD_ON_init;
    CROSSED = CROSSED_init;
    mu = mu_init;
    d_0 = d_0_init;  %3D matrix. distance between own ship and obstacle ship i at time t in scenario k. 1. dim: scenario, 2. dim: obstacle, 3. dim: prediction horizon time step

    
    %%% CLOSE
    d_0(scenario_index, obstacle_ship_index, t) = sqrt((own_ship_x_predicted(t,scenario_index) - obstacle_ships_x_predicted(t,obstacle_ship_index))^2 ...
                                                    +  (own_ship_y_predicted(t,scenario_index) - obstacle_ships_y_predicted(t,obstacle_ship_index))^2);                   
    if (d_0(scenario_index, obstacle_ship_index, t) <= d_cl(obstacle_ship_index))
        CLOSE(scenario_index, obstacle_ship_index, t) = 1;
    else
        CLOSE(scenario_index, obstacle_ship_index, t) = 0;
    end % end if

    %%%% OVERTAKEN                  
    %equation 5 in johansen
    if (CLOSE(scenario_index, obstacle_ship_index, t) == 1 && obstacle_ship_speed > own_ship_speed && dot(V_0, V_i) > cos(phi_overtaken)*norm(V_0)*norm(V_i))
        OVERTAKEN(scenario_index, obstacle_ship_index, t) = 1;
    else
        OVERTAKEN(scenario_index, obstacle_ship_index, t) = 0;
    end % end if

    %%%% STARBOARD
    L = [ obstacle_ships_x_predicted(t,obstacle_ship_index) - own_ship_x_predicted(t,scenario_index) , obstacle_ships_y_predicted(t,obstacle_ship_index) - own_ship_y_predicted(t,scenario_index) ];
    L_unit_vector = L/norm(L);
    L_angle = atan2(  (obstacle_ships_y_predicted(t,obstacle_ship_index) - own_ship_y_predicted(t,scenario_index)) , (obstacle_ships_x_predicted(t,obstacle_ship_index) - own_ship_x_predicted(t,scenario_index))  );

    if (L_angle > own_ship_heading_predicted(t,scenario_index))
        STARBOARD(scenario_index, obstacle_ship_index, t) = 1;
    else
        STARBOARD(scenario_index, obstacle_ship_index, t) = 0;
    end
    %rad2deg = 180/pi;
    %L_angle_deg = L_angle*rad2deg;
    %L_angle_deg_converted_to_positive =  mod((L_angle_deg + 360), 360);
    %L_angle_mapped = L_angle_deg_converted_to_positive*deg2rad;  %map negative angles to positive angles.

    %%%% HEAD_ON
    head_on_condition = false;
    if ( dot(V_0, V_i) < -cos(phi_head_on)*norm(V_0)*norm(V_i) && dot(V_0, L_unit_vector) > cos(phi_ahead)*norm(V_0) ) 
        head_on_condition = true ; %equation 6-7 in johansen paper 
    end% end if

    if (CLOSE(scenario_index, obstacle_ship_index, t) == 1 && norm(V_i) ~= 0 && head_on_condition == true )
        HEAD_ON(scenario_index, obstacle_ship_index, t) = 1;
    else
        HEAD_ON(scenario_index, obstacle_ship_index, t) = 0;
    end % end if

    %%%% CROSSED
    %POSSIBILITY: aADD THAT L  MUST BE IN [-90 + own ship heading,90 + own ship heading] COMPARED TO JOHANSEN. this is added to make sure that the obs ship is 
    
    deg2rad = pi/180;

    if (CLOSE(scenario_index, obstacle_ship_index, t) == 1 && dot(V_0, V_i) < cos(phi_crossed)*norm(V_0)*norm(V_i))
        CROSSED(scenario_index, obstacle_ship_index, t) = 1;
    else
        CROSSED(scenario_index, obstacle_ship_index, t) = 0;
    end % end if

    %%%% RULE14    
    if (CLOSE(scenario_index, obstacle_ship_index, t) == 1 && STARBOARD(scenario_index, obstacle_ship_index, t) == 1 && HEAD_ON(scenario_index, obstacle_ship_index, t) == 1 )
        RULE14 = true;
    else
        RULE14 = false;
    end % end if

    %%%% RULE15   
    if (CLOSE(scenario_index, obstacle_ship_index, t) == 1 && STARBOARD(scenario_index, obstacle_ship_index, t) == 1 && CROSSED(scenario_index, obstacle_ship_index, t) == 1 && OVERTAKEN(scenario_index, obstacle_ship_index, t)== 0 )
        RULE15 = true;
    else
         RULE15 = false;
    end % end if

    %%%% mu
    if (RULE14 || RULE15)
        mu(scenario_index, obstacle_ship_index, t) = 1;
    else
        mu(scenario_index, obstacle_ship_index, t) = 0;
    end % end if          
end

