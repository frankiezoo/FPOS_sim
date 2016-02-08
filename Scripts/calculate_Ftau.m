function [F,tau,U]=calculate_Ftau(mu_mag_i,mu_mag_j,mu_mag_fc,...
    pos_mag_i,pos_mag_j,pos_fc,origin,effect)
%this function calculates force and torque acting on the source magnet from a mobile
%image (mobile image acting on magnet) and on the source magnet from a
%frozen image
%mu_mag_i is the magnetic moment dipole of a magnet i
%mu_mag_j is the magnetic moment dipole of a magnet j
%mu_mag_fc is the magnetic moment dipole of a field cooled magnet
%pos_mag_i is the position of the magnet i
%pos_mag_j is the position of the magnet j
%pos_fc is the position of the source magnet when field cooled
%origin is an arbitrary point on the superconductor's surface to establish
% an origin for relative position vectors
%all calculations derived from Jones Dissertation page 71, Kordyuk with
%the following assumptions:
%magnets are al modeled as dipoles, the distance between the magnet and
%superconductor is much greater than the penetration depth of the magnetic
%field into the superconductor, and the superconductor is assumed to be an
%infinite plane with no hysteretic or edge effects

%there are two types of image effects on the source magnet:
%mobile: mobile image of any magnet on the permanent magnet
%frozen: frozen image of any magnet on the permanent magnet
%the variable 'effect' will be either 'mobile','or 'frozen' 

%the permeability of free space, mu_0
mu_0=4*pi*10^-7; %N/A^2

%% defining magetic moments and relative position vectors
%distance from origin to center of magnet
r_i=pos_mag_i-origin;
r_j=pos_mag_j-origin;

r_fc=pos_fc-origin;

%normal vector from the superconductor surface
a=-origin/norm(origin);

%the position vector from the mobile image center to the magnet's
%center
rho_mii=2*dot(a,r_j)*a;

%the position vector from the frozen image center to the magnet's center
rho_fii=2*dot(a,r_fc)*a;

%magnetic moment of mobile image i
mu_mi=(mu_mag_i-2*dot(a,mu_mag_i)*a);

%magnetic moment of mobile image j
mu_mj=(mu_mag_j-2*dot(a,mu_mag_j)*a);

%magnetic moment of field cooled image i or j, most be cognizant when
%entering effect
mu_fc=2*dot(a,mu_mag_fc)*a-mu_mag_fc;

%magnetic moment of source magnet i
mu_i=mu_mag_i;


%% calculating forces and torques 
if strcmp(effect,'mobile')
    %relative position vector between a mobile image j and source image i
    rho_mji=r_i-(r_j-rho_mii);

    %mobile image j acting on magnet i
    [F,tau]=villani(mu_0,mu_mj,mu_i,rho_mji);
    U=calculate_U(mu_0,mu_i,mu_mj,rho_mji,'mobile');
      
elseif strcmp(effect,'frozen')

    %relative position vector between a frozen image j and source image i    
    rho_fji=r_i-(r_fc-rho_fii);

    %frozen image j acting on magnet i
    [F,tau]=villani(mu_0,mu_fc,mu_i,rho_fji);
    U=calculate_U(mu_0,mu_i,mu_fc,rho_fji,'frozen');
    
end


end



