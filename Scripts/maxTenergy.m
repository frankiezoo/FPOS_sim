%to find the total maximum incoming velocity for capture, find the
%potential energy to bring the OS in from negative infinity distance to 0
%this analysis assumes 10 cm is relatively far away enough to be considered
%the zero potential energy point
mat_file={'dely.mat';'delz.mat'};
%as you well notice, delx is not in this set. When looking at the placement
%of the OSA in the SROA well, the x direction will cause the OS to collide
%into the SRO
U_total=0;
for num=1:2
    load(mat_file{num})
    %integrate work from the "spring" over distance to get potential energy
    U_total=U_total+sum(F_image_profile)*(delpos(1)-delpos(2));
end
%conservative work doesn't depend on direction, allowed to sum along all
%directions
sum(U_total)
%mass of the OS taken from William Wilson's version 1 CAD
m=6.29891; %kg
%magnitude of maximum incoming velocity acceptable for images to safely
%accept
%sum of kinetic energy and potential energy remains the same
v=sqrt(sum(U_total)*2/m)