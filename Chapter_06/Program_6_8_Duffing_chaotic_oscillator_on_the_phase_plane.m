% 例程 6.8  相平面上的杜芬混沌振荡器
%  杜芬方程
%  初始点
x10 = 1;
x20 = 1;
figure(1)
%  绘制坐标轴
plot([-4, 4], [0, 0], 'k');
hold on;
plot([0, 0], [-10, 10], 'k');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
dt = 0.01;
t = 0;
x1 = x10;
x2 = x20;
w = 1;
a = 0.05;
b = 1;
c = 7.5;
%  欧拉积分法
while (t < 80)
    plot(x1, x2, 'b.');
    dx1 = x2*dt;
    dx2 = ((c*cos(w*t)) - ((a*x2) + (b*(x1^3))))*dt;
    x1 = x1 + dx1;
    x2 = x2 + dx2;
    t = t + dt;  %  时间增量
end
axis([-4, 4, -10, 10]);
xlabel('x1');  ylabel('x2');
