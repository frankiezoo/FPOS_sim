init_geometries

%% OS physical characteristics
% inertia of the OSA assembly in the body frame
% OS_Inertia=[0.015 0 0; 0 0.015 0; 0 0 0.015];
OS_Inertia=1e-9*[13894080.33 -19869.26 46055.05;
    -19869.26 12862710.08 16501.8;
    46055.05 16501.8 13896728];  %As we know from 8/11
%initial rotation of the OS in the body fixed frame
OS_rotation=0;%phi_meas(1)*pi/180;
%initial angular velocity of the OS in the body fixed frame
%can only have component in y
OS_init_omega=0;%omega_meas(1)*pi/180;
%rotation axis of the OS. the vector from the center of the OS to one of
%the superconductors
a_hat=SC_xyz(2,:)/norm(SC_xyz(2,:));

%% Damping terms
% c_B=0.0154/2;   %bearing friction of globe shaft as of 8.25.15
c_B=0;
%% SROA properties
% SROA_Mass=100000;
% SROA_Inertia=1e7*eye(3);
% 
%% Miscellaneous constants
V=[0 0 0 0 0 0]';


% %% Versine Clocking Slew
% %direction cosine matrix to rotate one trio to the next about
% %superconductor 1
theta=72*pi/180;
a=SC_xyz(2,:)/norm(SC_xyz(2,:)); %the euler axis, superconductor 1 in this case
%to perform a slew, phi will change over time. in this case a versine
T=.7; %time to complete maneuver
t=[0:0.001:T]; %discrete time steps 
phi_t=0.5*theta*(1-cos(pi*t/T)); %angular displacement about axis over time
phi_dt=0.5*theta*pi/T*sin(pi*t/T); %angular velocity about axis over time
phi_ddt=0.5*theta*(pi/T)^2*cos(pi*t/T); %angular acceleration about axis over time

%angular acceleration may be representation by [magnitude of angular
%acceleration] * unit vector of direction of angular acceleration
%in our case, phi_ddt*a
alpha=a'*phi_ddt; %each column is an acceleration needed at each time step
%angular velocity
omega=a'*phi_dt;
%each column is the body torque needed to accomplish the versine slew
tau_body=OS_Inertia*alpha;