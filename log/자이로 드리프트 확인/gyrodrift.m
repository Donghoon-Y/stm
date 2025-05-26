data = readmatrix(fullfile('.' , '1.2gyrodrift.csv'));

data1 = data(:, 1:7);

accelangleX = data1(2:end,1);
accelangleY = data1(2:end,2);
gyroX = data1(2:end,3);
gyroY = data1(2:end,4);
gyroZ = data1(2:end,5);

figure;

% --------- X축 자세 ---------
subplot(2,1,1); % 첫 번째 subplot
plot(accelangleX, 'r', 'DisplayName', 'Accel Angle X');
hold on;
plot(gyroX, 'g', 'DisplayName', 'GyroX Integrated Angle');
yline(0, 'k--', 'DisplayName', 'y = 0');

xlabel('Sample');
ylabel('Angle (deg)');
title('X-axis Attitude: Accel vs Gyro');
legend;
grid on;

% --------- Y축 자세 ---------
subplot(2,1,2); % 두 번째 subplot
plot(accelangleY, 'r', 'DisplayName', 'Accel Angle Y');
hold on;
plot(gyroY, 'g', 'DisplayName', 'GyroY Integrated Angle');
yline(0, 'k--', 'DisplayName', 'y = 0');

xlabel('Sample');
ylabel('Angle (deg)');
title('Y-axis Attitude: Accel vs Gyro');
legend;
grid on;