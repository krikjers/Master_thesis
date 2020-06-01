function [ relative_bearing, contact_angle  ] = calculateBearingAndContactWoerner( own_vessel_x, own_vessel_y, own_ship_psi, obstacle_ship_x, obstacle_ship_y, obstacle_ship_psi  )
    %input heading is assumed to be in rads
    rad2deg = 180/pi;
    deg2rad = pi/180;
    
    absoluteBearing = 0;
    if (own_vessel_y == obstacle_ship_y && own_vessel_x <= obstacle_ship_x)
        absoluteBearing = 0; 
    elseif(own_vessel_y == obstacle_ship_y && own_vessel_x > obstacle_ship_x)
        absoluteBearing = 180*deg2rad;
    elseif(own_vessel_y < obstacle_ship_y && own_vessel_x <= obstacle_ship_x) 
        absoluteBearing = atan( abs(own_vessel_x - obstacle_ship_x)/abs(own_vessel_y - obstacle_ship_y) ) + 90*deg2rad;
    elseif(own_vessel_y < obstacle_ship_y && own_vessel_x > obstacle_ship_x)
        absoluteBearing = 90*deg2rad - atan( abs(own_vessel_x - obstacle_ship_x)/abs(own_vessel_y - obstacle_ship_y) );
    elseif(own_vessel_y > obstacle_ship_y && own_vessel_x <=  obstacle_ship_x)
        absoluteBearing = atan( abs(own_vessel_x - obstacle_ship_x)/abs(own_vessel_y - obstacle_ship_y) ) + 270*deg2rad;
    elseif(own_vessel_y > obstacle_ship_y && own_vessel_x > obstacle_ship_x)
        absoluteBearing = 270*deg2rad - atan( abs(own_vessel_x - obstacle_ship_x)/abs(own_vessel_y - obstacle_ship_y) );
    end
    
    % Beta
    if (absoluteBearing - own_ship_psi >= 0 )
        relative_bearing = absoluteBearing - own_ship_psi;
    else
        relative_bearing = 360*deg2rad + absoluteBearing - own_ship_psi;
    end
    
  
    
    %Alpha
    if (absoluteBearing + 180*deg2rad - obstacle_ship_psi >= 0 )
        contact_angle = absoluteBearing + 180*deg2rad - obstacle_ship_psi;
    else
        contact_angle = 360*deg2rad + absoluteBearing + 180*deg2rad - obstacle_ship_psi;
    end
    
    
    
    
end

