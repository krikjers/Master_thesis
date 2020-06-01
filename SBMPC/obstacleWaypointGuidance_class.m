classdef obstacleWaypointGuidance_class
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        current_waypoints;  %2D matrix, Each row i contains waypoint [x,y] for ship i. is a matrix, where current_waypoints(i,:) contains the waypoint [x1, y1] for obstacle ship number i. 
        next_waypoints;     %2D matrix, Each row i contains waypoint [x,y] for ship i. is a matrix, where next_waypoints(i,:) contains the next waypoint [x1, y2] for obstacle ship number i. 
        obstacle_positions; %2D matrix, each column i in obstacle_positions contains the column vector [x_i;y_i] for obstacle ship number i.
        
        Delta; 
        beta;
        radius_of_acceptance;
        number_of_obstacle_ships;
        reference_psi_vector;
        
        time_step;
        waypoints;             %3D matrix, where waypoint matrix [ x1, y1; x2, y2, ....] for obstacle i can be found from waypoints(:,:,i)
        next_waypoint_indexes; %vector of indexes
    end
    
    methods
        
        function [obj] = obstacleWaypointGuidance_class(waypoints, initial_state_matrix, Delta, beta, radius_of_acceptance, time_step, number_of_obstacle_ships, initial_reference_psi_vector, initial_next_waypoint_indexes)
            obj.waypoints = waypoints;
            obj.current_waypoints = permute(waypoints(1,:,:), [3 2 1]); %permute reorders the dimensions
            obj.next_waypoints = permute(waypoints(2,:,:), [3 2 1]);
            obj.next_waypoint_indexes = initial_next_waypoint_indexes;
            
            obj.Delta = Delta;
            obj.beta = beta;
            obj.time_step = time_step;
            obj.radius_of_acceptance = radius_of_acceptance;
            
            obj.obstacle_positions = initial_state_matrix(1:2,:); 
            obj.number_of_obstacle_ships = number_of_obstacle_ships;
            obj.reference_psi_vector = initial_reference_psi_vector;            
        end
        
        function obj = updateObstaclePositions(obj, state_matrix)
            obj.obstacle_positions = state_matrix(1:2,:);          
        end
        
        function next_waypoints_indexes = getNextWaypointsIndexes(obj)
            next_waypoints_indexes = obj.next_waypoint_indexes;
        end
        
        function [obj, reference_psi_vector] = getReferencePsiVector(obj) 
            rad2deg = 180/pi;
            deg2rad = pi/180;
            
            for obstacle_ship_index = 1:obj.number_of_obstacle_ships
                x_position = obj.obstacle_positions(1,obstacle_ship_index);
                y_position = obj.obstacle_positions(2,obstacle_ship_index);
                current_waypoint_x = obj.current_waypoints(obstacle_ship_index, 1);
                current_waypoint_y = obj.current_waypoints(obstacle_ship_index, 2);
                next_waypoint_x = obj.next_waypoints(obstacle_ship_index, 1);
                next_waypoint_y = obj.next_waypoints(obstacle_ship_index, 2);
                
                chi_p = atan2(next_waypoint_y - current_waypoint_y, next_waypoint_x - current_waypoint_x);       %path tangential angle
                e = -(x_position - current_waypoint_x)*sin(chi_p) + (y_position-current_waypoint_y)*cos(chi_p);  %cross track error: distance from vessel to straight path between waypoints
                k = 1/obj.Delta;
                chi_r = atan(-k*e);
                chi_d = chi_p + chi_r; 
                psi_ref = chi_d - obj.beta; 
                %disp(obj.reference_psi_vector(obstacle_ship_index)*rad2deg-psi_ref*rad2deg);
                if ( abs(obj.reference_psi_vector(obstacle_ship_index)*rad2deg - psi_ref*rad2deg) > 180 && psi_ref >= 0 )
                    psi_ref = psi_ref - 360*deg2rad;
                elseif (abs(obj.reference_psi_vector(obstacle_ship_index)*rad2deg - psi_ref*rad2deg) > 180 && psi_ref < 0)
                    psi_ref = psi_ref + 360*deg2rad;
                end % end if
                
                obj.reference_psi_vector(obstacle_ship_index) = psi_ref;      
            end
            reference_psi_vector = obj.reference_psi_vector;            
        end
        
        function  obj = updateCurrentWaypoints(obj)            
           for obstacle_ship_index = 1:obj.number_of_obstacle_ships
                x_position = obj.obstacle_positions(1,obstacle_ship_index);
                y_position = obj.obstacle_positions(2,obstacle_ship_index);
                next_waypoint_x = obj.next_waypoints(obstacle_ship_index, 1);
                next_waypoint_y = obj.next_waypoints(obstacle_ship_index, 2);
                
                distance_to_next_waypoint = sqrt( (next_waypoint_x - x_position)^2 + (next_waypoint_y - y_position)^2 );
                                
                %if taveling towards last waypoint, don't switch
                next_waypoint_for_obstacle = [next_waypoint_x, next_waypoint_y];
                waypoints_for_obstacle = obj.waypoints(:,:,obstacle_ship_index);
                
                if waypoints_for_obstacle(end,:) == next_waypoint_for_obstacle
                    %don't switch
                elseif (distance_to_next_waypoint <= obj.radius_of_acceptance)
                    obj.current_waypoints(obstacle_ship_index,:) = next_waypoint_for_obstacle;
                    obj.next_waypoints(obstacle_ship_index,:) = waypoints_for_obstacle(obj.next_waypoint_indexes(obstacle_ship_index) + 1,:);
                    obj.next_waypoint_indexes(obstacle_ship_index) = obj.next_waypoint_indexes(obstacle_ship_index) + 1;
                end               
           end %end for
        end      
        
              
        
    end    
end

