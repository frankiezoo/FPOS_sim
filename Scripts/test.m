close all
clear all
tau=(1+sqrt(5))/2;
OS_xyz=[0 -1 -tau];

D=20.3/100; %m the diameter of the OS
magd=1.905/100; %m the diameter of the 0.75 inch spherical magnets to use
rM=(D-magd)/2; %m this radius corresponds to the center of the magnets
OS_magmom=zeros(size(OS_xyz));
for i=1:size(OS_xyz,1)
    OS_magmom(i,:)=OS_xyz(i,:)/norm(OS_xyz(i,:));
    OS_xyz(i,:)=OS_magmom(i,:)*rM;
end
fc_xyz=OS_xyz;
B_m=8815e-4; %Tesla
d_m=1.905/2/100; %m
mu_0=4*pi*10^-7; %N/A^2
OS_mu=2*pi*B_m*d_m^3/mu_0*OS_magmom;
fc_mu=OS_mu;

SC_xyz=[0 1 tau];
x=1/100; %m separation distance
tSC=1.6/100; %m thickness of superconductor
rSC=D/2+x+tSC/2; %radius of curvature for the superconductors
SC_magmom=zeros(size(SC_xyz));
for i=1:size(SC_xyz,1)
    SC_xyz(i,:)=SC_xyz(i,:)/norm(SC_xyz(i,:))*rSC;
    SC_magmom(i,:)=SC_xyz(i,:)/rSC;
end
origin=SC_xyz-SC_magmom*tSC/2;
SC_line=SC_xyz-SC_magmom*0.01;
% delta=[0 0 .01];
% OS_xyz=OS_xyz+delta;
F_f_list=zeros(size(OS_xyz,1),5,size(OS_xyz,1));
F_m_list=zeros(size(OS_xyz,1),5,size(OS_xyz,1));
for i=1:size(OS_xyz,1)
    row=1;
    for j=1:size(OS_xyz,1)
        [F_f,tau_f]=calculate_Ftau(OS_mu(i,:),OS_mu(j,:),fc_mu(j,:),...
            OS_xyz(i,:),OS_xyz(j,:),fc_xyz(j,:),origin,'frozen')
        [F_m,tau_m]=calculate_Ftau(OS_mu(i,:),OS_mu(j,:),fc_mu(j,:),...
            OS_xyz(i,:),OS_xyz(j,:),fc_xyz(j,:),origin,'mobile')
        F_f_list(row,1,i)=i;
        F_f_list(row,2,i)=j;
        F_f_list(row,3:5,i)=F_f;
        F_m_list(row,1,i)=i;
        F_m_list(row,2,i)=j;
        F_m_list(row,3:5,i)=F_m;
        row=row+1;
    end
    
end
F_f_list
F_m_list
[F_body_images,tau_body_images,frozen_lists,mobile_lists]=image_effect(OS_mu,OS_xyz,...
    fc_mu,fc_xyz,origin)

%%
figure('Name','Test Case 3')
scatter3(OS_xyz(:,1),OS_xyz(:,2),OS_xyz(:,3),375,[0.5,0.5,0.5],'filled')
hold on
scatter3(SC_xyz(:,1),SC_xyz(:,2),SC_xyz(:,3),1000,[0,0,0],'filled')
scatter3(fc_xyz(:,1),fc_xyz(:,2),fc_xyz(:,3),375,[0 0 0.5],'filled')
F_f_line=OS_xyz+F_f_list(3:5)/norm(F_f_list(3:5))*0.01;
F_m_line=OS_xyz+F_m_list(3:5)/norm(F_m_list(3:5))*0.01;
F_tot=F_f_list(3:5)+F_m_list(3:5);
F_tot_line=OS_xyz+F_tot/norm(F_tot)*0.01;
line([OS_xyz(1,1) F_tot_line(1,1)],[OS_xyz(1,2) F_tot_line(1,2)],[OS_xyz(1,3) F_tot_line(1,3)],...
    'LineWidth',4,'Color',[0 1 0])
line([OS_xyz(1,1) F_f_line(1,1)],[OS_xyz(1,2) F_f_line(1,2)],[OS_xyz(1,3) F_f_line(1,3)],...
    'LineWidth',4,'Color',[0 0 1])
line([OS_xyz(1,1) F_m_line(1,1)],[OS_xyz(1,2) F_m_line(1,2)],[OS_xyz(1,3) F_m_line(1,3)],...
    'LineWidth',4,'Color',[1 0 1])
line([SC_xyz(1) SC_line(1)],[SC_xyz(2) SC_line(2)],[SC_xyz(3) SC_line(3)],...
    'LineWidth',4,'Color',[0 0 0])
legend('magnet','superconductor','field cooled position','total force','frozen force','mobile force','normal to superconductor')

figure('Name', 'Test Case 3 XY Plane')
scatter(OS_xyz(:,1),OS_xyz(:,2),375,[0.5,0.5,0.5],'filled')
hold on
scatter(SC_xyz(:,1),SC_xyz(:,2),1000,[0,0,0],'filled')
scatter(fc_xyz(:,1),fc_xyz(:,2),375,[0 0 0.5],'filled')
F_f_line=OS_xyz+F_f/norm(F_f)*0.01;
plot([OS_xyz(:,1) F_tot_line(:,1)],[OS_xyz(:,2) F_tot_line(:,2)],...
    'LineWidth',4,'Color',[0 1 0])
plot([OS_xyz(:,1) F_f_line(:,1)],[OS_xyz(:,2) F_f_line(:,2)],...
    'LineWidth',4,'Color',[0 0 1])
plot([OS_xyz(:,1) F_m_line(:,1)],[OS_xyz(:,2) F_m_line(:,2)],...
    'LineWidth',4,'Color',[1 0 1])
plot([SC_xyz(1) SC_line(1)],[SC_xyz(2) SC_line(2)],...
    'LineWidth',4,'Color',[0 0 0])
legend('magnet','superconductor','field cooled position','total force','frozen force','mobile force','normal to superconductor')

figure('Name', 'Test Case 3 XZ Plane')
scatter(OS_xyz(:,1),OS_xyz(:,3),375,[0.5,0.5,0.5],'filled')
hold on
scatter(SC_xyz(:,1),SC_xyz(:,3),1000,[0,0,0],'filled')
scatter(fc_xyz(:,1),fc_xyz(:,3),375,[0 0 0.5],'filled')
F_f_line=OS_xyz+F_f/norm(F_f)*0.01;
plot([OS_xyz(:,1) F_tot_line(:,1)],[OS_xyz(:,3) F_tot_line(:,3)],...
    'LineWidth',4,'Color',[0 1 0])
plot([OS_xyz(:,1) F_f_line(:,1)],[OS_xyz(:,3) F_f_line(:,3)],...
    'LineWidth',4,'Color',[0 0 1])
plot([OS_xyz(:,1) F_m_line(:,1)],[OS_xyz(:,3) F_m_line(:,3)],...
    'LineWidth',4,'Color',[1 0 1])
plot([SC_xyz(1) SC_line(1)],[SC_xyz(3) SC_line(3)],...
    'LineWidth',4,'Color',[0 0 0])
legend('magnet','superconductor','field cooled position','total force','frozen force','mobile force','normal to superconductor')

figure('Name', 'Test Case 3 YZ Plane')
scatter(OS_xyz(:,2),OS_xyz(:,3),375,[0.5,0.5,0.5],'filled')
hold on
scatter(SC_xyz(:,2),SC_xyz(:,3),1000,[0,0,0],'filled')
scatter(fc_xyz(:,2),fc_xyz(:,3),375,[0 0 0.5],'filled')
F_f_line=OS_xyz+F_f/norm(F_f)*0.01;
plot([OS_xyz(:,2) F_tot_line(:,2)],[OS_xyz(:,3) F_tot_line(:,3)],...
    'LineWidth',4,'Color',[0 1 0])
plot([OS_xyz(:,2) F_f_line(:,2)],[OS_xyz(:,3) F_f_line(:,3)],...
    'LineWidth',4,'Color',[0 0 1])
plot([OS_xyz(:,2) F_m_line(:,2)],[OS_xyz(:,3) F_m_line(:,3)],...
    'LineWidth',4,'Color',[1 0 1])
plot([SC_xyz(2) SC_line(2)],[SC_xyz(3) SC_line(3)],...
    'LineWidth',4,'Color',[0 0 0])
legend('magnet','superconductor','field cooled position','total force','frozen force','mobile force','normal to superconductor')
