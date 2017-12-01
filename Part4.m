clear all; close all;
%% 4a
% loading data
lvtdata = importdata('Data from Section 4 Step 5 P Controller.lvm','\t',34);
lvtT = lvtdata.data(:,2);
lvtV = lvtdata.data(:,3);
time=(0:0.000655:0.000655*4998)',;
% cut out the extra parts
%lvtT = lvtT(1:1500);
%lvtV = lvtV(1:1500);
figure(1)
plot(time,lvtT,time,lvtV)

Rf=150000;
Ri=100000;
C1=0.033e-6;
C2=0.01e-6;



tau=.01; %s
Kv=20.02; %Rad/(V*s)
Ktach=.003; %V/rpm
Ktach=(Ktach*60)/(2*pi); %V/rad/s
Kadj=1;
%P
KGcP=Rf/Ri;

sysP=tf([Kadj*KGcP*Kv*Ktach],[tau 1]);

figure(2)
[r,k]=rlocus(sysP)
title('Root Locus with P control')
sP = (1/tau)+KGcP*Ktach*(Kv/tau); %about -215
tauP=1/sP;
%I
KGcI=1/(Ri*C1)
sysI=tf([Kadj*KGcI*Kv*Ktach],[RiI*C1*tau RiI*C1 0]);

figure(3)
rlocus(sysI)
title('Root Locus with I Control')

syms s
eqn=1+(KGcI*Kv*Ktach)/(tau*s^2+s);
sI=solve(eqn,s);
tauI=1/50;

%PI
sysPI=tf([Kadj*Rf*C2*Kv*Ktach Kadj*Kv*Ktach],[tau 1 0]);

figure(4)
rlocus(sysPI)
title('Root Locus for PI Control')

syms s
eqn=1+((Rf*C2*s*Kv*Ktach)+(Kv*Ktach))/((tau*Ri*C2*(s^2))+(Ri*C2*s)) == 0;
sPI = solve(eqn,s)
tauPI = 1/93.0148;

