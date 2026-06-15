% 例程 6.1  在相平面中展示二阶线性系统的轨迹
%  二阶线性系统
%  规范状态变量，原点为焦点
%  阻尼系数
delta = 0.2;
%  初始点
x10 = 10;
x20 = 5;
figure(1)
%  绘制坐标轴
plot([-12, 12], [0, 0], 'k');
hold on;
plot([0, 0], [-12, 12], 'k');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
t = 0;
dt = 0.05;
x1 = x10;
x2 = x20;
%  欧拉积分法
while (t < 30)
plot(x1, x2, 'b.');
dx1 = x2*dt;
dx2 = (-x1 - (2*delta*x2))*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
axis([-12, 12, -12, 12]);
xlabel('x1');  ylabel('x2');
