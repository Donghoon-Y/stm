data = readmatrix(fullfile('.' , '0_90_.txt'));

data1 = data(:, 1:7);

accelangleX = data1(2:end,1);
accelangleY = data1(2:end,2);
gyroX = data1(2:end,3);
gyroY = data1(2:end,4);
gyroZ = data1(2:end,5);
filterangleX = data1(2:end,6);
filterangleY = data1(2:end,7);

xrange = 120:180;

% 그래프 그리기
figure;
plot(xrange, accelangleX(120:180), 'r', 'DisplayName', 'Accel Angle X');
hold on;
plot(xrange, filterangleX(120:180), 'b', 'DisplayName', 'Filtered Angle X');
plot(xrange, gyroX(120:180), 'g', 'DisplayName', 'GyroX Integrated Angle');
yline(90, 'k--', 'DisplayName', 'y = 90');

xlabel('Sample');
ylabel('Angle (deg)');
title('X-axis Attitude: Accel vs Gyro vs Filter');
legend;
grid on;