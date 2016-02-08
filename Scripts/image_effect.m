function [F_body_images,tau_body_images,U_images]=image_effect(OS_mu,OS_xyz,...
    OS_mu_fc,fc_xyz,origin)
%F_body_images is the total force on the body due to mobile and frozen
% image effects
%tau_body_images is the total torque on the body due to mobile and frozen
% image effects
%frozen_lists and mobile_lists keeps track of the individual mobile and
% frozen image effects
%OS_mu are the magnetic moment dipoles of the permanent magnets on the OS
%OS_xyz are the magnet positions on the OS
%OS_mu_fc are the field cooled magnetic moment dipoles of the permanent
% magnets on the OS
%fc_xyz are the field cooled positions of the permanent magnets on the OS
%origin is an arbitrary point on the superconductor surface that I have
% chosen to be the center of the superconductor disk surface

%F_body_sum and tau_body_sum is to keep track of the communative effort of
%all frozen and mobile images on magnet i, correlating to row i
F_body_sum=zeros(size(OS_mu,1),3);
tau_body_sum=zeros(size(OS_mu,1),3);
U_msum=zeros(size(OS_mu,1));
U_fsum=zeros(size(OS_mu,1));
%frozen_lists and mobile_lists goes more in depth than F_body_sum and
%tau_body_sum, storing the individual effect of every frozen and mobile
%image where:
%the first column represents magnet i
%the second column represents magnet j
%third to fifth columns represent force on magnet i due to j's image
%sixth to eighth columns represent torque on magnet i due to j's image
frozen_lists=zeros(size(OS_mu,1)^2,8,size(origin,1));
mobile_lists=zeros(size(OS_mu,1)^2,8,size(origin,1));

%initialize row counter
row=1;
%% Sum frozen and mobile images across different superconductors and all magnets
for k=1:size(origin,1) %sift through all the superconductors
    
    for i=1:size(OS_xyz,1) %sift through all the magnets i
        
        mu_mag_i=OS_mu(i,:);
        pos_mag_i=OS_xyz(i,:);
        O=origin(k,:);
        
        for j=1:size(OS_xyz,1) %sift through all the magnets j that generate images
            
            mu_mag_j=OS_mu(j,:);
            pos_mag_j=OS_xyz(j,:);
            mu_mag_fc=OS_mu_fc(j,:);
            pos_fc=fc_xyz(j,:);
            
            %find the contribution of each field cooled image on all the
            %permanent magnets
            effect='frozen';
            [F,tau,U]=calculate_Ftau(mu_mag_i,mu_mag_j,mu_mag_fc,...
                pos_mag_i,pos_mag_j,pos_fc,O,effect);

            F_body_sum(i,:)=F_body_sum(i,:)+F;
            tau_body_sum(i,:)=tau_body_sum(i,:)+tau+cross(pos_mag_i,F);
            U_fsum(i)=U_fsum(i)+U;
            %this list is for debugging storing all frozen image effects,
            %first column the magnet, second column the frozen image, 3:5
            %column the force, 6:8 the torque
            frozen_lists(row,1,k)=i;
            frozen_lists(row,2,k)=j;
            frozen_lists(row,3:5,k)=F;
            frozen_lists(row,6:8,k)=tau;      

            %find the contribution of this magnet's mobile image on
            %the i_th source magnet
            effect='mobile';
            [F,tau,U]=calculate_Ftau(mu_mag_i,mu_mag_j,mu_mag_fc,...
                pos_mag_i,pos_mag_j,pos_fc,O,effect);
            
            F_body_sum(i,:)=F_body_sum(i,:)+F;
            tau_body_sum(i,:)=tau_body_sum(i,:)+tau+cross(pos_mag_i,F);
            U_msum(i)=U_msum(i)+U;
            %this list is for debugging storing all mobile image effects,
            %first column the magnet, second column the frozen image, 3:5
            %column the force, 6:8 the torque
            mobile_lists(row,1,k)=i;
            mobile_lists(row,2,k)=j;
            mobile_lists(row,3:5,k)=F;
            mobile_lists(row,6:8,k)=tau;

            row=row+1;
        end
    end
end

%sum columns to get the total force and torque on the body
F_body_images=sum(F_body_sum,1)';
tau_body_images=sum(tau_body_sum,1)';
U_images=[sum(sum(U_msum,1)) sum(sum(U_fsum,1))];
