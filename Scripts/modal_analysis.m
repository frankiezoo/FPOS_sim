%all the mass and inertia are taken from the CAD
m=6.29891; %kg
Ixx=70075722.65e-6;
Iyy=72352789.20e-6;
Izz=16433895.36e-6;
Ixy=350816.81e-6;
Iyz=298094.20e-6;
Ixz=1305745.27e-6;

%mass and inertia tensor
M=[m 0 0 0 0 0;
   0 m 0 0 0 0;
   0 0 m 0 0 0;
   0 0 0 Ixx Ixy Ixz;
   0 0 0 Ixy Iyy Iyz;
   0 0 0 Ixz Iyz Izz];

%no damping is accounted for the mode analysis
[V,D]=eig(inv(M)*k_matrix)
%the diagonal values represent the squared magnitude of the natural
%frequencies
%the eigenvectors represent axes about which the natural modes vibrate
%along
w_n=sqrt(D)