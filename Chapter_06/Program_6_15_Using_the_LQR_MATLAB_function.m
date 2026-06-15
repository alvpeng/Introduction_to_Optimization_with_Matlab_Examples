% 例程 6.15  调用 MATLAB 的 LQR 函数
%  线性二次型调节（Linear Quadratic Regulation, LQR）示例
%  调用dlqr()函数实现
%  系统矩阵
A = [1, 0.1; 0, 1];
B = [0.005; 0.1];
%  优化权重参数
Q = [1, 0; 0, 1];
V = 2;
%  求解反馈增益
[K, S, E] = dlqr(A, B, Q, V);  %  反馈增益矩阵
%  计算该最优反馈下系统的暂态响应
x = zeros(2, 80);  u = zeros(1, 80);
x0 = [10; 10];  %  初始状态
x(:, 1) = x0;
for nn = 1:79
u(:, nn) = -K*x(:, nn);
x(:, nn + 1) = (A*x(:, nn)) + (B*u(:, nn));
end
%  显示系统暂态响应
figure(1)
subplot(1, 2, 1)
plot(x0(1), 'ko'); hold on;  %  初始点
plot(x(1, :), 'r-');
ylabel('状态x1');  xlabel('迭代步数');
axis([0, 80, -1, 14]);
subplot(1, 2, 2)
plot(x0(2), 'ko'); hold on;  %  初始点
plot(x(2, :), 'r-');
ylabel('状态x2');  xlabel('迭代步数');
axis([0, 80, -10, 12]);
%  输出结果
K
