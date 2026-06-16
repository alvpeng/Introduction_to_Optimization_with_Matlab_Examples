% 例程 4.2  两条曲线间的距离
%  二维平面中两条曲线间的距离
%  绘制曲线
x = 0: 0.05: 1.5;
y = 1 + x.^2;  %  抛物线
plot(x, y, 'r');
hold on;
x = 1: 0.05: 3;
y = sqrt(1 - (x - 2).^2);  %  圆
plot(x, y, 'm');
%  搜索近似解
sqer = 10000;  %  初始化误差值
for i = 1: 100
    for j = 1: 100
        x1 = 0.5 + (i*0.01);
        x2 = 1 + (j*0.01);
        aux1 = 1 + (x1^2);
        aux2 = x1 - x2;
        auxq = sqrt(1 - (x2 - 2)^2);
        e1 = (2*x1*(aux1 - auxq)) + aux2;
        e2 = (aux2*auxq) - (aux2*(aux1 - auxq));
        M = (e1^2) + (e2^2);
        if (M < sqer)
            sqer = M;
            sx1 = x1;
            sx2 = x2;
        end
    end
end
sy1 = 1 + (sx1^2);
sy2 = sqrt(1 - (sx2 - 2).^2);
plot([sx1, sx2], [sy1, sy2], 'b');  %  绘制最短距离线段
xlabel('x 轴');  ylabel('y 轴');
distance = sqrt((sx1 - sx2)^2 + (sy1 - sy2)^2);
%  输出结果
distance
disp('抛物线上的点坐标：')
sx1
sy1
disp('圆上的点坐标：')
sx2
sy2
