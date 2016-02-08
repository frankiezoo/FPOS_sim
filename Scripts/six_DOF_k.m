close all
%% Graph translational displacement image forces and stiffness
% figure(1);
% plot(delpos*100,F_image_profile);
% title('Force vs displacement in the y direction');
% xlabel('displacement [cm]');
% ylabel('Force [N]');
% legend('x','y','z');
% 
k=F_image_profile/delpos;
k_x=F_image_profile(1,:)./delpos;
k_y=F_image_profile(2,:)./delpos;
k_z=F_image_profile(3,:)./delpos;
% figure(2);
% plot(delpos*100,[k_x;k_y;k_z]);
% title('Stiffness vs displacement in the y direction');
% xlabel('displacement [cm]');
% ylabel('Stiffness [N/m]');
% legend('x','y','z');

%% Graph rotational displacement image forces and stiffness
% figure(1)
% plot(phi_t*180/pi,tau_image_profile)
% title('Torque vs angular displacement in the y axis')
% xlabel('displacement [deg]')
% ylabel('Torque [Nm]')
% legend('x','y','z')
% 
% k=tau_image_profile/phi_t;
% k_x=tau_image_profile(1,:)./phi_t;
% k_y=tau_image_profile(2,:)./phi_t;
% k_z=tau_image_profile(3,:)./phi_t;
% figure(2)
% plot(phi_t*180/pi,[k_x;k_y;k_z])
% title('Stiffness vs angular displacement in the y axis')
% xlabel('displacement [deg]')
% ylabel('Stiffness [N/m]')
% legend('x','y','z')
% 
%% Now for just one displacement, let's say 1 mm farther away
% k_matrix=zeros(6,6);
% 
% mat_file={'delx.mat',;'dely.mat';'delz.mat';'thetax.mat';'thetay.mat';'thetaz.mat'};
% n=1;
% for num=1:6
%     load(mat_file{num})
%     k_x=F_image_profile(1,:)./delpos;
%     k_y=F_image_profile(2,:)./delpos;
%     k_z=F_image_profile(3,:)./delpos;
%     kt_x=tau_image_profile(1,:)./delpos;
%     kt_y=tau_image_profile(2,:)./delpos;
%     kt_z=tau_image_profile(3,:)./delpos;
%     k_matrix(1,num)=(k_x(1)+k_x(3))/2;
%     k_matrix(2,num)=(k_y(1)+k_y(3))/2;
%     k_matrix(3,num)=(k_z(1)+k_z(3))/2;
%     k_matrix(4,num)=(kt_x(1)+kt_x(3))/2;
%     k_matrix(5,num)=(kt_y(1)+kt_y(3))/2;
%     k_matrix(6,num)=(kt_z(1)+kt_z(3))/2;
% end