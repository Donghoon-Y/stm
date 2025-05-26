% ==============================
% 1. Load first file: 1.2gyroXgood.txt
% ==============================
dataX = readmatrix(fullfile('.', '1.2gyroXgood.csv'));
data1X = dataX(:, 1:7);

accelangleX_X = data1X(2:end,1);
accelangleY_X = data1X(2:end,2);
gyroX_X = data1X(2:end,3);
gyroY_X = data1X(2:end,4);

% ==============================
% 2. Load second file: 1.2gyroYgood.txt
% ==============================
dataY = readmatrix(fullfile('.', '1.2gyroYgood.csv'));
data1Y = dataY(:, 1:7);

accelangleX_Y = data1Y(2:end,1);
accelangleY_Y = data1Y(2:end,2);
gyroX_Y = data1Y(2:end,3);
gyroY_Y = data1Y(2:end,4);

% ==============================
% 3. Plot all in one figure with 4 subplots
% ==============================
figure;

% --------- X from 1.2gyroXgood.txt ---------
subplot(2,2,1);
plot(accelangleX_X, 'r', 'DisplayName', 'Accel Angle X');
hold on;
plot(gyroX_X, 'g', 'DisplayName', 'GyroX Integrated');
yline(0, 'k--', 'DisplayName', 'y = 0');
xlabel('Sample'); ylabel('Angle (deg)');
title('File X - X-axis');
legend; grid on;

% --------- Y from 1.2gyroXgood.txt ---------
subplot(2,2,2);
plot(accelangleY_X, 'r', 'DisplayName', 'Accel Angle Y');
hold on;
plot(gyroY_X, 'g', 'DisplayName', 'GyroY Integrated');
yline(0, 'k--', 'DisplayName', 'y = 0');
xlabel('Sample'); ylabel('Angle (deg)');
title('File X - Y-axis');
legend; grid on;

% --------- X from 1.2gyroYgood.txt ---------
subplot(2,2,3);
plot(accelangleX_Y, 'r', 'DisplayName', 'Accel Angle X');
hold on;
plot(gyroX_Y, 'g', 'DisplayName', 'GyroX Integrated');
yline(0, 'k--', 'DisplayName', 'y = 0');
xlabel('Sample'); ylabel('Angle (deg)');
title('File Y - X-axis');
legend; grid on;

% --------- Y from 1.2gyroYgood.txt ---------
subplot(2,2,4);
plot(accelangleY_Y, 'r', 'DisplayName', 'Accel Angle Y');
hold on;
plot(gyroY_Y, 'g', 'DisplayName', 'GyroY Integrated');
yline(0, 'k--', 'DisplayName', 'y = 0');
xlabel('Sample'); ylabel('Angle (deg)');
title('File Y - Y-axis');
legend; grid on;

