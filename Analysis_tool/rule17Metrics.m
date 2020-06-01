function [ P17_nst, P17_Delta_psi, P17_Delta_U, P17_Delta, S17 ] = rule17Metrics( Delta_psi, Delta_psi_md, Delta_psi_app, Delta_U_md, Delta_U_app, Delta_U_max, U_0, rule15, rule17, r_maneuver, L_min, L_max, S_safety, gamma17_safety, gamma17_nst, gamma17_Delta,d_T, own_vessel_x, own_vessel_y, t_cpa, psi_0, gamma17_Delta_U, gamma17_Delta_psi)

rad2deg = 180/pi;
deg2rad = pi/180;

if (rule17 == true)
    
       %%%%%%%NB!!!!!!!!!!!!!!!!!!!!!!!!! THIS CODE IS COPIED FROM RULE14!
    P17_nst = -1; % init
    P0 = [own_vessel_x(1), own_vessel_y(1)];
    num_seconds = length(own_vessel_x);
    x_2 = own_vessel_x(1) + U_0*cos(psi_0)*(num_seconds);
    y_2 = own_vessel_y(1) + U_0*sin(psi_0)*(num_seconds);
    P2 = [x_2, y_2];
    for t=1:10:t_cpa
        P = [own_vessel_x(t), own_vessel_y(t)];
        e =  (P(1)-P0(1))*(P2(2)-P0(2)) - (P(2)-P0(2))*(P2(1)-P0(1));
        d = ( abs( (P2(2) - P0(2))*P(1) - (P2(1) - P0(1))*P(2) + P2(1)*P0(2) - P2(2)*P0(1) ) )/(  sqrt((P2(2) - P0(2))^2 + (P2(1) - P0(1))^2) );

        if (e > 0 && d >= d_T)
           P17_nst = 1;
        elseif( e > 0 && d > d_T/2 && d < d_T )
           P17_nst = max(P17_nst, (1 - ((2*(d_T-d))/(d_T))^4));
        elseif (e <= 0 || d <= d_T/2 )
           P17_nst = 0;
        end
    end

    
    if (abs(Delta_psi) < Delta_psi_md)
        P17_Delta_psi = 0;
    elseif ( abs(Delta_psi) >= Delta_psi_md &&  abs(Delta_psi) <= Delta_psi_app)
        P17_Delta_psi = (abs(Delta_psi) - Delta_psi_md)/(Delta_psi_app - Delta_psi_md);
    elseif(abs(Delta_psi) > Delta_psi_app)
        P17_Delta_psi = 1;
    end
    
    Delta_U_app = Delta_U_app*U_0;
    if (abs(Delta_U_max) < Delta_U_md)
        P17_Delta_U = 0;
    elseif(abs(Delta_U_max) >= Delta_U_md &&  abs(Delta_U_max) < Delta_U_app)
        P17_Delta_U = (abs(Delta_U_max) - Delta_U_md)/(Delta_U_app - Delta_U_md);
    elseif(abs(Delta_U_max) >= Delta_U_app)
        P17_Delta_U = 1;
    end
        
    
    if(r_maneuver < L_min)
        P17_Delta = 0;
    elseif(L_min <= r_maneuver && r_maneuver <= L_max) 
        P17_Delta = 1 - ((r_maneuver - L_max)/(L_max - L_min))^2;
    elseif(r_maneuver > L_max)
        P17_Delta = 1;
    end
    
    C = (rule17 && rule15); % true if own ship is stand on in crossing situation
    S17 = max(0, (1 - gamma17_safety*(1 - S_safety) - gamma17_Delta*P17_Delta*(P17_Delta_U*gamma17_Delta_U + gamma17_Delta_psi*P17_Delta_psi) - C*gamma17_nst*P17_nst));
    
else
    P17_Delta_psi = -1;
    P17_Delta_U   = -1;
    P17_nst       = -1;
    P17_Delta     = -1;
    S17 = -1;
end



end

