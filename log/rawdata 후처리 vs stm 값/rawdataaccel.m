clc; clear all;
data = readmatrix(fullfile('.', 'rawdataaccel2.xlsx'));

% Raw 데이터
accelX = data(2:end,1); accelY = data(2:end,2); accelZ = data(2:end,3);
accelXbase = data(2:end,4); accelYbase = data(2:end,5); accelZbase = data(2:end,6);

% STM에서 실시간으로 저장한 각도
accelXangle_stm = data(2:end,7);
accelYangle_stm = data(2:end,8);

% 후처리용 계산
N = length(accelX);

% 기준각
baseAngleX = atan2(accelYbase(1), accelZbase(1)) * 180 / pi;
baseAngleY = atan2(-accelXbase(1), sqrt(accelYbase(1)^2 + accelZbase(1)^2)) * 180 / pi;

% 결과 저장
accelAngleX = zeros(N,1); accelAngleY = zeros(N,1);

for i = 1:N
    % Accel 각도
    ax = atan2(accelY(i), accelZ(i)) * 180 / pi;
    ay = atan2(-accelX(i), sqrt(accelY(i)^2 + accelZ(i)^2)) * 180 / pi;

    accelAngleX(i) = ax - baseAngleX;
    accelAngleY(i) = ay - baseAngleY;
end

% ---------- 시각화 ----------
figure;

% Accel X 비교
subplot(2,1,1);
plot(accelXangle_stm, 'r', 'DisplayName', 'STM Accel X');
hold on;
plot(accelAngleX, 'b--', 'DisplayName', 'MATLAB Accel X');
legend; title('Accel Angle X'); grid on;

% Accel Y 비교
subplot(2,1,2);
plot(accelYangle_stm, 'r', 'DisplayName', 'STM Accel Y');
hold on;
plot(accelAngleY, 'b--', 'DisplayName', 'MATLAB Accel Y');
legend; title('Accel Angle Y'); grid on;
