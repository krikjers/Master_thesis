function [ N ] = findNumberOfCloseVesselsAtStart( own_vessel_x, own_vessel_y, obstacle_ships_X, obstacle_ships_Y, total_number_of_obstacle_ships, d_cl )

N = 0;
for i = 1:total_number_of_obstacle_ships
    distance = sqrt( (own_vessel_x(1) - obstacle_ships_X(i, 1))^2 + (own_vessel_y(1) - obstacle_ships_Y(i,1))^2);
    if (distance < d_cl(i))
        N = N + 1;
    end
end



end

