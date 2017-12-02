clear all;
close all;

%% Part 2 a) and b)
Part2_a_V = [1.7,2,3,4,5,6,7,8,9,10]; % [V]
Part2_a_Et = -[-0.40215,-0.55697,-1.11,-1.67,-2.25,-2.82,-3.38,-3.93,-4.49,-5.02]; % [V]
Part2_a_MUT = [0.6754,0.94198,1.87,2.83,3.77,4.71,5.63,6.53,7.49,8.36]; % [V]

KtachSens = 3; % V/kRPM

Part2_a_EtOmega = Part2_a_Et/KtachSens; % [kRPM]

Part2_a_fit = polyfit(Part2_a_EtOmega,Part2_a_MUT,1);
KeCalc = Part2_a_fit(1); % 4.9817 [V/kRPM] - right on the money

Part2_a_fitY = Part2_a_EtOmega*Part2_a_fit(1) + Part2_a_fit(2);

figure(1);
hold on;
plot(Part2_a_EtOmega,Part2_a_MUT,'O');
plot(Part2_a_EtOmega,Part2_a_fitY,'--');
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
Part3_b_Time = Part3_b_data(:,1);
Part3_b_TachV = Part3_b_data(:,2);
Part3_b_InputV = Part3_b_data(:,3);

figure(2);
hold on;
plot(Part3_b_Time,Part3_b_TachV);
plot(Part3_b_Time,Part3_b_InputV);
xlabel('Time (s)','FontSize',12);
ylabel('Voltages (V)','FontSize',12);
legend('Location','best','Tachometer Output','Input Voltage e_a');

% data reconfiguration
Part3_b_Time = Part3_b_Time(501:2500);
Part3_b_TachV = Part3_b_TachV(501:2500);
Part3_b_InputV = Part3_b_InputV(501:2500);

Part3_b_TachV = smooth(smooth(Part3_b_TachV));
Part3_b_InputV = smooth(smooth(Part3_b_InputV));

Part3_b_TachV = Part3_b_TachV - mean(Part3_b_TachV(1:100));

Part3_b_FinalV = mean(Part3_b_TachV(1000:end));
% 63.2% tau point
Part3_b_TauV = 0.632*Part3_b_FinalV;

for i = 1:length(Part3_b_Time)
    if (Part3_b_Time(i) > -0.006389)
        Part3_b_Time = Part3_b_Time - Part3_b_Time(i);
        break;
    end
end

for i = 1:length(Part3_b_TachV)
    if (Part3_b_TachV(i) > Part3_b_TauV)
        Part3_b_tauInd = i;
        Part3_b_tauTime = Part3_b_Time(i);
        break;
    end
end

figure(3);
hold on;
plot(Part3_b_Time,Part3_b_TachV);
plot(Part3_b_Time(Part3_b_tauInd),Part3_b_TachV(Part3_b_tauInd),'O');
xlabel('Time (s)','FontSize',12);
ylabel('Voltages (V)','FontSize',12);
legend('Location','best','Tachometer Output','Tau Point');

% tauTime = JR/(BR + KtKe) with Kt, Ke, R known
% gain = KtKtach/(BR + KtKe)
% Total step input amplitude: 16 V
% Total step response final value: 8 V
inputGain = Part3_b_InputV(1);
stepGain = Part3_b_TachV(end);
totalGain = stepGain/inputGain;

Bcalc = 1/R*(Kt*KtachSens/totalGain - Kt*KeCalc);

Jcalc = Part3_b_tauTime*(Bcalc*R + Kt*KeCalc)/R; % [Oz-in-s/kRPM]
Jcalc = Jcalc/1000/(2*pi/60); % [oz-in-s^2/rad]

% using the B from spec sheet and tau from data
Jcalc_betterB = Part3_b_tauTime*(2*B*R + Kt*KeCalc)/R/1000/(2*pi/60);

%% Part 3 e)
% Import data for disturbance
Part3_e_data = importdata('Data from Section 3 Step 9.lvm','\t',33);
Part3_e_time = Part3_e_data.data(:,1);
Part3_e_tachV = Part3_e_data.data(:,2);
Part3_e_inputV = Part3_e_data.data(:,3);

Part3_e_tachV = smooth(smooth(Part3_e_tachV));

for i = 1:length(Part3_e_time)
    if (Part3_e_time(i) > 0.0221)
        Part3_e_time = Part3_e_time - Part3_e_time(i);
        break;
    end
end

Part3_e_stV = mean(Part3_e_tachV(1:500));
Part3_e_endV = mean(Part3_e_tachV(3000:end));
Part3_e_tauV = Part3_e_endV + (Part3_e_stV - Part3_e_endV)*0.368;

for i = 1:length(Part3_e_tachV)
    if (Part3_e_tachV(i) < Part3_e_tauV)
        Part3_e_tauInd = i;
        break;
    end
end

Part3_e_tauTime = Part3_e_time(Part3_e_tauInd);
Part3_e_tauVolt = Part3_e_tachV(Part3_e_tauInd);
Part3_e_SSE = Part3_e_stV - Part3_e_endV;

figure(4);
hold on;
plot(Part3_e_time,Part3_e_tachV);
plot(Part3_e_time(Part3_e_tauInd),Part3_e_tachV(Part3_e_tauInd),'O');
xlabel('Time (s)','FontSize',12);
ylabel('Tachometer Voltage (V)','FontSize',12);
legend('Location','best','Tach Output','Tau Point');