% 例程 14.5  CHIM 直线生成示例
%  NBI方法的CHIM直线生成示例
%  目标函数定义
J1 = @(x) x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 9*x(1)^2 + 25;
J2 = @(x) x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 3*x(2)^2 + 5;
%  单个目标函数最小化求解
x0 = [1; 1];
lb = [0; 0];
ub = [3; 3];
options = optimoptions('fmincon', 'Display', 'off');
[xmJ1, J1optval] = fmincon(J1, x0, [], [], [], [], lb, ub, [], options);
[xmJ2, J2optval] = fmincon(J2, x0, [], [], [], [], lb, ub, [], options);
%  理想点
Jid = [J1optval; J2optval];
%  支付矩阵 P 构建
%  计算非对角元素（交叉目标函数值）
J2ex = feval(J2, xmJ1);
J1ex = feval(J1, xmJ2);
P = [J1optval - Jid(1), J2ex - Jid(1); J1ex - Jid(2), J2optval - Jid(2)];
%  生成CHIM直线上的点
N = 50;
Jim = zeros(N, 2);
for i = 1: N
    w = [(N-i)/N; i/N];
    Jim(i, :) = P*w;
end
%  求解法向方向
%  切线近似计算
m = (Jim(N, 2) - Jim(1, 2))/(Jim(N, 1) - Jim(1, 1));
nd  = -1/m;  %  垂直方向（法向）斜率
nX = 5;
nY = nd*nX;  %  法向线段长度
%  选取CHIM直线上任意一点作为原点
orX = Jim(30, 1);
orY = Jim(30, 2);
%  结果可视化
figure(1)
plot(Jim(:, 1), Jim(:, 2), 'b-', 'LineWidth', 2);
hold on;
%  绘制法向线段（指向原点方向）
plot([orX, orX - nX], [orY, orY - nY], 'k-');
%  在法向直线上绘制箭头
quiver(orX, orY, -nX, -nY, 'LineWidth', 2);
xlabel('J1s');  ylabel('J2s');
