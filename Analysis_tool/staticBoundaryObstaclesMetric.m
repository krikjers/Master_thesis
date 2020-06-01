function [ S_boundary ] = staticBoundaryObstaclesMetric( r_b_cpa, R_b_min, R_b_nm, R_b_col, gamma_b_nm, gamma_b_col, num_boundary_obstacles)

S_boundary = -1;
if (num_boundary_obstacles > 0)
    if (r_b_cpa >= R_b_min)
       S_boundary = 1;
    elseif(r_b_cpa >= R_b_nm && r_b_cpa < R_b_min)
       S_boundary = 1 - gamma_b_nm*((R_b_min - r_b_cpa)/(R_b_min - R_b_nm));
    elseif(r_b_cpa >= R_b_col && r_b_cpa < R_b_nm)
       S_boundary = 1 - gamma_b_nm - gamma_b_col*((R_b_nm - r_b_cpa)/(R_b_nm - R_b_col));
    else
       S_boundary = 0;
    end      
end


end

