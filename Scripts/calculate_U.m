function U=calculate_U(mu_0,mu_i,mu_j,rho_ji,effect)
mu_j_norm=norm(mu_j);
mu_j_hat=mu_j/mu_j_norm;

mu_i_norm=norm(mu_i);
mu_i_hat=mu_i/mu_i_norm;

rho_ji_norm=norm(rho_ji);
rho_ji_hat=rho_ji/rho_ji_norm;

B=mu_0/4/pi*(3*dot(mu_j,rho_ji)*rho_ji/rho_ji_norm^5 ...
    -mu_j/rho_ji_norm^3);
U=-dot(mu_i,B);
if strcmp(effect,'mobile')
    U=U/2;
end