function [ P14_Theta, S14_Theta, P14_nst, S14 ] = rule14Metrics( alpha_cpa, beta_cpa, d_T, own_vessel_x, own_vessel_y, t_maneuver, t_cpa, U_0, psi_0, gamma14_nst, gamma8_delay, gamma8_psi_app, P8_psi_app, P8_delay, rule14 )
%alpha_cpa, beta_cpa = contact and bearing angle of own-ship at cpa.
% d_T = threshold. when nst turn gives full penalty
% own_vessel_x, own_vessel_y = own vessel pos at all time steps
% t_maneuver, t_cpa = time when own ship start to maneuver and time of cpa.
% P = position at future point in time t_2 > t_maneuver
% U_0, psi_0  = own ship speed and heading at t = 1

% gamma_nst, gamma_delay, gamma_Theta = weight paramters, 
% P8_psi_app = penalty metric for non apparent heading change.
% P8_delay = penalty for when own ship does not take maneuver early enough
% rule14 bool variable. true if rule14 applies

    rad2deg = 180/pi;
    deg2rad = pi/180;

    if (rule14 == true)
       S14_Theta = ( (sin(alpha_cpa) - 1)/(2) )^2*( (sin(beta_cpa) - 1)/(2) )^2; 
       P14_Theta = 1 - S14_Theta;
       
       P14_nst = -1; % init
       
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
               P14_nst = 1;
           elseif( e > 0 && d > d_T/2 && d < d_T )
               P14_nst = max(P14_nst, (1 - ((2*(d_T-d))/(d_T))^4));
           elseif (e <= 0 || d <= d_T/2 )
               P14_nst = 0;
           end
           
       end
       
       S14 = max(0, (1 - gamma14_nst*P14_nst - gamma8_delay*P8_delay - gamma8_psi_app*P8_psi_app)*(1 - P14_Theta));
       
    else
        S14_Theta = -1;
        P14_Theta = -1;
        P14_nst = -1;
        S14 = -1;
    end


end

