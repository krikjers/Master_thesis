function x_d_new = referenceModelPsi(x_d, reference_psi, Omega_matrix, time_step)
 %THE SAME FUNCTION AS USED IN obstacleShips FOLDER!!!!

%x_d:  [eta; eat_dot; eta_dotdot] = [x,y,psi, x_dot, y_dot, psi_dot, x_ddot, y_ddot, psi_ddot]

%get faster convergence when reference psi is low
%if (reference_psi < 15*deg2rad)
%    Omega_matrix(3,3) = Omega_matrix(3,3) + 0.09;
%end
A_d = [zeros(3,3), eye(3), zeros(3,3);
        zeros(3,3), zeros(3,3), eye(3);
        -Omega_matrix^3, -3*Omega_matrix^2, -3*Omega_matrix];

 B_d = [zeros(3,3);
        zeros(3,3);
        Omega_matrix^3];


x_d_dot = A_d*x_d + B_d*[0;0;reference_psi];
x_d_new = x_d + time_step*x_d_dot;
end