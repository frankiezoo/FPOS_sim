close all

figure
plot(F_body_N.time,F_body_N.data)
title('Forces in the inertial frame')
ylabel('Force [N]')
xlabel('time [sec]')
legend('x','y','z')

figure
plot(tau_body_N.time,tau_body_N.data)
title('Torques in the inertial frame')
ylabel('Torque [N-m]')
xlabel('time [sec]')
legend('x','y','z')

figure
plot(OS_CoM.time,OS_CoM.data)
title('Displacement in the inertial frame')
ylabel('displacement [m]')
xlabel('time [sec]')
legend('x','y','z')

figure
U_bounce=zeros(length(OS_CoM.time),1);
for i=1:length(OS_CoM.time)
    if i<length(OS_CoM.time)
        U_bounce(i+1)=U_bounce(i)-1/2*(bounce_force.data(i,:)+bounce_force.data(i+1,:))*...
            (OS_CoM.data(i+1,:)'-OS_CoM.data(i,:)');%...
%             -1/2*(torque_bounce.data(i,:)+torque_bounce.data(i+1,:))*...
%             (phi.data(i+1,:)'-phi.data(i,:)');
    end
end
plot(TE.time,TE.data)
hold on
plot(TE_SROA.time,TE_SROA.data,'r')
frozen=reshape(U_images.data(1,1,:),length(TE.time),1);
mobile=reshape(U_images.data(1,2,:),length(TE.time),1);
plot(U_images.time,frozen,'c')
plot(U_images.time,mobile,'g')
plot(U_images.time,U_bounce,'m')
total=TE.data+TE_SROA.data+frozen+mobile+U_bounce;
plot(U_images.time,total,'k')
title('Energy of system')
ylabel('Energy [J]')
xlabel('time [sec]')
legend('T OSA','T SROA','U frozen','U mobile image','U bounce','total')

figure
plot(TE.time,log10(total-total(1)))
title('log10 error of energy of system')
xlabel('time [sec]')