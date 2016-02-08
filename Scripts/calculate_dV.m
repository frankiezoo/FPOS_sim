function [dF_dV,dtau_dV]=calculate_dV(mu_mag_i,pos_mag_i,mu_mag_j,pos_mag_j)
%this function calculates force and torque per voltage acting on the 
%source magnet from an electromagnet
%mu_mag_i is the magnetic moment dipole of a magnet i
%mu_mag_j is the magnetic moment dipole of the electromagnet
%pos_mag_i is the position of the magnet i
%pos_mag_j is the position of the electromagnet

%the following parameters follow the most recent 3.8 in diamater EM
A=0.001829214; %m^2
%number of turns in the electromagnet
T=500;
%resistance of electromagnet
R=4; %Ohms
%the permeability of free space, mu_0
mu_0=4*pi*10^-7; %N/A^2

%the following parameters are required by Villani's analytical equations
%for forces and torques on two magnetic dipoles
rho_mji=pos_mag_j-pos_mag_i;
mu_mj_dV=A*T/R*mu_mag_j;
%the voltage is directly proportional to the force and torque applied on
%the magnetic dipole, making the calculation linear and relatively easy

[dF_dV,dtau_dV]=villani(mu_0,mu_mj_dV,mu_mag_i,rho_mji);
%the dF_dV dtau_dV will be evaluated for each electromagnet
%where [F; tau]=[dF_dV;dtau_dV]*[V] 
%V is a 6x1 column vector consisting of V_n for electromagnet n
%F is a 3x1 column vector consisting of forces in the x, y, and z
%tau is a 3x1 column vector consisting of torques in the x, y, and z
%[dF_dV;dtau_dV] is a 6x6 matrix consisting of the contribution of force
%and torque per volt from each electromagnet

