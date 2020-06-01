function x_d_new = referenceModelPsi(x_d, reference_psi, Omega_matrix, time_step)
A_d = [zeros(3,3), eye(3), zeros(3,3);
        zeros(3,3), zeros(3,3), eye(3);
        -Omega_matrix^3, -3*Omega_matrix^2, -3*Omega_matrix];

 B_d = [zeros(3,3);
        zeros(3,3);
        Omega_matrix^3];


x_d_dot = A_d*x_d + B_d*[0;0;reference_psi];
x_d_new = x_d + time_step*x_d_dot;
end