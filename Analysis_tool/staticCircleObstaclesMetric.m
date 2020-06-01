function [ S_circle ] = staticCircleObstaclesMetric( r_c_cpa, R_c_min, R_c_nm, R_c_col, gamma_c_nm, gamma_c_col, num_circle_obstacles)

S_circle = -1;
if (num_circle_obstacles > 0)
    if (r_c_cpa >= R_c_min)
        S_circle = 1;
    elseif(r_c_cpa >= R_c_nm && r_c_cpa < R_c_min)
        S_circle = 1 - gamma_c_nm*((R_c_min - r_c_cpa)/(R_c_min - R_c_nm));
    elseif(r_c_cpa >= R_c_col && r_c_cpa < R_c_nm)
        S_circle = 1 - gamma_c_nm - gamma_c_col*((R_c_nm - r_c_cpa)/(R_c_nm - R_c_col));
    else
        S_circle = 0;
    end
end


end

