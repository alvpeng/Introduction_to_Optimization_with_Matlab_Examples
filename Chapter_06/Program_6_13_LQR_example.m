% 例程 6.13  LQR（线性二次调节器）示例
%  控制目标：将系统从任意初始状态引导至原点，同时最小化优化性能指标
%  系统矩阵
A = [1, 0.1; 0, 1];
B = [0.005; 0.1];
%  时间域（单位：秒）
N = 70;
%  优化性能指标参数
H = [10, 0; 0, 6];
Q = [1, 0; 0, 1];
V = 2;
%  预分配内存
X = zeros(2, 1, N + 1);
U = zeros(1, N + 1);
P = zeros(2, 2, N + 1);
R = zeros(1, 2, N + 1);
%  初始状态
x10 = 5;
x20 = 5;
px1 = 0;
px2 = 0;
%  矩阵递推计算
%  k = 1 ..N + 1
P(:, :, N + 1) = H;
k = N + 1;
while (k >1)
    AUX = V + (B'*P(:, :, k)*B);
    R(1, :, k - 1) = (inv(AUX))*(B'*P(:, :, k)*A);
    P(:, :, k - 1) = (A'*P(:, :,k)* A)+Q -(R(1, :, k - 1)'*AUX*R(1, :, k - 1));
    k = k - 1;
end
figure (1)
%  绘制坐标轴
plot([-2, 8], [0, 0], 'k');
hold on;
plot([0, 0], [-4, 6], 'k');
%  绘制初始状态点
plot(x10, x20, 'r*', 'MarkerSize', 10);
xlabel('x1');  ylabel('x2');
%  最优状态轨迹计算与绘制
k = 1;
X(1, 1, 1) = x10;
X(2, 1, 1) = x20;
while  (k < N + 1)
    px1 = X(1, 1, k);
    px2 = X(2, 1, k);
    plot(px1, px2, 'b.');
    U(1, k) = -R(1, :, k)*X(:, 1, k);
    X(:, 1, k + 1) = (A*X(:, 1, k)) + (B*U(1, k));
    k = k + 1;
end
figure(2)
%  状态反馈矩阵R的变化过程绘制
k = 1;
while  (k<N +1)
    subplot(1, 2, 1)
    plot(k, R(1, 1, k), 'b.');
    hold on;
    subplot(1, 2, 2)
    plot(k, R(1, 2, k), 'b.');
    hold on;
    k = k + 1;
end
subplot(1, 2, 1)
xlabel('K');  ylabel('R1');
subplot(1, 2, 2)
xlabel('K');  ylabel('R2');
