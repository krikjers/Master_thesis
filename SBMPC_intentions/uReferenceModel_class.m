classdef uReferenceModel_class
    
    properties
        number_of_obstacle_ships;
        reference_u_vector;         %row vector, contains the reference u for each obstacle ship (which is output from guidance system). obstacle ship i has reference u = reference_u_vector(i)
        desired_u_vector;           %each column i contains the desired nu vector for obstacle ship i.
        x_d_matrix;                 %contains x_d for obstacle ship i in column i. x_d vector is [u,v,r, u_dot, v_dot, r_dot]
        Omega_matrix;
        Delta_matrix;
        time_step;
    end
    
    methods
        function [obj] = uReferenceModel_class(number_of_obstacle_ships, initial_reference_u_vector,initial_desired_u_vector, initial_x_d_matrix, Omega_matrix, Delta_matrix, time_step)
            obj.number_of_obstacle_ships = number_of_obstacle_ships;
            obj.reference_u_vector = initial_reference_u_vector;
            obj.desired_u_vector = initial_desired_u_vector;
            obj.x_d_matrix = initial_x_d_matrix;
            obj.Omega_matrix = Omega_matrix;
            obj.Delta_matrix = Delta_matrix;
            obj.time_step = time_step;
        end
                
        function [obj] = updateReferenceU(obj, new_reference_u_vetor)
            obj.reference_u_vector = new_reference_u_vetor;
        end
        
        
        function [obj, desired_u_vector] = updateDesiredU(obj)
            for obstacle_ship_index = 1:obj.number_of_obstacle_ships
                reference_u = obj.reference_u_vector(obstacle_ship_index);
                x_d = obj.x_d_matrix(:,obstacle_ship_index);
                x_d_new = speedReferenceModel(x_d, reference_u, obj.time_step, obj.Delta_matrix, obj.Omega_matrix);
                obj.x_d_matrix(:,obstacle_ship_index) = x_d_new;
            end           
            obj.desired_u_vector = obj.x_d_matrix(1, :);
            desired_u_vector = obj.desired_u_vector;
        end
        
        
        
        
    end
    
end

