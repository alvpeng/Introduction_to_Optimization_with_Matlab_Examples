% 例程 6.16  调用 MATLAB 的卡尔曼滤波函数
%  状态估计示例
%  调用kalman()函数实现
%  系统矩阵
A = [0.9, 0.5; -0.1, 0.5];
B = [0.005; 0.1];
G = [0.5; 0.5];
C = [1, 1];
D = 0;
H = 0.3;
sys = ss(A, [B, G], C, [D, H], 1);  %  构建离散状态空间模型
%  噪声协方差
cw = 0.1;
cv = 0.1;
%  调用卡尔曼滤波函数
[K, L, P, M, Z] = kalman(sys, cw, cv);  %  卡尔曼滤波参数
%  暂态响应实验
N = 30;
x = zeros(2, N);  u = zeros(1, N);  y = zeros(1, N);
xe = zeros(2, N);  xm = zeros(2, N);  ye = zeros(1, N);
x0 = [10; 10];  %  初始状态
x(:, 1) = x0;
xe(:, 1) = [0; 0];
xm(:, 1) = [0; 0];
for nn =1:N - 1
%  被控对象动态响应
u(:, nn) = 0;  %  无输入
nw = sqrt(cw)*randn(1);
nv = sqrt(cv)*rand(1);
x(:, nn + 1) = (A*x(:, nn)) + (B*u(nn)) + (G*nw);
y(nn) = (C*x(:, nn)) + (D*u(nn)) + (H*nv);
%  卡尔曼估计
xe(:, nn + 1) = (A*xe(:, nn)) + (B*u(nn)) + L*(y(nn) - (C*xe(:, nn)) - (D*u(nn)));
ye(nn) = C*xm(:, nn) + (D*u(nn));
xm(:, nn ) = xe(:, nn) + M*(y(nn) - (C*xe(:, nn)) - (D*u(nn)));
end
%  显示系统暂态响应
figure(1)
subplot(1, 2, 1)
plot(x0(1), 'ko '); hold on; %初始点
plot(x(1, :), 'r-');  plot(xe(1, :), 'b-');
ylabel('状态x1'); xlabel('迭代步数');
axis ([0, N, -1, 20]);
subplot(1, 2, 2)
plot(x0(2), 'ko'); hold on;  %  初始点
plot(x(2, :), 'r-');  plot(xe(2, :), 'b-');
ylabel('状态x2 '); xlabel ('迭代步数');
axis([0, N, -5, 15]);
%  输出结果
L
