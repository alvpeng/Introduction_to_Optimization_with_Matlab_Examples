% 例程 6.12  继电控制（Bang-bang）策略
%  卫星姿态控制仿真
%  初始点
x10 = 1;
x20 = -3;
figure(1)
%  绘制坐标轴
plot([-4, 4], [0, 0], 'k');
hold on;
plot([0, 0], [-4, 4], 'k');
dt = 0.01;
U = 1;
aux = 0;
t = 0;
x1 = x10;
x2 = x20;
%  欧拉积分法求解
while  (t < 6.8)
    plot(x1, x2, 'b.');
    aux = (U*x1) + (0.5*x2*abs(x2));
    if (aux > 0)
        p = -U;
    else
        p = U;
    end
    dx1 = x2*dt;
    dx2 = p*dt;
    x1 = x1 + dx1;
    x2 = x2 + dx2;
    t = t + dt;  %  时间增量
end
%  绘制切换线
%  上半部分
t = 0;
x1 = -3.5;
x2 = sqrt(abs(2*U*x1));
while (x2 >0)
    plot(x1, x2, 'm');
    dx1 = x2*dt;
    dx2 = -U*dt;
    x1 = x1 + dx1;
    x2 = x2 + dx2;
    t = t + dt; %时间增量
end
%  下半部分
t = 0;
x1 = 3.5;
x2 = -sqrt(abs(2*U*x1));
while (x2 < 0)
    plot(x1, x2, 'm');
    dx1 = x2*dt;
    dx2 = U*dt;
    x1 = x1 + dx1;
    x2 = x2 + dx2;
    t = t + dt;  %  时间增量
end
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
axis([-4, 4, -4, 4]);
xlabel('x1');  ylabel('x2');
