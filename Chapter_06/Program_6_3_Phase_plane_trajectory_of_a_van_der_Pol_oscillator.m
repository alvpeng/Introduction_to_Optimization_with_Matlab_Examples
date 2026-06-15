% 例程 6.3   范德波尔振荡器的相平面轨迹
%  范德波尔振荡器
%  规范状态变量，存在极限环
%  模型参数
mhu = 0.4;
%  初始点
x10 = 0.1;
x20 = 0.1;
x11 = -2;
x21 = -3;
figure(1)
%  绘制坐标轴
plot([-12, 12], [0, 0], 'k');
hold on;
plot([0, 0], [-12, 12], 'k');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
plot(x11, x21, 'r*', 'MarkerSize', 10);
dt = 0.05;
t = 0;
x1 = x10;
x2 = x20;
%  欧拉积分法
while (t < 30)
plot(x1, x2, 'm.');
dx1 = x2*dt; 
dx2 = (-x1 - (mhu*(x1^2 - 1)*x2))*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t=t + dt;  %  时间增量
end;
t = 0;
x1 = x11;
x2 = x21;
%  欧拉积分法
while (t < 30)
plot(x1, x2, 'b.');
dx1 = x2*dt;
dx2 = (-x1 - (mhu*(x1^2 - 1)*x2))*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
axis([-4, 4, -4, 4]);
xlabel('x1');  ylabel('x2');
