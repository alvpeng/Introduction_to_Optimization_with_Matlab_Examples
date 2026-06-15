% 例程 6.10  卫星姿态控制的朴素切换策略
%  朴素切换策略
%  初始点
x10 = -1.5;
x20 = -1.5 ;
x11 = 1;
x21 = 1;
figure(1)
%  绘制坐标轴
plot([-4, 4], [0, 0], 'k');
hold on;
plot([0, 0], [-4, 4], 'k');
dt = 0.002;  %  步长取小以提高精度
U = 1;
t = 0;
x1 = x10;
x2 = x20;
%  欧拉积分法求解
while (t < 10)
plot(x1, x2, 'b.');
if (x1 > 0)
p = -U;
else
p = U;
end;
dx1 = x2*dt;
dx2 = p*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
t = 0;
x1 = x11;
x2 = x21;
%  欧拉积分法求解
while (t <10)
plot(x1, x2, 'g.');
if (x1 >0)
p = -U;
else
p = U;
end;
dx1 = x2*dt;
dx2 = p*dt;
x1 = x1 + dx1;
x2 = x2 + dx2;
t = t + dt;  %  时间增量
end;
%  绘制切换线
plot([0, 0], [-4, 4], 'm');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
plot(x11, x21, 'r*', 'MarkerSize', 10);
axis([-4, 4, -4, 4]);
xlabel('x1');  ylabel('x2');
