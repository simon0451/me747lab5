clear all;
close all;

%% Part 2 a) and b)
Part2_a_V = [1.7,2,3,4,5,6,7,8,9,10]; % [V]
Part2_a_Et = -[-0.40215,-0.55697,-1.11,-1.67,-2.25,-2.82,-3.38,-3.93,-4.49,-5.02]; % [V]
Part2_a_MUT = [0.6754,0.94198,1.87,2.83,3.77,4.71,5.63,6.53,7.49,8.36]; % [V]

KtachSens = 3; % V/kRPM

Part2_a_EtOmega = Part2_a_Et/KtachSens; % [kRPM]

Part2_a_fit = polyfit(Part2_a_EtOmega(2:end),Part2_a_MUT(2:end),1);
KeCalc = Part2_a_fit(1); % 4.9817 [V/kRPM] - right on the money

figure(1);
plot(Part2_a_EtOmega,Part2_a_MUT);
xlabel('\omega (kRPM)','FontSize',12);
ylabel('MUT Voltage (V)','FontSize',12);

%% Part 2 c)
% Conversion factor Kt = 141.6 Ke in British units, in V/rad/s
Kt = 141.6*KeCalc/1000/(2*pi/60); % Kt = 6.7273 Oz-in/A, matches the spec sheet's +/- 10%

%% Part 3 b)
% ea - KeW -> 1/ (Ls+R) -> Kt -> 1/(2Js+2B) -> W

% To find stall torque, plot torque vs. omega. The region where omega
% increases but torque remains constant is the stall torque. Spec sheet
% says 12 oz-in

R = 4.2; % [ohm]
einput = 6;

torque_6V = einput*Kt/R;

%% Part 3 c)
J = 0.0004; % [oz-in-s^2]
B = 0.2; % [oz-in/kRPM]

K = Kt/(2*B*R + Kt*KeCalc); % [kRPM/V] velocity constant

tau_calc = 2*J*R/(2*B*R + Kt*KeCalc); % [s^2 kPRM]
tau = tau_calc*1000*(2*pi/60); % [s-rad]

%% Part 3 d)
% ch. 0: Tach output ch. 1: ei after op-amp
Part3_b_data = importdata('Data from Section 3 Step 7.lvm','\t',33);
Part3_b_data = Part3_b_data.data;
Part3_Time = Part3_b_data(:,1);
Part3_TachV = Part3_b_data(:,2);
Part3_InputV = Part3_b_data(:,3);

figure(2);
hold on;
plot(Part3_Time,Part3_TachV);
plot(Part3_Time,Part3_InputV);
xlabel('Time (s)','FontSize',12);
ylabel('Voltages (V)','FontSize',12);
legend('Location','best','Tachometer Output','Input Voltage e_a');

Part3_Time = Part3_Time(501:2500);
Part3_TachV = Part3_TachV(501:2500);
Part3_InputV = Part3_InputV(501:2500);

Part3_TachV = smooth(smooth(Part3_TachV));
Part3_InputV = smooth(smooth(Part3_InputV));

Part3_TachV = Part3_TachV - mean(Part3_TachV(1:100));

TachV_FinalValue = mean(Part3_TachV(1000:end));

TauV = 0.632*TachV_FinalValue;

for i = 1:length(Part3_Time)
    if (Part3_Time(i) > -0.006389)
        startInd = i;
        break;
    end
end

Part3_Time = Part3_Time - Part3_Time(startInd);

for i = 1:length(Part3_TachV)
    if (Part3_TachV(i) > TauV)
        tauInd = i;
        tauTime = Part3_Time(tauInd);
        break;
    end
end

figure(3);
hold on;
plot(Part3_Time,Part3_TachV);
plot(Part3_Time(tauInd),Part3_TachV(tauInd),'O');
xlabel('Time (s)','FontSize',12);
ylabel('Voltages (V)','FontSize',12);
legend('Location','best','Tachometer Output','Tau Point');

% Total voltage change is from 
%% Part 3 e)
