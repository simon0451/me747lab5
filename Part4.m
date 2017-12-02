clear all; close all;
%% 4b
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
rlocus(sysP);
title('Root Locus with P control')
%I
KGcI=1/(Ri*C1);
sysI=tf([Kadj*KGcI*Kv*Ktach],[tau 1 0]);

figure(3)
rlocus(sysI)
title('Root Locus with I Control')
%PI
sysPI=tf([Kadj*Rf*C2*Kv*Ktach Kadj*Kv*Ktach],[Ri*C2*tau Ri*C2 0]);

figure(4)
rlocus(sysPI)
title('Root Locus for PI Control')
%% 4c
%P
sP = (1/tau)+KGcP*Ktach*(Kv/tau);
tauP=1/sP;

modelP=feedback(sysP,1);
opt=stepDataOptions;
opt.InputOffset=-4;
opt.StepAmplitude=8;

lvtdata = importdata('Data from Section 4 Step 5 P Controller.lvm','\t',34);
Peo = lvtdata.data(:,2);
Ptime=(0:0.000655:0.000655*4998)';
Ptime=Ptime(1335:1488);
Peo=Peo(1335:1488);
Ptime=Ptime-Ptime(1);

figure(5)
plot(Ptime,Peo,'r')
hold on
step(modelP,opt,.1)
title('Step Response with P Control')
xlabel('Time')
ylabel('Voltage (V)')
legend('Recorded Step Response','Predicted Step Response','location','best')
hold off

%I
syms s
eqn=1+(KGcI*Kv*Ktach)/(tau*s^2+s);
sI=solve(eqn,s);

modelI=feedback(sysI,1);

lvtdata = importdata('Data from Section 4 Step 5 I Controller.lvm','\t',34);
Ieo = lvtdata.data(:,2);
Itime=(0:0.000655:0.000655*4998)';
Itime=Itime(1205:1358);
Ieo=Ieo(1205:1358);
Itime=Itime-Itime(1);
figure(6)
plot(Itime,Ieo,'r')
hold on
step(modelI,opt,.1)
title('Step Response with I control')
xlabel('Time')
ylabel('Voltage (V)')
legend('Recorded Step Response','Predicted Step Response','location','best')
hold off

%PI
syms s
eqn=1+((Rf*C2*s*Kv*Ktach)+(Kv*Ktach))/((tau*Ri*C2*(s^2))+(Ri*C2*s)) == 0;
sPI = solve(eqn,s);

modelPI=feedback(sysPI,1);

lvtdata = importdata('Data from Section 4 Step 5 PI Controller.lvm','\t',34);
PIeo = lvtdata.data(:,2);
PItime=(0:0.000655:0.000655*4998)';
PItime=PItime(1094:1247);
PIeo=PIeo(1094:1247);
PItime=PItime-PItime(1);
figure(7)
plot(PItime,PIeo,'r')
hold on
step(modelPI,opt,.1)
title('Step Response with PI control')
xlabel('Time')
ylabel('Voltage (V)')
legend('Recorded Step Response','Predicted Step Response','location','best')
hold off

%% 4d
tauOL=tau;
tauP=1/sP;
tauI=1/50;
tauPI=1/93.0148;

%P
lvtdata = importdata('Data from Section 4 Step 6 P Controller.lvm','\t',34);
Pdeo = lvtdata.data(:,2);
Pdtime=(0:0.000200:0.000200*4998)';

figure(8)
plot(Pdtime,Pdeo,'r')
title('Disturbance Load with P Control')
xlabel('Time')
ylabel('Voltage (V)')
errorP=abs((mean(Pdeo(1:997))-mean(Pdeo(1084:end)))/mean(Pdeo(1:997)));

%I
lvtdata = importdata('Data from Section 4 Step 6 I Controller.lvm','\t',34);
Ideo = lvtdata.data(:,2);
Idtime=(0:0.000655:0.000655*4998)';

figure(9)
plot(Idtime,Ideo,'r')
title('Disturbance Load with P Control')
xlabel('Time')
ylabel('Voltage (V)')
errorI=abs((mean(Pdeo(1:2522))-mean(Pdeo(2582:4168)))/mean(Pdeo(1:2522)));

%PI
lvtdata = importdata('Data from Section 4 Step 6 PI Controller.lvm','\t',34);
PIdeo = lvtdata.data(:,2);
PIdtime=(0:0.000655:0.000655*4998)';

figure(10)
plot(PIdtime,PIdeo,'r')
title('Disturbance Load with PI Control')
xlabel('Time')
ylabel('Voltage (V)')
errorPI=abs((mean(PIdeo(1:1006))-mean(PIdeo(1039:1416)))/mean(PIdeo(1:1006)));