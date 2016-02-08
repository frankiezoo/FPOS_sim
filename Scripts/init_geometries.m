%%This script initializes the geometries for the permanent magnet
%%configuration, superconductor configuration, and the electromagnet
%%configuration. In the bigger picture, this will feed the physical
%%parameters needed to simulate dynamics and generate commanded torques.


%% OS geometry
%%calculate permanent magnet coordinates
tau=(1+sqrt(5))/2;
OS_xyz_0=[0 1 tau;
    -1 tau 0;
    1 tau 0;
    0 1 -tau;
    0 -1 tau;
    0 -1 -tau;
    1 -tau 0;
    -1 -tau 0;
    tau 0 1;
    tau 0 -1;
    -tau 0 -1;
    -tau 0 1];
%^the coordinate points of an icosahedron
D=20.3/100; %m the diameter of the OS
magd=1.905/100; %m the diameter of the 0.75 inch spherical magnets to use
rM=(D-magd)/2; %m this radius corresponds to the center of the magnets 
%so that the magnets are flush against the OS surface

OS_Mass=5.919; %kg
Ixx=20162846.98e-9;
Iyy=19963797.4e-9;
Izz=20565101.08e-9;
Ixy=-5748.5e-9;
Iyz=-4119.36e-9;
Ixz=-5000e-9;
OS_Inertia=[Ixx Ixy Ixz; Ixy Iyy Iyz; Ixz Iyz Izz]; %kg-m^2
%these values were taken from version 2 CAD, 3/27/15, to better mimic
%flight conditions, the xz position is modified to better represent the off
%diagonal terms of the inertia matrix because the experiment inertia has
%sensors
displacement=-[0 0 0];
OS_magmom=zeros(size(OS_xyz_0));
for i=1:size(OS_xyz_0,1)
    OS_magmom(i,:)=OS_xyz_0(i,:)/norm(OS_xyz_0(i,:));
    OS_xyz_0(i,:)=OS_magmom(i,:)*rM+displacement;
end

% fprintf('spherical magnet center coordinate points\n')
% disp(OS_xyz_0)
%xyz at this line corresponds to the coordinate points of the center of the
%small spherical magnets

%% Superconductor geometry
%%calculate superconductor coordinates
SC_xyz=[0 1 tau;
    -1 tau 0;
    1 tau  0]; %for superconductor trio locations, i just picked the first 
%three that would create an equilateral triangle
x=1/100; %m separation distance
tSC=1/100; %m thickness of superconductor
rSC=D/2+x+tSC/2; %radius of curvature for the superconductors
SC_magmom=zeros(size(SC_xyz));
for i=1:3
    SC_xyz(i,:)=SC_xyz(i,:)/norm(SC_xyz(i,:))*rSC;
    SC_magmom(i,:)=SC_xyz(i,:)/rSC;
end
% fprintf('YBCO center coordinate points\n')
% disp(SC_xyz)

%SROA Mass and inertia
SROA_Mass=100000;
SROA_Inertia=1e7*eye(3);
%% Electromagnet geometry
% EM_xyz=[0.0496674190644057,-0.0137277370027049,0.107819046185103;
%     -0.0496674190644057,-0.0137277370027049,0.107819046185103;
%     -0.116303254241394,0.0274554740054097,-1.38777878078145e-17;
%     -0.0666358351769881,0.0581516271206969,-0.0803635721796929;
%     0.0666358351769881,0.0581516271206969,-0.0803635721796929;
%     0.116303254241394,0.0274554740054097,-1.38777878078145e-17]; %original design
EM_xyz=1e-3*[-57.54 9.08 141.55;
    57.54 9.08 141.55;
    140.51 60.4 6.34;
    82.97 95.92 -85.7;
    -82.97 95.92 -85.7;
    -140.51 60.4 6.34]; %new tilted design as of 11.7.15
EM_mu=[-.85932 0.112336 -0.49895;
    0.85932 0.112336 -0.49895;
    0.87286 -0.10944 -0.47553;
    0.009448 -0.423843 0.905686;
    -0.009448 -0.423843 0.905686;
    -0.87286 -0.10944 -0.47553];
    
% fprintf('Electromagnet center coordinate points\n')
% disp(EM_xyz)

%the permeability of free space, mu_0
mu_0=4*pi*10^-7; %N/A^2

%surface strength of the magnetic field of the dipole measured along its
%dipole axis taken from manufacturer's website
B_m=8815e-4; %Tesla

%distance from the center of the magnet to its surface
d_m=magd/2; %m

%the estimated magnetic dipole moment magnitude for each magnet on the OS
%surface
OS_mu_0=2*pi*B_m*d_m^3/mu_0*OS_magmom;

%the origin needed to calculate image effects lies radially along the
%superconductor norm, on the surface closer to the OS
origin=SC_xyz-SC_magmom*tSC/2;

%the field cooled positions needed to calculate image effects is at the
%initial position of the permanent magnets at the start of the slew
fc_xyz=OS_xyz_0;

%the field cooled magnetic moments needed to calculate image effects is at the
%initial position of the permanent magnets at the start of the slew
OS_mu_fc=OS_mu_0;


%% OS and SRO graphical representation
%everything below is just for a graphic representation
%make the spherical surface
[xs,ys,zs]=sphere(100); figure('Name','Geometry Locations')
scatter3(OS_xyz_0(:,1),OS_xyz_0(:,2),OS_xyz_0(:,3),375,[0.5,0.5,0.5],'filled')
%magnets 
hold on
scatter3(SC_xyz(:,1),SC_xyz(:,2),SC_xyz(:,3),500,[0,0,0],'filled')
%superconductors
scatter3(EM_xyz(:,1),EM_xyz(:,2),EM_xyz(:,3),225,[0,1,0],'filled')
%electromagnets
line([0 .2],[0 0],[0 0],'LineWidth',4,'Color',[1 0 0])
line([0 0],[0 .2],[0 0],'LineWidth',4,'Color',[0 1 1])
line([0 0],[0 0],[0 .2],'LineWidth',4,'Color',[1 0 1])
surf(xs*rM,ys*rM,zs*rM,'EdgeColor','none','LineStyle','none','FaceColor','yellow')
%spherical surface 
axis equal
legend('Permanent Magnets', 'Superconductors','Electromagnets','x','y','z')
