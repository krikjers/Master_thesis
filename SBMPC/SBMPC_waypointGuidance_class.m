classdef SBMPC_waypointGuidance_class    
    properties
        current_waypoint; %[x,y]
        next_waypoint;    %[x,y]
        vessel_position;  %[x,y]
        
        %parameters for LOS guidance
        Delta;  
        beta;
        radius_of_acceptance;
        reference_psi;
        
        time_step;
        waypoints;
        next_waypoint_index;       
    end
    
    methods
        
        function [obj] = SBMPC_waypointGuidance_class(reference_psi_init, waypoints, next_waypoint_index, vessel_position, Delta, beta, time_step, radius_of_acceptance)            
            obj.waypoints = waypoints;
            obj.current_waypoint = waypoints(next_waypoint_index - 1,:);
            obj.next_waypoint    = waypoints(next_waypoint_index,:);
            obj.next_waypoint_index = next_waypoint_index; 
            obj.Delta = Delta;
            obj.beta = beta;
            obj.reference_psi = reference_psi_init; 
            obj.time_step = time_step;
            obj.vessel_position = vessel_position;
            obj.radius_of_acceptance = radius_of_acceptance;           
        end
        
        function [obj, reference_psi] = getReferencePsi(obj)
            rad2deg = 180/pi;
            deg2rad = pi/180;
            vessel_x_position = obj.vessel_position(1);
            vessel_y_position = obj.vessel_position(2);

            current_waypoint_x = obj.current_waypoint(1);
            current_waypoint_y = obj.current_waypoint(2);
            next_waypoint_x = obj.next_waypoint(1);
            next_waypoint_y = obj.next_waypoint(2);
            
            chi_p = atan2(next_waypoint_y - current_waypoint_y, next_waypoint_x - current_waypoint_x);  %path tangential angle
            
            e = -(vessel_x_position - current_waypoint_x)*sin(chi_p) + (vessel_y_position-current_waypoint_y)*cos(chi_p);  %cross track error: distance from vessel to straight path between waypoints
            k = 1/obj.Delta;
            chi_r = atan(-k*e);
            chi_d = chi_p + chi_r; 
            psi_ref = chi_d - obj.beta;
            if (abs( obj.reference_psi*rad2deg - psi_ref*rad2deg ) > 180 && psi_ref >= 0 )
                psi_ref = psi_ref - 360*deg2rad;
            elseif( abs(obj.reference_psi*rad2deg - psi_ref*rad2deg) > 180 && psi_ref < 0 ) 
                psi_ref = psi_ref + 360*deg2rad;
            end
            obj.reference_psi = psi_ref;   
            reference_psi = psi_ref;         
        end
        
        function  obj = updateCurrentWaypoint(obj)
            vessel_x_position = obj.vessel_position(1);
            vessel_y_position = obj.vessel_position(2);
            next_waypoint_x = obj.next_waypoint(1);
            next_waypoint_y = obj.next_waypoint(2);            
            distance_to_next_waypoint = sqrt( (next_waypoint_x - vessel_x_position)^2 + (next_waypoint_y - vessel_y_position)^2 );
                        
            if obj.waypoints(end,:) == obj.next_waypoint
                %if taveling towards last waypoint, don't switch
            elseif distance_to_next_waypoint <= obj.radius_of_acceptance                
                 obj.current_waypoint = obj.next_waypoint;                 
                 obj.next_waypoint = obj.waypoints(obj.next_waypoint_index + 1, :);
                 obj.next_waypoint_index = obj.next_waypoint_index + 1; 
            end           
        end        
        
        function obj = updateVesselPosition(obj, vessel_position)
            obj.vessel_position = vessel_position;             
        end      
        
        function obj = resetWaypoints(obj, next_waypoint_index)
            obj.current_waypoint = obj.waypoints(next_waypoint_index - 1,:);
            obj.next_waypoint    = obj.waypoints(next_waypoint_index,:);
            obj.next_waypoint_index = next_waypoint_index;
        end
        
    end    
end

