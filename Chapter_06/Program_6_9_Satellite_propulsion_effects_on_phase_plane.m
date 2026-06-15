% 例程 6.9  卫星推进器作用下的相平面特性
%  卫星推进器作用效果仿真
%  初始点
x10 = -1;
x20 = -1;
x11 = 1;
x21 = 1;
figure(1)
%  绘制坐标轴
plot([-4 4], [0 0], 'k');
hold on;
plot([0 0], [-4 4], 'k');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
plot(x11, x21, 'r*', 'MarkerSize', 10);
dt = 0.05;
t = 0;
x1 = x10;
x2= x20;
U = 1;
%  欧拉积分法求解
while (t < 4)
plot(x1, x2, 'b ');
dx1 = x2*dt;
dx2 = U*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
t = 0;
x1 = x11;
x2 = x21;
U = -1;
%  欧拉积分法求解
while (t <4)
plot(x1, x2, 'g.');
dx1 = x2*dt; 
dx2 = U*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
axis([-4, 4, -4, 4]);
xlabel('x1');  ylabel('x2');
