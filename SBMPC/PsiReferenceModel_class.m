classdef PsiReferenceModel_class
    
    properties        
        number_of_obstacle_ships;
        reference_psi_vector;     %row vector, contains the reference psi for each obstacle ship (which is output from guidance system). obstacle ship i has reference psi = reference_psi_vector(i)
        desired_psi_vector;       %row vector, contains the desired psi for each obstacle ship (output from reference model)
        x_d_matrix;               %contains x_d for obstacle ship i in column i. x_d vector is [x,y,psi, x_dot, y_dot, psi_dot, x_ddot, y_ddot, psi_ddot]
        Omega_matrix;
        Delta_matrix;
        time_step;        
    end
    
    methods        
        function [obj] = PsiReferenceModel_class(number_of_obstacle_ships, initial_reference_psi_vector, initial_desired_psi_vector, initial_x_d_matrix, Omega_matrix, Delta_matrix, time_step)
            obj.number_of_obstacle_ships = number_of_obstacle_ships;
            obj.reference_psi_vector = initial_reference_psi_vector;
            obj.desired_psi_vector = initial_desired_psi_vector;         
            obj.x_d_matrix = initial_x_d_matrix;  %without int8(), a "Computed maximum size is not bounded" error occurs.
            obj.Omega_matrix = Omega_matrix;
            obj.Delta_matrix = Delta_matrix;
            obj.time_step = time_step;
        end
        
        function [obj] = updateReferencePsi(obj, new_reference_psi_vector)
            obj.reference_psi_vector = new_reference_psi_vector;
        end
        
        
        function [obj, psi] = updateDesiredPsi(obj)
            for obstacle_ship_index = 1:obj.number_of_obstacle_ships
                reference_psi = obj.reference_psi_vector(obstacle_ship_index);
                x_d = obj.x_d_matrix(:,obstacle_ship_index);
                x_d_new = referenceModelPsi(x_d, reference_psi, obj.Omega_matrix, obj.time_step);
                obj.x_d_matrix(:,obstacle_ship_index) = x_d_new;
            end
            obj.desired_psi_vector = obj.x_d_matrix(3, :); 
            psi = obj.desired_psi_vector;
        end
        
     
        
        
    end
    
end


