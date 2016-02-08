%%This script generates different types of slew. To use them, scroll to the
%%section desired and uncomment up to the next section.
%%The eigenaxis slew in partcular is generated using "an arbitrary axis 
%%that is fixed to the body and stationary in an inertial reference frame" 
%%[Bong Wie Space Vehicle Dynamics and Control] and an angle rotation. 
%%In our case, the axis is the vector from the center of the OS to a pivot 
%%magnet (permannet magnet field cooled to a superconductor). The angle 
%%rotation is 72 degrees, the angular displacement from the initial trio of 
%%magnets pinned to the trio of superconductors to another trio of magnets.


%% For the case of a Versine Eigenaxis Slew:
%uncomment this section to run
%direction cosine matrix to rotate one trio to the next about
%superconductor 1
phi=72*pi/180;
a=SC_xyz(1,:)/norm(SC_xyz(1,:)); %the euler axis, superconductor 1 in this case
%to perform a slew, phi will change over time. in this case a versine
T=10; %time to complete maneuver
t=[0:0.001:T]; %discrete time steps 
phi_t=0.5*phi*(1-cos(pi*t/T)); %angular displacement about axis over time
phi_dt=0.5*phi*pi/T*sin(pi*t/T); %angular velocity about axis over time
phi_ddt=0.5*phi*(pi/T)^2*cos(pi*t/T); %angular acceleration about axis over time

%angular acceleration may be representation by [magnitude of angular
%acceleration] * unit vector of direction of angular acceleration
%in our case, phi_ddt*a
alpha=a'*phi_ddt; %each column is an acceleration needed at each time step
%angular velocity
omega=a'*phi_dt;
%each column is the body torque needed to accomplish the versine slew
tau_body=OS_Inertia*alpha+cross(omega,OS_Inertia*omega);

OS_xyz=zeros([size(OS_xyz_0) length(t)]);
OS_mu=zeros([size(OS_xyz_0) length(t)]);
for time=1:length(t)
    phi_dcm=ea2dcm(SC_xyz(1,:),phi_t(time));
    OS_mu(:,:,time)=OS_mu_0*phi_dcm;
    OS_xyz(:,:,time)=OS_xyz_0*phi_dcm;
end

%% For the case of displacement in the x y z direction for stiffness matrix
%uncomment this section to run
% T=10; %time to complete maneuver
% t=linspace(0,T,T*10+1); %discrete time steps 
% delpos=linspace(-0.01,0.1,length(t));
% OS_xyz=zeros([size(OS_xyz_0) length(t)]);
% OS_mu=zeros([size(OS_xyz_0) length(t)]);
% x=[-1 0 0];
% y=[0 -1 0];
% z=[0 0 -1];
% for time=1:length(t)
%     for i=1:size(OS_xyz_0,1)
%     OS_xyz(i,:,time)=OS_xyz_0(i,:)+delpos(time)*x+[0 -.05 0];
%     end
%     OS_mu(:,:,time)=OS_mu_0;
% end
% tau_body=zeros(3,length(t));

%% For the case of an Eigenaxis Slew for theta x y and z displacement
%uncomment this section to run
%direction cosine matrix to rotate one trio to the next about
%superconductor 1
% a_x=[1 0 0]; 
% a_y=[0 1 0]; 
% a_z=[0 0 1]; 
% phi=36*pi/180;
% 
% T=10; %time to complete maneuver
% t=linspace(0,T,T*10+1); %discrete time steps 
% phi_t=linspace(0,phi,length(t));
% 
% OS_xyz=zeros([size(OS_xyz_0) length(t)]);
% OS_mu=zeros([size(OS_xyz_0) length(t)]);
% for time=1:length(t)
%     phi_dcm=ea2dcm(a_z,phi_t(time));
%     OS_mu(:,:,time)=OS_mu_0*phi_dcm;
%     OS_xyz(:,:,time)=OS_xyz_0*phi_dcm;
% end
% tau_body=zeros(3,length(t));

%% For the case of constant stiffness for theta x y and z displacement
%displace epsilon from the equlibrium
% t=[-eps 0 eps]; %discrete time steps 
% a_x=[1 0 0]; 
% a_y=[0 1 0]; 
% a_z=[0 0 1]; 
% phi=eps;
% phi_t=linspace(-phi,phi,length(t));
% x=[-1 0 0];
% y=[0 -1 0];
% z=[0 0 -1];
% 
% delpos=t;
% 
% OS_xyz=zeros([size(OS_xyz_0) length(t)]);
% OS_mu=zeros([size(OS_xyz_0) length(t)]);
% 
% for time=1:length(t)
%     %uncomment the next few lines for displacement only
% %     for i=1:size(OS_xyz_0,1)
% %     OS_xyz(i,:,time)=OS_xyz_0(i,:)+delpos(time)*z;
% %     end
% %     OS_mu(:,:,time)=OS_mu_0;
%     %uncomment the next few lines for rotation only
%     phi_dcm=ea2dcm(a_z,phi_t(time));
%     OS_mu(:,:,time)=OS_mu_0*phi_dcm;
%     OS_xyz(:,:,time)=OS_xyz_0*phi_dcm;
% end
% tau_body=zeros(3,length(t));

%% TODO step acceleration, ramp velocity, and exponential angle slew

