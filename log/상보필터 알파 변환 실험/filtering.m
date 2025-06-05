clc; clear;

% === 1. 데이터 불러오기 ===
filename = 'alpha_0.8.csv';
data = readmatrix(filename);

% === 2. 데이터 추출 ===
gyroX = data(2:end,1); gyroY = data(2:end,2); gyroZ = data(2:end,3);
baseGyroX = mean(data(2:11,4)); baseGyroY = mean(data(2:11,5)); baseGyroZ = mean(data(2:11,6));
gyroAngleX_stm = data(2:end,7); gyroAngleY_stm = data(2:end,8);
accelX = data(2:end,10); accelY = data(2:end,11); accelZ = data(2:end,12);
baseAccelX = mean(data(2:11,13)); baseAccelY = mean(data(2:11,14)); baseAccelZ = mean(data(2:11,15));
roll_stm  = data(2:end,16); pitch_stm = data(2:end,17);

% === 3. 필터 파라미터 설정 ===
dt = 0.112;
Fs = 1 / dt;
fc = 1.5;  % 필터 cutoff frequency [Hz]

% === 4. 가속도 기반 각도 계산 ===
accelAngleX = atan2d(accelY, accelZ) - atan2d(baseAccelY, baseAccelZ);
accelAngleY = atan2d(-accelX, sqrt(accelY.^2 + accelZ.^2)) - atan2d(-baseAccelX, sqrt(baseAccelY^2 + baseAccelZ^2));

% === 5. 자이로 적분 각도 계산 (STM 초기값 반영) ===
N = length(gyroX);
gyroAngleX = zeros(N,1); 
gyroAngleY = zeros(N,1);
gyroAngleX(1) = gyroAngleX_stm(1);
gyroAngleY(1) = gyroAngleY_stm(1);
for i = 2:N
    gyroAngleX(i) = gyroAngleX(i-1) + (gyroX(i) - baseGyroX) * dt;
    gyroAngleY(i) = gyroAngleY(i-1) + (gyroY(i) - baseGyroY) * dt;
end

% === 6. 필터 적용 ===
accelAngleX_LPF = lowpass(accelAngleX, fc, Fs);
accelAngleY_LPF = lowpass(accelAngleY, fc, Fs);
gyroAngleX_HPF = highpass(gyroAngleX, fc, Fs);
gyroAngleY_HPF = highpass(gyroAngleY, fc, Fs);

% === 7. 상보필터 = LPF(Accel) + HPF(Gyro) ===
compAngleX = accelAngleX_LPF + gyroAngleX_HPF;
compAngleY = accelAngleY_LPF + gyroAngleY_HPF;

% === 8. 결과 시각화 ===
figure;

subplot(2,1,1);
plot(accelAngleX, 'g', 'DisplayName', 'Accel Only'); hold on;
plot(gyroAngleX, 'b', 'DisplayName', 'Gyro Only');
plot(roll_stm, 'm', 'DisplayName', 'STM Complementary');
plot(compAngleX, 'k', 'DisplayName', 'Filtered Complementary');
legend; title('Roll Angle (X-axis)'); grid on;

subplot(2,1,2);
plot(accelAngleY, 'g', 'DisplayName', 'Accel Only'); hold on;
plot(gyroAngleY, 'b', 'DisplayName', 'Gyro Only');
plot(pitch_stm, 'm', 'DisplayName', 'STM Complementary');
plot(compAngleY, 'k', 'DisplayName', 'Filtered Complementary');
legend; title('Pitch Angle (Y-axis)'); grid on;
