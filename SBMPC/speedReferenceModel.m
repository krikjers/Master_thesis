function x_d_new = speedReferenceModel(x_d, reference_u, time_step, Delta_matrix, Omega_matrix)    
%x_d = [nu; nu_dot] = [u,v,r, u_dot, v_dot, r_dot]

A_d = [zeros(3,3), eye(3);
      -(Omega_matrix)^2, -2*Delta_matrix*(Omega_matrix)];
  
B_d = [zeros(3,3);
       (Omega_matrix)^2];   

x_d_dot = A_d*x_d + B_d*[reference_u;0;0];
x_d_new = x_d + time_step*x_d_dot;
end
