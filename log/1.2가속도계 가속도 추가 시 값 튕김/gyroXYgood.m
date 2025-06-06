clc; clear;

% ==============================
% 1. Load data from both files
% ==============================
dataX = readmatrix(fullfile('.', '1.2gyroXgood.csv'));
dataY = readmatrix(fullfile('.', '1.2gyroYgood.csv'));

% === File X: X축 가속도 증가 ===
accelAngleX_X = dataX(2:end, 1);
gyroAngleX_X  = dataX(2:end, 3);

% === File Y: Y축 가속도 증가 ===
accelAngleY_Y = dataY(2:end, 2);
gyroAngleY_Y  = dataY(2:end, 4);

% ==============================
% 2. Plot Gyro vs Accel (X and Y each)
% ==============================
figure;

% --- X축 비교 (file X)
subplot(2,1,1);
plot(gyroAngleX_X, 'b', 'DisplayName', 'Gyro Angle X');
hold on;
plot(accelAngleX_X, 'r--', 'DisplayName', 'Accel Angle X');
yline(0, 'k--');
xlabel('Sample'); ylabel('Angle (deg)');
title('File X - X Axis (Gyro vs Accel)');
legend; grid on;

% --- Y축 비교 (file Y)
subplot(2,1,2);
plot(gyroAngleY_Y, 'b', 'DisplayName', 'Gyro Angle Y');
hold on;
plot(accelAngleY_Y, 'r--', 'DisplayName', 'Accel Angle Y');
yline(0, 'k--');
xlabel('Sample'); ylabel('Angle (deg)');
title('File Y - Y Axis (Gyro vs Accel)');
legend; grid on;
