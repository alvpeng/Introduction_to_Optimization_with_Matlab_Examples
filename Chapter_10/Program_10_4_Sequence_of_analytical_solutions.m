% 例程 10.4  解析解的序列
%  障碍函数示例
%  解析解计算与绘制
v = 0: 0.1: 1;
[vx1, vx2] = meshgrid(v);
y = ((vx1 + 1).^2) + ((vx2 + 1).^2);
%  函数图像绘制
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  向最优解收敛的轨迹
for  mhu = 2: -0.05: 0.05;
    x1 = (-0.5 + (0.5*sqrt((1 + 2*mhu))));
    x2 = x1;
    plot(x1, x2, 'r*', 'MarkerSize', 10);
end;
xlabel('x1');  ylabel('x2');
grid on;
