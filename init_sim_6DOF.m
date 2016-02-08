init_geometries

OS_Inertia=1e-9*[15414004.18 -17587.97 46447.37;
    -17587.97 14625012.78 15237.45;
    46447.37 15237.45 15416346.35];

%center of mass of the OS
% CoM=-[0,0.00934172358962716,0.00356822089773090]';
CoM=[0,-0.01,0]';
%initial velocity of the OS
OS_init_vel=[0,0,0]';
%initial rotation of the OS in the body fixed frame
OS_rotation=[0 0 0]';
%initial angular velocity of the OS in the body fixed frame
OS_init_omega=[0 0 0]';
%desired OS xyz des
OS_xyz_des=(ea2dcm(SC_xyz(1,:)',72*pi/180)*OS_xyz_0')';

trans_gain=1e-7;    % relevant to EM controllers
rot_gain=1e-8;      % relevant to EM contorllers
%OS body damping term
OS_damping_trans=0;
OS_damping_rot=0;

V=[0 0 0 0 0 0]';
F=[0 0 0]';
tau=[0 0 0]';
