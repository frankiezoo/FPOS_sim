function [ddw_dn, ddw_bn] = Kdamper(tau,w_dn,w_bn,dw_dn,dw_bn,I_D,I_B,c)

w_bn_crs=crs(w_bn);
w_dn_crs=crs(w_dn);
dw_bn_crs=crs(dw_bn);
dw_dn_crs=crs(dw_dn);

ddw_dn=-inv(I_D)*(dw_dn_crs*I_D*w_dn+w_dn_crs*I_D*dw_dn+c*(dw_dn-dw_bn)+tau);
ddw_bn=-inv(I_B)*(I_D*ddw_dn+w_bn_crs*I_B*dw_bn+dw_bn_crs*I_B*w_bn-c*(dw_dn-dw_bn)+tau);
end

function wcrs=crs(w)
wcrs=[ 0 -w(3) w(2);
    w(3) 0 -w(1);
    -w(2) w(1) 0];
end