function [ S_safety, S_r, S_Theta ] = safetyMetric( relative_bearing_cut, contact_angle_cut, beta_cpa, alpha_cpa, r_cpa, R_min1, R_nm1, R_col1, R_min2, R_nm2, R_col2, R_min3, R_nm3, R_col3, gamma_nm, gamma_col, gamma_r,gamma_Theta  )
    %all inputs angles are in rad

    
    rad2deg = 180/pi;
    deg2rad = pi/180;
    
    assert(gamma_nm + gamma_col == 1);

    
    if (abs(alpha_cpa) < contact_angle_cut)
        S_Theta_alpha = 1 - cos(alpha_cpa);    
    elseif (abs(alpha_cpa) >= contact_angle_cut)
        S_Theta_alpha = 1 - cos(contact_angle_cut);
    end
        

    if (abs(beta_cpa) < relative_bearing_cut)
        S_Theta_beta = 1 - cos(beta_cpa);
    elseif (abs(beta_cpa) >= relative_bearing_cut)
        S_Theta_beta = 1 - cos(relative_bearing_cut);
    end
    

    
    S_Theta = 0.5*S_Theta_alpha + 0.5*S_Theta_beta;

    
    

    if((beta_cpa < 95*deg2rad && beta_cpa >= 0*deg2rad) || (beta_cpa >= 265*deg2rad && beta_cpa <= 360*deg2rad ))
        R_min = R_min1;
        R_nm  = R_nm1; 
        R_col = R_col1;
    elseif((beta_cpa >= 95*deg2rad && beta_cpa < 265*deg2rad))
        R_min = R_min2;
        R_nm  = R_nm2; 
        R_col = R_col2;
    end
    
    
    if (r_cpa >= R_min)
        S_r = 1;
    elseif (r_cpa >= R_nm  &&  r_cpa < R_min)
        S_r = 1 - gamma_nm*((R_min - r_cpa)/(R_min - R_nm));
    elseif (r_cpa >= R_col && r_cpa < R_nm)
        S_r = 1 - gamma_nm - gamma_col*((R_nm - r_cpa)/(R_nm - R_col));
    else
        S_r = 0;
    end
    
    S_safety = gamma_r*S_r + gamma_Theta*S_Theta;   
    if(S_safety >= 1)
        S_safety = 1;
    elseif (S_safety < 0)
        S_safety = 0;
    end
end

