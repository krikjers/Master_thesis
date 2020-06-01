function [ rule13, rule14, rule15, rule16, rule17 ] = typeOfCollisionSituation( alpha_0, beta_0, alpha_13_crit, alpha_14_crit, alpha_15_crit, speed_own_ship, speed_obstacle_ship, own_ship_init_x, own_ship_init_y, obstacle_ship_init_x, obstacle_ship_init_y, d_cl )
    %alpha_0 = contact angle
    %beta_0 = bearing angle
    %alpha_13_crit, alpha_14_crit, alpha_15_crit = parameters
    %speed_own_ship, speed_obstacle_ship, own_ship_init_x, own_ship_init_y,obstacle_ship_init_x, obstacle_ship_init_y = state values for obs and own ship
    %d_cl = distance when colregs starts to apply
    %all inputs are radians
    rad2deg = 180/pi;
    deg2rad = pi/180;
    
    
    if(beta_0 == 360*deg2rad)
        beta_0 = 0;
    end
    
    beta_0_180 = beta_0;
    %convert beta_0 range from [0,360) to [-180, 180)
    if (beta_0 >= 180*deg2rad)
        beta_0_180 = -360*deg2rad + beta_0;
    end
    alpha_0_360 = alpha_0;
    %convert alpha_0 range from [-180,180) to [0,360)
    if (alpha_0 < 0)
        alpha_0_360 = 360*deg2rad - abs(alpha_0);   
    end
    
    rule13 = 0;
    rule14 = 0;
    rule15 = 0;
    rule16 = 0;
    rule17 = 0;
    distance = sqrt( (own_ship_init_x - obstacle_ship_init_x)^2 +  ( own_ship_init_y - obstacle_ship_init_y )^2 );       
        if (beta_0 > 112.5*deg2rad && beta_0 < 247.5*deg2rad && abs(alpha_0) < alpha_13_crit && speed_own_ship  < speed_obstacle_ship ) %own ship is overtaken
            rule13 = 1;
            rule17 = 1;
            str = "Own-ship is overtaken";
        elseif(alpha_0_360 > 112.5*deg2rad && alpha_0_360 < 247.5*deg2rad && abs(beta_0_180) < alpha_13_crit && speed_own_ship > speed_obstacle_ship) %own-ship overtakes 
            rule13 = 1;
            rule16 = 1;
            str = "Own-ship overtakes";
        elseif(abs(beta_0_180) < alpha_14_crit && abs(alpha_0) < alpha_14_crit ) %head on
            rule14 = 1;
            rule16 = 1;
            str = "Head-on";
        elseif(beta_0 > 0*deg2rad && beta_0 < 112.5*deg2rad && alpha_0 > -112.5*deg2rad && alpha_0 < alpha_15_crit) %crossing, own-ship is give-way
            rule15 = 1;
            rule16 = 1;
            str = "Crossing, own-ship is give-way";
        elseif (alpha_0_360 > 0*deg2rad && alpha_0_360 < 112.5*deg2rad && beta_0_180 > -112.5*deg2rad && beta_0_180 < alpha_15_crit) %crossing, own-ship is stand-on
            rule15 = 1;
            rule17 = 1;
            str = "Crossing, own-ship is stand-on";
        end
end

