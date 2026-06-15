% 例程 6.7  软弹簧的相平面轨迹
%  规范状态变量
%  模型参数
w0_2 = 1;
a_2 = 0.2;
%  初始点
x10 = 1;
x20 = 0.1;
x11 = -2.9;
x21 = 1.8;
x12 = -2.8;
x22 = 0.8987;  %  临界初始条件（分界线）
figure(1)
%  绘制坐标轴
plot([-4, 4], [0, 0], 'k');
hold on;
plot([-4, 4], [4, 4], 'k');
plot([0, 0], [-2, 7], 'k');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
plot(x11, x21, 'r*', 'MarkerSize', 10);
plot(x12, x22, 'r*', 'MarkerSize', 10);
set (gca, 'ytick', []);  %  隐藏y轴刻度
%  绘制势能曲线
for x1 = -3: 0.1: 3
y = w0_2*((x1^2/2) - (a_2*(x1^4)/4));
plot(x1, y+4, 'm.');
end;
dt = 0.002;
%  内侧振荡轨迹
t = 0;
x1 = x10;
x2 = x20;
%  欧拉积分法
while (t < 7)
plot(x1, x2, 'b.');
dx1 = x2*dt;
dx2 = (-w0_2*x1*(1 - a_2*(x1^2)))*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
%  外侧非周期运动轨迹
t = 0;
x1 = x11;
x2 = x21;
%  欧拉积分法
while  (t < 3.7)
plot(x1, x2, 'b.');
dx1 = x2*dt;
dx2 = (-w0_2*x1*(1 - a_2*(x1^2)))*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
%  分界线轨迹
t = 0;
x1 = x12;
x2 = x22;
%  欧拉积分法
while (t < 13)
plot(x1, x2, 'b.');
dx1 = x2*dt; 
dx2 = (-w0_2*x1*(1 - a_2*(x1^2)))*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
axis([-4, 4, -2, 7]);
xlabel('x1');
str = ['x2', ' ', 'P'];
ylabel(str);
