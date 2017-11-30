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

RfP=150000;
RiP=100000;
RiI=100000;
C1=0.033e-6;
RiPI=100000;
RfPI=100000;
C2=0.01e-6;



tau=.01; %s
Kv=20.02; %Rad/(V*s)
Ktach=.003;
Kadj=1;

sysP=tf([Kadj*RfP*Kv*Ktach],[RiP*tau RiP]);
sysI=tf([Kadj*Kv*Ktach],[RiI*C1*tau RiI*C1 0]);
sysPI=tf([Kadj*RfPI*C2*Kv*Ktach Kadj*Kv*Ktach],[RiPI*C2*tau RiPI*C2 0]);
figure(2)
[r,k]=rlocus(sysP)
figure(3)
rlocus(sysI)
figure(4)
rlocus(sysPI)

