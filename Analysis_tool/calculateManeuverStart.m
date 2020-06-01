function [ t_maneuver, r_maneuver  ] = calculateManeuverStart( t_detect, own_vessel_psi, epsilon_psi, own_vessel_u, epsilon_U, distance_to_obstacle,total_number_of_obstacle_ships, seconds  )
%output: 
%t_maneuver = time when maneuver start, 
%r_maneuver = distance to obs when manevuer start.
% -> they are found from the start time t_detect!!!!!!!

r_maneuver_update = true;
t_maneuver = -1;
r_maneuver = -1;
for t = t_detect:length(seconds)  
    if( r_maneuver_update == true && abs( own_vessel_psi(t_detect) - own_vessel_psi(t) ) >=  epsilon_psi  || abs( own_vessel_u(t_detect) - own_vessel_u(t) ) >= epsilon_U )
        t_maneuver = t;
        r_maneuver = distance_to_obstacle(t_maneuver);
        r_maneuver_update = false;
        break;
    end     
end




end

