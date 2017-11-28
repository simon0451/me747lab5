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

%% Part 3 a) and b)
% ea - KeW -> 1/ (Ls+R) -> Kt -> 1/(2Js+2B) -> W

% To find stall torque, plot torque vs. omega. The region where omega
% increases but torque remains constant is the stall torque. Spec sheet
% says 12 oz-in

% ch. 0: Tach output ch. 1: ei after op-amp
Part3_b_data = importdata('Data from Section 3 Step 9.lvm','\t',33);
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

J = 0.0004; % [oz-in-s^2]
L = 1.3e-3; % [H]
B = 0.2/1000/(2*pi/60); % [oz-in-s/rad]
R = 4.2; % [ohm]

s = 2*pi*0.001; % [rad/s]
einput = mean(Part3_InputV);
torque_6V = einput - KeCalc*(einput/(2*J*s+2*B)*Kt)