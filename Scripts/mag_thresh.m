function boolean=mag_thresh(r,m)
%is this magnet in the threshold of actuation?
%this function finds the threshold distance that a superconductor will be
%affected by a magnetic dipole
%the magnetic flux density is defined by this url: http://en.wikipedia.org/wiki/Magnetic_dipole
%for the YBCO disks, 0.02T is the minimum flux in the plane parallel to the
%copper oxide planes that will contribute to actuation

mu_0=4*10^-7; %N/A^2
B=mu_0/4/pi*(3*r*(dot(m,r))/norm(r)^5-m/norm(r)^3);
disp(norm(B))
if norm(B)>0.02
    boolean=1;
else
    boolean=0;
end
