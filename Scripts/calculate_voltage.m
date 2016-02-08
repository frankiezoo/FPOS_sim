%%This script calculates the individual efforts of each electromagnet in
%%the electromagnetic configuration to command a certain slew

%% initialize time profiles important to slew maneuver
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
%% for each time step in the slew, the OS location and orientation is updated
for time=1:length(t)
    %% calculate image effects on the 12 permanent magnets
    [F_body_images,tau_body_images,U_images]=image_effect(OS_mu(:,:,time),OS_xyz(:,:,time),...
        OS_mu_fc,fc_xyz,origin);
%     pause %to check body image effects after a certain time step during a maneuver
    
    %store the image effects in the F_image and tau_image profiles
    F_image_profile(:,time)=F_body_images';
    tau_image_profile(:,time)=tau_body_images';
    U_image_profile(:,time)=U_images';
    %% calculate the force and torque desired on the body
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
    
    %% Calculate the needed electromagnet voltage with a pseudoinverse
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
            %calculate_dV is a variation of villani. Villani requires mu
            %components and the position vector between them. Within
            %calculate_dV, the electromagnet's magnetic dipole/voltage is
            %substituted for force and torque per unit Volt
            [dF_dV,dtau_dV]=calculate_dV(mu_mag_i,pos_mag_i,pos_mag_j);
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