KGcP=RfP/RiP;
KGcI=1/(RiI*C1


sysP=tf([KGcP*Kt*Ktach],[1 (Rmotor*B+Kt*Ke)/(J*Rmotor)]);
sysI=tf([KGcI*Kt*Ktach],[1 (Rmotor*B+Kt*Ke)/(J*Rmotor)]);
sysPI=tf([KGcPI*Kt*Ktach],[1 (Rmotor*B+Kt*Ke)/(J*Rmotor)]);
