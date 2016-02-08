function dcm=ea2dcm(a,phi)
%%transforms euler axis angle representation to direction cosine matrix
%%http://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions#Rotation_matrix_.E2.86.94_Euler_angles
a=a/norm(a);
dcm=zeros(3,3);
dcm(1,1)=(1-cos(phi))*a(1)^2+cos(phi);
dcm(1,2)=(1-cos(phi))*a(1)*a(2)-a(3)*sin(phi);
dcm(1,3)=(1-cos(phi))*a(1)*a(3)+a(2)*sin(phi);
dcm(2,1)=(1-cos(phi))*a(1)*a(2)+a(3)*sin(phi);
dcm(2,2)=(1-cos(phi))*a(2)^2+cos(phi);
dcm(2,3)=(1-cos(phi))*a(2)*a(3)-a(1)*sin(phi);
dcm(3,1)=(1-cos(phi))*a(1)*a(3)-a(2)*sin(phi);
dcm(3,2)=(1-cos(phi))*a(3)*a(2)+a(1)*sin(phi);
dcm(3,3)=(1-cos(phi))*a(3)^2+cos(phi);