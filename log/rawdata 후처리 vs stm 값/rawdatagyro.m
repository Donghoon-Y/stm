clc; clear all;
data = readmatrix(fullfile('.', 'rawdatagyro.csv'));

% --- Raw 센서 데이터 ---
gyroX = data(2:end,1); 
gyroY = data(2:end,2); 
gyroZ = data(2:end,3);

gyroXbase = data(2:end,4); 
gyroYbase = data(2:end,5); 
gyroZbase = data(2:end,6);

% --- 시각화 ---
figure;

subplot(3,1,1);
plot(gyroX, 'b', 'DisplayName', 'Raw Gyro X'); hold on;
plot(gyroXbase, 'r--', 'DisplayName', 'Base Gyro X (STM)');
legend; title('Gyro Raw X vs Base'); ylabel('°/s'); grid on;

subplot(3,1,2);
plot(gyroY, 'b', 'DisplayName', 'Raw Gyro Y'); hold on;
plot(gyroYbase, 'r--', 'DisplayName', 'Base Gyro Y (STM)');
legend; title('Gyro Raw Y vs Base'); ylabel('°/s'); grid on;

subplot(3,1,3);
plot(gyroZ, 'b', 'DisplayName', 'Raw Gyro Z'); hold on;
plot(gyroZbase, 'r--', 'DisplayName', 'Base Gyro Z (STM)');
legend; title('Gyro Raw Z vs Base'); ylabel('°/s'); xlabel('Sample Index'); grid on;
%%-------%%

clc; clear all;
data = readmatrix(fullfile('.', 'rawdatagyro.csv'));

% --- Raw 센서 데이터 ---
gyroX = data(2:end,1); gyroY = data(2:end,2); gyroZ = data(2:end,3);
gyroXbase  = data(2:end,4); gyroYbase  = data(2:end,5); gyroZbase = data(2:end,6);

% --- STM에서 실시간 계산한 각도 ---
gyroXangle_stm  = data(2:end,7);
gyroYangle_stm  = data(2:end,8);
gyroZangle_stm  = data(2:end,9);

% --- 후처리 초기화 ---
N = length(gyroX);
dt = 0.112;  % dt를 출력하여 확인한 값

gyroX_1 = 0; gyroY_1 = 0; gyroZ_1 = 0;
gyroX_angle = zeros(N,1); gyroY_angle = zeros(N,1); gyroZ_angle = zeros(N,1);

% --- 자이로 적분 각도 계산 루프 ---
for i = 1:N
    gyroX_1 = gyroX_1 + (gyroX(i) - gyroXbase(i)) * dt;
    gyroY_1 = gyroY_1 + (gyroY(i) - gyroYbase(i)) * dt;
    gyroZ_1 = gyroZ_1 + (gyroZ(i) - gyroZbase(i)) * dt;

    gyroX_angle(i) = gyroX_1;
    gyroY_angle(i) = gyroY_1;
    gyroZ_angle(i) = gyroZ_1;
end

% --- 시각화 ---
figure;

subplot(3,1,1);
plot(gyroXangle_stm, 'r', 'DisplayName', 'STM Gyro X'); hold on;
plot(gyroX_angle, 'b--', 'DisplayName', 'MATLAB Gyro X');
legend; title('Gyro Angle X'); grid on;

subplot(3,1,2);
plot(gyroYangle_stm, 'r', 'DisplayName', 'STM Gyro Y'); hold on;
plot(gyroY_angle, 'b--', 'DisplayName', 'MATLAB Gyro Y');
legend; title('Gyro Angle Y'); grid on;

subplot(3,1,3);
plot(gyroZangle_stm, 'r', 'DisplayName', 'STM Gyro Z'); hold on;
plot(gyroZ_angle, 'b--', 'DisplayName', 'MATLAB Gyro Z');
legend; title('Gyro Angle Z'); grid on;