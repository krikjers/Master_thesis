classdef PSVvessel_class   
    properties (GetAccess = 'public', SetAccess = 'private')   
        %model parameters
        r_CG      %[x,y,z] distance between CO and CG in {b} (vector with 3 elements)
        m         %mass of vessel (scalar)
        M         %total inertia matrix, M_A + M_RB (3x3 matrix) 
        D         %linear damping matrix (3x3 matrix)
        length    %ship length [m]
        width     %ship width [m]
        
        %hydrodynamic derivatives
        X_udot 
        Y_vdot
        Y_rdot
        N_rdot       
        
        time_step    %time step for simulation
        
        %states of vessel
        eta       %[x,y,psi]^T in ned frame. psi is in radians (column vector)
        nu        %[u,v,r]^T   in ned frame. r is is in radians/sec (column vector)
        state     %[x,y,psi,u,v,r]^T 
        state_dot %derivative of state
    
        %desired course and speed
        desired_psi  %psi_d
        desired_nu   %%[u_d,v_d,r_d]^T
                    
        %control parameters
        Kp_feedback_linearization
        kp_heading
        
        %force saturation
        Xmax;
        Ymax; 
        Nmax; 
    end  

    
    methods
        function [obj] = PSVvessel_class(psvModelParameters, initial_eta, initial_nu, time_step, desired_psi, desired_nu, Kp_feedback_linearization, kp_heading, Xmax, Ymax, Nmax, K_sway, K_yaw, T_k_surge, T_k_sway, T_k_yaw)        %note: psvModelParameters = modelConfig in other PSV.m
            %input psvModelParameters is found from PSVparameters.mat. It contains r_CG, m, M_RB, A_zero, T_i
            obj.time_step = time_step;         
            
            obj.Kp_feedback_linearization = Kp_feedback_linearization;
            obj.kp_heading = kp_heading;
            
            obj.Xmax = Xmax;
            obj.Ymax = Ymax;
            obj.Nmax = Nmax;            
            
            obj.eta = initial_eta;
            obj.nu = initial_nu;
            obj.state = [initial_eta;initial_nu];
            obj.state_dot = [0;0;0;0;0;0];
            obj.desired_psi = desired_psi;
            obj.desired_nu = desired_nu;            
            obj.r_CG = psvModelParameters.r_CG;          %[x,y,z] distance between CO and CG in {b}
            obj.m = psvModelParameters.m;                %mass of vessel
            M_RB_6DOF = psvModelParameters.MRB;          %rigid body inertia matrix for vessel in 6 DOF 
            A_zero_6DOF = psvModelParameters.A_zero;     %zero frequency added mass matrix in 6 DOF
            obj.length = 116;
            obj.width = 25;
            
            T_i = psvModelParameters.T_i;                %time constants for [surge, sway, yaw]
            T_i(1) = T_i(1)*T_k_surge;
            T_i(2) = T_i(2)*T_k_sway;
            T_i(3) = T_i(3)*T_k_yaw;             
            
            M_RB = [ M_RB_6DOF(1,1),            M_RB_6DOF(1,2),    0;
                         M_RB_6DOF(2,1),        M_RB_6DOF(2,2),    M_RB_6DOF(2,6);
                         0                      M_RB_6DOF(6,2),    M_RB_6DOF(6,6)];                     
                     
            M_A =  [ A_zero_6DOF(1,1),          0,                 0;
                         0,                     A_zero_6DOF(2,2),  A_zero_6DOF(2,6);
                         0,                     A_zero_6DOF(6,2),  A_zero_6DOF(6,6)];                  
                   
            obj.M = M_A + M_RB;
            
            %multiplications with 100 and 180 for stability reasons
            obj.D =    [ obj.M(1,1)/T_i(1),     0,                     0;
                         0,                     obj.M(2,2)/T_i(2)*K_sway  0;
                         0,                     0,                     obj.M(3,3)/T_i(3)*K_yaw];  %%*135            
   
            %hydrodynamic derivatives (see fossen page 118)
            obj.X_udot = -M_A(1,1);
            obj.Y_vdot = -M_A(2,2);
            obj.Y_rdot = -M_A(2,3);
            obj.N_rdot = -M_A(3,3);                     
        end
            
        function [rot_matrix] = calculateRotationMatrix(obj)
            psi = obj.eta(3);  %NB: psi is in radians
            rot_matrix = [ cos(psi),  -sin(psi),  0;
                           sin(psi),   cos(psi),  0;
                           0,          0,         1];
        end
        
        function [C_RB, C_A] = calculateCoriolisMatrices(obj)
            x_g = obj.r_CG(1);
            u   = obj.nu(1);
            v   = obj.nu(2);
            r   = obj.nu(3);
            
            %assuming velocity of ocean current = 0, which means nu_r = nu
            nu_r  = obj.nu;
            u_r   = nu_r(1);
            v_r   = nu_r(2);
            r_r   = nu_r(3);
            
            
            C_RB =  [ 0,                   0,       -obj.m*(x_g*r + v);
                      0,                   0,        obj.m*u;
                      obj.m*(x_g*r + v),  -obj.m*u,  0];
                                 
            C_A  =  [ 0,                              0,               obj.Y_vdot*v_r + obj.Y_rdot*r_r;
                      0,                              0,              -obj.X_udot*u_r;
                     -obj.Y_vdot*v_r-obj.Y_rdot*r_r,  obj.X_udot*u_r,  0];
        end
        
        
        
        
        function [eta_dot, nu_dot, state_dot, tau] = findStatesDerivatives(obj)
            rotation_matrix = obj.calculateRotationMatrix;            
                       
            [C_RB, C_A] = obj.calculateCoriolisMatrices();         
            nu_r = obj.nu;          %assume velocity of ocean current = 0, which means nu_r = nu
            tau = [0,0,0]';         
            
            [tau_surge, tau_sway, tau_yaw] = obj.feedbackLinearizingController(C_RB, C_A);            
            tau = [tau_surge; tau_sway; tau_yaw]; 
            tau = obj.thrustSaturation(tau);
        
            eta_dot = rotation_matrix*obj.nu;
            nu_dot = obj.M\(tau -C_RB*obj.nu -C_A*nu_r -obj.D*nu_r);  %inv(obj.M)*(tau -obj.D*nu_r-C_A*nu_r-C_RB*obj.nu);
            state_dot = [eta_dot; nu_dot];
        end
        
        function [tau_surge, tau_sway, tau_yaw] = feedbackLinearizingController(obj, C_RB, C_A)
            %See fossen p 450+                                         
                                      
            %heading controller:
            obj.desired_nu(3) = obj.kp_heading*(obj.desired_psi - obj.eta(3));                              
           
            %speed controller:
            nu_error = obj.nu - obj.desired_nu;	% Current error
            nonlinear_component = (C_RB+C_A+obj.D)*obj.nu;        
           
            a_b = -obj.Kp_feedback_linearization*nu_error;                                                  
            tau = obj.M*a_b + nonlinear_component;
            tau_surge = tau(1);
            tau_sway = tau(2);
            tau_yaw = tau(3);            
        end 

        function [obj, tau] = update_states(obj, desired_psi, desired_nu)
            obj.desired_psi = desired_psi;
            obj.desired_nu = desired_nu;            
            
            [eta_dot, nu_dot, state_dot_, tau] = obj.findStatesDerivatives();
            
            new_eta = obj.eta + obj.time_step*eta_dot;
            %disp(new_eta(1))
            new_nu  = obj.nu  + obj.time_step*nu_dot;
            new_state = [new_eta; new_nu];
            new_state_dot = state_dot_;
            
            obj.eta = new_eta;
            obj.nu = new_nu;
            obj.state = new_state;
            obj.state_dot = new_state_dot;           
        end    
        
        function PSVstate = getStates(obj)
           PSVstate = obj.state; 
        end
        
        function tau = thrustSaturation(obj, tau)                      
            if obj.Nmax < abs(tau(3))
                tau(3) = obj.Nmax*sign(tau(3));
            end
            if obj.Xmax < abs(tau(1))
                tau(1) = obj.Xmax*sign(tau(1));
            end
            if obj.Ymax < abs(tau(2))
                tau(2) = obj.Ymax*sign(tau(2));
            end
        end
        
        
        
        
    end    
end

