I_D=1/2*eye(3);
I_B=[1 0 0; 0 2 0; 0 03];
c=1;
w_bn=[0 0 0]';
w_dn=[1 0 0]';
[ddw_dn, ddw_bn] = Kdamper(tau,w_dn,w_bn,dw_dn,dw_bn,I_D,I_B,c)
