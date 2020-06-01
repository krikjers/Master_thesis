classdef obstacleShips_class
    %this class keeps track of n obstacle ships
    %each obstacle ship is equivalent to the own-ship (same parameters)
    
    properties
        time_step                  %simulation time step
        number_of_obstacle_ships;  %assume obstacle ships are also PSV vessel with same model as own-ship
        states;                    %matrix, each column is a vector: [x;y;psi;u;v;r]. each obstacle ship has its own column.
        states_dot;                %matrix, each column is a vector: [x_dot;y_dot;psi_dot;u_dot;v_dot;r_dot]. each obstacle ship has its own column.
        desired_psi_vector         %row vector, each element i is desired psi for ship number 
        desired_u_vector           %row vector, each element i is desired u for ship number i
        psv_object;   
    end
    
    methods
        function obj = obstacleShips_class(number_of_obstacle_ships, initial_obstacle_ship_states, initial_obstacle_ship_states_dot, desired_psi_vector, desired_u_vector, time_step, psvModelParameters, Kp_feedback_linearization, kp_heading, Xmax, Ymax, Nmax, K_sway, K_yaw, T_k_surge, T_k_sway, T_k_yaw)
            obj.number_of_obstacle_ships = number_of_obstacle_ships;
            obj.states = initial_obstacle_ship_states;
            obj.states_dot = initial_obstacle_ship_states_dot;
            obj.time_step = time_step;

            obj.psv_object = PSVobstacleShip_class(psvModelParameters, time_step, Kp_feedback_linearization, kp_heading, Xmax, Ymax, Nmax, K_sway, K_yaw, T_k_surge, T_k_sway, T_k_yaw);
            obj.desired_psi_vector = desired_psi_vector;
            obj.desired_u_vector = desired_u_vector;               
        end
        
        function obj = updateDesiredPsiVector(obj, new_desired_psi_vector)
            obj.desired_psi_vector = new_desired_psi_vector;
        end
        
        function obj = updateDesiredSpeedVector(obj, desired_u_vector)
           obj.desired_u_vector = desired_u_vector;
        end            
        
        function [obj] = updateObstacleShipsStates(obj) 
            for obstacle_ship_index = 1:obj.number_of_obstacle_ships
                state = obj.states(:, obstacle_ship_index);
                old_eta = [state(1); state(2); state(3)];
                old_nu = [state(4); state(5); state(6)];                                
                
                desired_u = obj.desired_u_vector(obstacle_ship_index);
                desired_psi = obj.desired_psi_vector(obstacle_ship_index);
                [eta_dot, nu_dot, state_dot_, tau] = obj.psv_object.findStatesDerivatives(state, desired_u, desired_psi);
                new_eta = old_eta + obj.time_step*eta_dot;
                new_nu  = old_nu  + obj.time_step*nu_dot;
                new_state = [new_eta; new_nu];
                new_state_dot = state_dot_;             
                
                obj.states(:,obstacle_ship_index) = new_state;
                obj.states_dot(:, obstacle_ship_index) = new_state_dot;        
            end
        end        
        
        function state_matrix = getObstacleShipsStateMatrix(obj)
            state_matrix = obj.states;            
        end

        
    end    
end

