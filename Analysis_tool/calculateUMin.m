function [ U_min ] = calculateUMin( t_maneuver, t_cpa, U)

if (t_maneuver > t_cpa)
    %obstacle_ships_U_min(obstacle_index) = min(obstacle_ships_U(obstacle_index,1:t_cpa(obstacle_index)));
    disp(["ERROR!!!!! t_maneuver > t_cpa "]);
else
    U_min = min(U(t_maneuver:t_cpa));
end

end

