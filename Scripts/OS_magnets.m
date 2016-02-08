% OS Magnets, sent by Professor Peck
%
clear all; close all
[X,Y,Z]=sphere(50);
%
% Generate sphere centers with fancy math
A=[ 0 1 1 1 1 1; 1 0 1 -1 -1 1; 1 1 0 1 -1 -1; 1 -1 1 0 1 -1; 1 -1 -1 1 0 1; 1 1 -1 -1 1 0];
NA=null(A+sqrt(5)*eye(6)).';
VX=[NA -NA]/norm(NA(:,1));
spherescale=0.1;
for i=1:size(VX,2),
    XX(i,1:size(X,1),1:size(X,2))=spherescale*X+VX(1,i);
    YY(i,1:size(Y,1),1:size(Y,2))=spherescale*Y+VX(2,i);
    ZZ(i,1:size(Z,1),1:size(Z,2))=spherescale*Z+VX(3,i);
end    
%
figure(1)
clf
plot3(VX(1,:),VX(2,:),VX(3,:),'r*')
hold on
for i=1:size(VX,2),
    g(i)=surf(squeeze(XX(i,:,:)),squeeze(YY(i,:,:)),squeeze(ZZ(i,:,:)));
end
g0=surf(X,Y,Z);
%
colormap jet
shading interp
set(g0,'facecolor',[0 0 0])
set(g0,'specularcolorreflectance',0)
%
for i=1:size(VX,2),
    set(g(i),'facecolor',[.5 .5 .6]);
end    
l1=light;
%
axis('equal')
% xlabel('x')
% ylabel('y')
% zlabel('z')
set(gcf,'color','w')
set(gca,'xcolor','w')
set(gca,'ycolor','w')
set(gca,'zcolor','w')
set(gca,'view',[30.5 76])
