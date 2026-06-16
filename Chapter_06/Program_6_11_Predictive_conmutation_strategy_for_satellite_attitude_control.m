% 例程 6.11  卫星姿态控制的预测性切换策略
%  卫星姿态控制仿真
%  预测性切换策略
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
KPR = 2;
aux = 0;
t = 0;
x1 = x10;
x2 = x20;
%  欧拉积分法求解
while (t < 15)
    plot(x1, x2, 'b.');
    aux = x2 + (KPR*x1);
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
plot([-2, 2], [2*KPR, -2*KPR], 'm');
%  绘制初始点
plot(x10, x20, 'r*', 'MarkerSize', 10);
axis([-4, 4, -4, 4]);
xlabel('x1');  ylabel('x2');
