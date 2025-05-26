clc; clear;

% === 1. 데이터 불러오기 ===
filename = 'filteringdata.csv';  % alpha 0.2 실험
data = readmatrix(filename);

% === 2. 데이터 추출 ===
gyroX = data(2:end,1); gyroY = data(2:end,2); gyroZ = data(2:end,3);
baseGyroX = mean(data(2:11,4)); baseGyroY = mean(data(2:11,5)); baseGyroZ = mean(data(2:11,6));
gyroX_1 = data(2:end,7); gyroY_1 = data(2:end,8); gyroZ_1 = data(2:end,9); % 누적 자이로 각

accelX = data(2:end,10); accelY = data(2:end,11); accelZ = data(2:end,12);
baseAccelX = mean(data(2:11,13)); baseAccelY = mean(data(2:11,14)); baseAccelZ = mean(data(2:11,15));

roll_stm  = data(2:end,16);  % STM에서 계산한 roll
pitch_stm = data(2:end,17);  % STM에서 계산한 pitch
yaw_stm   = data(2:end,18);  % STM에서 계산한 yaw

% === 3. 파라미터 설정 ===
dt = 0.112;
N = length(gyroX);
tau = 0.5;
alpha = tau / (tau + dt);

% === 4. 가속도 기반 각도 계산 ===
accelAngleX = atan2d(accelY, accelZ) - atan2d(baseAccelY, baseAccelZ);
accelAngleY = atan2d(-accelX, sqrt(accelY.^2 + accelZ.^2)) - atan2d(-baseAccelX, sqrt(baseAccelY^2 + baseAccelZ^2));

% === 5. 자이로 적분 각도 계산 ===
gyroAngleX = zeros(N,1); gyroAngleY = zeros(N,1);
for i = 2:N
    gyroAngleX(i) = gyroAngleX(i-1) + (gyroX(i) - baseGyroX) * dt;
    gyroAngleY(i) = gyroAngleY(i-1) + (gyroY(i) - baseGyroY) * dt;
end

% === 6. 상보필터 (MATLAB) 구현 ===
compAngleX = zeros(N,1); compAngleY = zeros(N,1);
for i = 2:N
    compAngleX(i) = alpha * (compAngleX(i-1) + (gyroX(i) - baseGyroX) * dt) + (1 - alpha) * accelAngleX(i);
    compAngleY(i) = alpha * (compAngleY(i-1) + (gyroY(i) - baseGyroY) * dt) + (1 - alpha) * accelAngleY(i);
end

% === 7. 결과 시각화 ===
figure;

subplot(2,1,1);
plot(accelAngleX, 'g--', 'DisplayName', 'Accel Only'); hold on;
plot(gyroAngleX, 'b:', 'DisplayName', 'Gyro Only');
plot(roll_stm, 'm', 'DisplayName', 'STM Complementary');
plot(compAngleX, 'k', 'DisplayName', 'MATLAB Complementary');
legend; title('Roll Angle (X-axis)'); grid on;

subplot(2,1,2);
plot(accelAngleY, 'g--', 'DisplayName', 'Accel Only'); hold on;
plot(gyroAngleY, 'b:', 'DisplayName', 'Gyro Only');
plot(pitch_stm, 'm', 'DisplayName', 'STM Complementary');
plot(compAngleY, 'k', 'DisplayName', 'MATLAB Complementary');
legend; title('Pitch Angle (Y-axis)'); grid on;
