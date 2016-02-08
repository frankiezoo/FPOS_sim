displacement=-[0 0 0];
x=1/100; %m separation distance
B_m=0.5*8815e-4; %Tesla
c_G=0.5;
init_geometries

%% OS physical characteristics
% inertia of the OSA assembly in the body frame
% OS_Inertia=[0.015 0 0; 0 0.015 0; 0 0 0.015];
OS_Inertia=1e-9*[13894080.33 -19869.26 46055.05;
    -19869.26 12862710.08 16501.8;
    46055.05 16501.8 13896728];  %As we know from 8/11
%center of mass of the OS
CoM=[0,0.00934172358962716,0.00356822089773090]';
%initial velocity of the OS
OS_init_vel=[0,0,0]';
%initial rotation of the OS in the body fixed frame
OS_rotation=0;
%initial angular velocity of the OS in the body fixed frame
%can only have component in y
OS_init_omega=0;
%desired OS xyz des
OS_xyz_des=(ea2dcm(SC_xyz(1,:)',72*pi/180)*OS_xyz_0')';

%% Entire body physical characteristics
%inertia of the entire assembly in the float frame
% All_Inertia=[0.1862 0 0; 0 0.14 0; 0 0 0.0844];
All_Inertia=1e-9*[177248429.51 3410266.03 17326.3;
            3410266.03 129974923.85 -2795629.07;
            17326.3 -2795629.07 81047650]; % as of 8.11.15
%initial angular velocity of the float in the float fixed frame
%can only have component in z
Float_init_omega=OS_init_omega;
%initial velocity of the entire body in the float fixed frame
Float_init_vel=OS_init_vel;
%distance from Float CoM to OSA CoM in the float fixed frame
G_r_CB=[0 0 0]';%0.03556 0]';
%rotation matrix turning intermediate frame to inertial frame
N_DCM_G=eye(3);
%center of mass of the entire body in the float fixed frame
Float_CoM=CoM-N_DCM_G*G_r_CB; %note that this will have to change to work around the OSA's CoM at 0 0 0
%mass of entire assembly
Whole_Mass=12.38866; % as we know of 8.11.15

%% Damping terms

%testbed damping terms
% c_B=0;%.0154;   %bearing friction of globe shaft
% c_G=0;%0177;   %friction of the air foot (rotational)
c_flux=1;
c_trans=c_G;%0177;   %granite friction (translational)

%% SROA properties
SROA_Mass=100000;
SROA_Inertia=1e7*eye(3);

%% Miscellaneous constants
V=[0 0 0 0 0 0]';
trans_gain=1e-7;
rot_gain=1e-8;