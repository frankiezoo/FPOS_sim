%% Calculate the work done by the electromagnets in a particular slew.
%%This involves defining a slew, creating a force and torque profile,
%%calculating the voltage, calculating the maximum torque capable, and
%%integrating that over angular disaceplements for total work done.

%% Define a slew
%direction cosine matrix to rotate one trio to the next about
%superconductor 1
phi=72*pi/180;
a=SC_xyz(1,:)/norm(SC_xyz(1,:)); %the euler axis, superconductor 1 in this case
%to perform a slew, phi will change over time. in this case a versine
T=10; %time to complete maneuver
t=linspace(0,T,T*100+1); %discrete time steps
phi_t=0.5*phi*(1-cos(pi*t/T)); %angular displacement about axis over time
phi_dt=0.5*phi*pi/T*sin(pi*t/T); %angular velocity about axis over time
phi_ddt=0.5*phi*(pi/T)^2*cos(pi*t/T); %angular acceleration about axis over times
%angular acceleration may be representation by [magnitude of angular
%acceleration] * unit vector of direction of angular acceleration
%in our case, phi_ddt*a
alpha=a'*phi_ddt; %each column is an acceleration needed at each time step
%angular velocity
omega=a'*phi_dt;
%each column is the body torque needed to accomplish the versine slew
tau_body=OS_Inertia*alpha+cross(omega,OS_Inertia*omega);

%above was just the rotation, now for translation
disp=[0 0 0];

OS_xyz=zeros([size(OS_xyz_0) length(t)]);
OS_mu=zeros([size(OS_xyz_0) length(t)]);
for time=1:length(t)
    phi_dcm=ea2dcm(SC_xyz(1,:),phi_t(time));
    OS_mu(:,:,time)=OS_mu_0*phi_dcm;
    for j=1:12
        OS_xyz(j,:,time)=OS_xyz_0(j,:)*phi_dcm+disp;
    end
end

%% Calculate desired force, torque, and voltage profile for electromagnets

% initialize time profiles important to slew maneuver
%V_profile represents the 6 voltages the electromagnets must generate
%during a specific slew maneuver
V_profile=zeros(6,length(t));
%F_image_profile and tau_image_profile stores the force and torque
%on the OS body due to image effects during each time step of the maneuver
F_image_profile=zeros(3,length(t));
tau_image_profile=zeros(3,length(t));
%F_actuator_profile and tau_actuator_profile stores the force and torque
%on the OS body need by the actuators during each time step of the maneuver
F_actuator_profile=zeros(3,length(t));
tau_actuator_profile=zeros(3,length(t));
U_image_profile=zeros(2,length(t));

% for each time step in the slew, the OS location and orientation is updated
for time=1:length(t)
    % calculate image effects on the 12 permanent magnets
    [F_body_images,tau_body_images,U_images]=image_effect(OS_mu(:,:,time),OS_xyz(:,:,time),...
        OS_mu_fc,fc_xyz,origin);
    %     pause %to check body image effects after a certain time step during a maneuver
    
    %store the image effects in the F_image and tau_image profiles
    F_image_profile(:,time)=F_body_images';
    tau_image_profile(:,time)=tau_body_images';
    U_image_profile(:,time)=U_images';
    % calculate the force and torque desired on the body
    %for clocking, the net force on the body is zero, so the desired force
    %from the actuators is the exact magnitude of force from the images in
    %the opposite direction
    F_desired=-F_body_images;
    %for clocking, the net torque on the body is defined by the slew
    %profile, so the desired force is the difference between the commanded
    %torque and the torque produced by the images
    tau_desired=tau_body(:,time)-tau_body_images;
    
    %store the actuator desired effects in the F_actuator and tau_actuator
    %profiles
    F_actuator_profile(:,time)=F_desired';
    tau_actuator_profile(:,time)=tau_desired';
    
    %the output vector desired, conventionally called the b vector in MATLAB
    b=[F_desired; tau_desired];
    
    % Calculate the needed electromagnet voltage with a pseudoinverse
    %initialize a placeholder for the pseudoinverse
    A=zeros(6,6);
    
    %sift through all the electromagnets to back out portion of force
    %and torque generated from each individually
    for i=1:6
        %initialize sum of electromagnet contribution acting on each
        %permanent magnet due to electromagnet i
        dF_tot=zeros(1,3);
        dtau_tot=zeros(1,3);
        %calculate electromagnet affect on force and torque on body through
        %all the permanent magnets
        for j=1:size(OS_xyz_0,2)
            %in this case, the magnetic moment dipole being acted on is the
            %permanent magnet, following Villani convention
            mu_mag_i=OS_mu(j,:,time);
            pos_mag_i=OS_xyz(j,:,time);
            %the magnetic moment dipole acting on magnet i is the
            %electromagnet
            pos_mag_j=EM_xyz(i,:);
            mu_mag_j=EM_magmom(i,:);
            %calculate_dV is a variation of villani. Villani requires mu
            %components and the position vector between them. Within
            %calculate_dV, the electromagnet's magnetic dipole/voltage is
            %substituted for force and torque per unit Volt
            [dF_dV,dtau_dV]=calculate_dV(mu_mag_i,pos_mag_i,mu_mag_j,pos_mag_j);
            %sum over each permanent magnet
            dF_tot=dF_tot+dF_dV;
            dtau_tot=dtau_tot+dtau_dV+cross(dF_tot,pos_mag_i);
        end
        %fill in the portion of the pseudoinverse needed to calculate
        %electromagnetic contribution
        A(:,i)=[dF_tot';dtau_tot'];
    end
    %voltage calculated for this time step using the pseudoinverse
    V=A\b;
    %store the electromagnet voltage required to exert the desired force
    %and torque
    V_profile(:,time)=V';
end

%% Calculate the maximum torque capable

tau_des=tau_actuator_profile;
for i=1:6
    for j=1:3
        dtaudV{i,j}=12*tau_des(j,:)./V_profile(i,:);
    end
end
x_sum=zeros(1,1001);
y_sum=zeros(1,1001);
z_sum=zeros(1,1001);
for i=1:6
    x_sum=x_sum+dtaudV{i,1};
    y_sum=y_sum+dtaudV{i,2};
    z_sum=z_sum+dtaudV{i,3};
end
tau_net=[x_sum; y_sum; z_sum]/6;

W_sum=0;
W=zeros(1001,1);
for i=1:length(phi_t)-1
    W_sum=W_sum+tau_net(:,i)'/norm(tau_net(:,i))*tau_net(:,i)*(phi_t(i+1)-phi_t(i));
    W(i)=W_sum;
end

%% Now to compare it to the potential energy needed to overcome the flux pinning effects
dU=U_image_profile(1,:)+U_image_profile(2,:)-U_image_profile(1,1)-U_image_profile(2,1);

%% Plots

figure
plot(phi_t*180/pi,V_profile')
axis([0 72 -5e4 5e4])
title(sprintf('Voltage profile needed from electromagnets for EM mu %i',munum))
ylabel('Voltage')
xlabel('angular displacement [deg]')
legend('EM1','EM2','EM3','EM4','EM5','EM6')

figure
plot(phi_t*180/pi,-F_image_profile')
legend('x','y','z')
title(sprintf('Force profile needed from electromagnets for EM mu %i',munum))
xlabel('angular displacement [deg]')
ylabel('force [N]')

figure
plot(phi_t*180/pi,tau_actuator_profile')
legend('x','y','z')
title(sprintf('Torque profile needed from electromagnets for EM mu %i',munum))
xlabel('angular displacement [deg]')
ylabel('Torque [Nm]')

figure
plot(phi_t*180/pi,tau_net)
axis([0 72 -.1 .1])
legend('x','y','z')
title(sprintf('Maximum torque available from electromagnets for EM mu %i',munum))
xlabel('angular displacement [deg]')
ylabel('Torque [Nm]')

figure
plot(phi_t(1:end/2)*180/pi,dU(1:end/2))
title(sprintf('Potential energy associated with overcoming flux pinning potential well for EM mu %i',munum))
xlabel('angular displacement [deg]')
ylabel('energy [J]')

figure
plot(phi_t(1:end/2)*180/pi,W(1:end/2))
title('Work from electromagnets to pop out of potential well along angular path')
xlabel('angular displacement [deg]')
ylabel('energy [J]')
