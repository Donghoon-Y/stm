clc; clear;

% ==============================
% 1. Load data from both files
% ==============================
dataX = readmatrix(fullfile('.', '1.2gyroXgood.csv'));
dataY = readmatrix(fullfile('.', '1.2gyroYgood.csv'));

% === File X: Y축 회전으로 X센서 영향 확인 ===
accelAngleX_X = dataX(2:end, 1);
accelAngleY_X = dataX(2:end, 2);
gyroAngleX_X  = dataX(2:end, 3);
gyroAngleY_X  = dataX(2:end, 4);

% === File Y: Y축 회전 및 복원 ===
accelAngleX_Y = dataY(2:end, 1);
accelAngleY_Y = dataY(2:end, 2);
gyroAngleX_Y  = dataY(2:end, 3);
gyroAngleY_Y  = dataY(2:end, 4);

% ==============================
% 2. Plot in 4 subplots
% ==============================
figure;

% File X - X축 비교
subplot(2,2,1);
plot(accelAngleX_X, 'r', 'DisplayName', 'Accel Angle X');
hold on;
plot(gyroAngleX_X, 'g', 'DisplayName', 'Gyro Angle X');
yline(0, 'k--');
xlabel('Sample'); ylabel('Angle (deg)');
title('File X - X-axis Rotation');
legend; grid on;

% File X - Y축 비교
subplot(2,2,2);
plot(accelAngleY_X, 'r', 'DisplayName', 'Accel Angle Y');
hold on;
plot(gyroAngleY_X, 'g', 'DisplayName', 'Gyro Angle Y');
yline(0, 'k--');
xlabel('Sample'); ylabel('Angle (deg)');
title('File X - Y-axis');
legend; grid on;

% File Y - X축 비교
subplot(2,2,3);
plot(accelAngleX_Y, 'r', 'DisplayName', 'Accel Angle X');
hold on;
plot(gyroAngleX_Y, 'g', 'DisplayName', 'Gyro Angle X');
yline(0, 'k--');
xlabel('Sample'); ylabel('Angle (deg)');
title('File Y - X-axis');
legend; grid on;

% File Y - Y축 비교
subplot(2,2,4);
plot(accelAngleY_Y, 'r', 'DisplayName', 'Accel Angle Y');
hold on;
plot(gyroAngleY_Y, 'g', 'DisplayName', 'Gyro Angle Y');
yline(0, 'k--');
xlabel('Sample'); ylabel('Angle (deg)');
title('File Y - Y-axis Rotation & Return');
legend; grid on;
