function [ g_boundary, g_circle, g_scenario, run_circle_check, run_boundary_check ] = SBMPC_computeG(scenario_index, num_circle_obstacles, num_boundary_obstacles, run_circle_check, run_boundary_check, circle_obstacle_parameters, boundary_obstacles_parameters, t, prediction_time, t_0, own_ship_x_predicted, own_ship_y_predicted, vessel_length, own_ship_heading_predicted, k_circle, k_boundary, g_boundary, g_circle )
    %%%% Penalty for static obstacles    
    if (num_circle_obstacles > 0 && run_circle_check == true)
        for circle_obstacle = circle_obstacle_parameters.'         %in each iteration, circle_obstacle is column vector with [radius; center_x; center_y]
            radius    = circle_obstacle(1);
            center_x  = circle_obstacle(2);
            center_y  = circle_obstacle(3);
            crossing_with_circle = SBMPC_isCollisionWithCircleObstacle(own_ship_x_predicted(t,scenario_index), own_ship_y_predicted(t,scenario_index), vessel_length, own_ship_heading_predicted(t,scenario_index), center_x, center_y, radius);
            if (crossing_with_circle == true)                                
                g_circle = k_circle*(1/(prediction_time - t_0));          %Don't care which circle obstacle there is collision with.
                run_circle_check = false;           %make sure that the earliest detection is what counts.
                %(g_circle);
            end % end if                     
        end % end for                        
    end % end if

    if (num_boundary_obstacles > 0 && run_boundary_check == true)
        for boundary_obstacle = boundary_obstacles_parameters.'    %in each iteration, boundary_obstacle is a column vector containing [start_x, start_y, end_x, end_y]
            boundary_start_x = boundary_obstacle(1);
            boundary_start_y = boundary_obstacle(2);
            boundary_end_x   = boundary_obstacle(3);
            boundary_end_y   = boundary_obstacle(4);  
            crossing_with_boundary = SBMPC_isCollisionWithBoundaryObstacle(own_ship_x_predicted(t,scenario_index), own_ship_y_predicted(t,scenario_index), vessel_length, own_ship_heading_predicted(t,scenario_index), boundary_start_x, boundary_start_y, boundary_end_x, boundary_end_y);
            if (crossing_with_boundary == true)
                g_boundary = k_boundary*(1/(prediction_time - t_0));    %Don't care which boundary obstacle there is collision with.
                run_boundary_check = false;
            end % end if                       
        end % end for                          
    end % end if                    
      
    g_scenario = g_boundary + g_circle;
end

