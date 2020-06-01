function [ Delta_psi, Delta_psi_abs, t_Delta_psi_abs, Delta_U_max ] = calculateChangeVariables( t_detect, t_cpa, own_vessel_psi, own_vessel_u  )

Delta_psi_abs = 0;
Delta_U_max = 0;
Delta_psi = 0;
t_Delta_psi_abs = 0;
for t = t_detect:t_cpa
    if ((abs(own_vessel_psi(t) - own_vessel_psi(t_detect) ) > Delta_psi_abs)  )
        Delta_psi     = own_vessel_psi(t) - own_vessel_psi(t_detect);     
        Delta_psi_abs = abs( own_vessel_psi(t) - own_vessel_psi(t_detect) );
        t_Delta_psi_abs = t;
    end  
    if ( (abs( own_vessel_u(t) - own_vessel_u(t_detect)) > abs(Delta_U_max)) )
       Delta_U_max = own_vessel_u(t) - own_vessel_u(t_detect);
    end    

end

end

