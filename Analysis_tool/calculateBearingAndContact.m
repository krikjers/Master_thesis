function [ relative_bearing, contact_angle  ] = calculateBearingAndContact( own_vessel_x, own_vessel_y, own_ship_psi, obstacle_ship_x, obstacle_ship_y, obstacle_ship_psi  )
    %input heading is assumed to be in rads
    rad2deg = 180/pi;
    deg2rad = pi/180;

    
    %CONVERT A SHIPS HEADING IS IN RANGE (-180, 180]
    
    if (own_ship_psi > 180*deg2rad )
        own_ship_psi = own_ship_psi - 360*deg2rad;
    elseif(own_ship_psi <= -180*deg2rad)
        own_ship_psi = 360*deg2rad - abs(own_ship_psi);        
    end
        
    if (obstacle_ship_psi > 180)
        obstacle_ship_psi = obstacle_ship_psi - 360*deg2rad;
    elseif(obstacle_ship_psi <= -180*deg2rad)
        obstacle_ship_psi = 360*deg2rad - abs(obstacle_ship_psi);
    end
        
    %Beta
    relative_bearing = atan2(obstacle_ship_y - own_vessel_y, obstacle_ship_x - own_vessel_x);
    if(relative_bearing == 180*deg2rad)
        relative_bearing = -180*deg2rad;
    end
    relative_bearing = relative_bearing - own_ship_psi;
    if (relative_bearing < 0)
        relative_bearing = 360*deg2rad - abs(relative_bearing);
    elseif(relative_bearing >= (360-0.5)*deg2rad) 
        relative_bearing = relative_bearing  - 360*deg2rad;       
    end
%     if (relative_bearing < 0)
%         relative_bearing = 360*deg2rad - abs(relative_bearing) - own_ship_psi;
%     else
%         relative_bearing = relative_bearing - own_ship_psi;
%     end
%     
%     if(relative_bearing >= 360*deg2rad)
%         disp(111)
%         relative_bearing = relative_bearing - 360*deg2rad;
%     end
    
    
    %Alpha
    contact_angle = atan2(own_vessel_y - obstacle_ship_y, own_vessel_x - obstacle_ship_x);
    if (contact_angle == 180*deg2rad)
        contact_angle = -180*deg2rad;
    end
    contact_angle = contact_angle - obstacle_ship_psi;
    if (contact_angle <= -180*deg2rad)
        contact_angle = 360*deg2rad - abs(contact_angle);
    elseif (contact_angle > 180*deg2rad && obstacle_ship_psi > 0)
        contact_angle = 360*deg2rad - contact_angle;
    elseif (contact_angle > 180*deg2rad && obstacle_ship_psi < 0)
        contact_angle = contact_angle - 360*deg2rad;
    end
    if (contact_angle == 180*deg2rad)
        contact_angle = -180*deg2rad;
    end


end

