function [ P8_delay, P8_psi_app, P8_U_app, P8_app, P8_r, S8   ] = rule8Metrics( r_maneuver, r_detect, Delta_psi, Delta_psi_app, Delta_psi_md, Delta_U_app, U_t_maneuver, U_min, gamma8_app, gamma8_r, gamma8_delay, S_r, rule17, gamma_psi_app, gamma_U_app )
    % r_maneuver = distance between ships when the own-ship starts to take a maneuver
    % r_cpa = distance between vessels at CPA
    % r_detect = distance between vessels when own ship first detect the obstacle ship
    % Delta_psi = total heading change during a maneuver
    % Delta_psi_app = threshold for what is considered to be an apparent heading change
    % Delta_psi_md = smallest detectable heading change
    % Delta_U_app = threshold for what is considered to be an apparent reduction in speed, given as percent
    % U_t_maneuver = speed of own ship at time t_maneuver - when manevuer starts
    % U_min = the smallest speed of the own ship during the maneuver (up to t_cpa)

    
    if (rule17 == true)
        S8 = 1 - (1 - S_r);
        P8_delay = 0;
        P8_psi_app = 0;
        P8_U_app = 0;
        P8_app = 0;
        P8_r = 0;
        
    else
        if (r_maneuver < r_detect)
            P8_delay = (r_detect - r_maneuver)/(r_detect);
        else
            P8_delay = 0;
        end

        if (abs(Delta_psi) >= Delta_psi_app)
            P8_psi_app = 0;
        elseif (abs(Delta_psi) <= Delta_psi_md )
            P8_psi_app = 1;
        elseif (abs(Delta_psi) > Delta_psi_md &&  abs(Delta_psi) < Delta_psi_app  )
            P8_psi_app = (Delta_psi_app - abs(Delta_psi))/(Delta_psi_app - Delta_psi_md);
        end


        Delta_U = (U_t_maneuver - U_min)/(U_t_maneuver);
                
        if (Delta_U >= Delta_U_app)
            P8_U_app = 0;
        else
            P8_U_app = (Delta_U_app - Delta_U)/(Delta_U_app);
        end

        P8_app = P8_psi_app*P8_U_app; %%%%%%gamma_psi_app*P8_psi_app + gamma_U_app*P8_U_app; 

        P8_r = 1 - S_r;
        
        S8 =  1 - gamma8_app*P8_app - gamma8_r*P8_r - gamma8_delay*P8_delay;
        if (S8 < 0)
            S8 = 0;
        end          
        
    end
  
    

end

