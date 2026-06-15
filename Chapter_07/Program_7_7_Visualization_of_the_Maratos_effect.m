% 例程 7.7  马拉托斯效应的可视化
figure(1)
%  绘制约束曲线（单位圆）
x1o = 1;
x2o = 0;
for  theta = 0: 0.05: 2*pi
x1 = cos(theta);
x2 = sin(theta);
plot([x1o, x1], [x2o, x2], 'b', 'LineWidth', 3);
hold on;
x1o = x1;
x2o = x2;
end;
%  绘制坐标轴
plot([-1.5 1.5], [0, 0], 'k', 'LineWidth', 2);
plot([0, 0], [-1.5, 1.5], 'k', 'LineWidth', 2);
%  绘制目标函数等值线
[vx1, vx2] = meshgrid(-1.5: 0.05: 1.5, -1.5: 0.05: 1.5);
y = 2*(vx1.^2 + vx2.^2 -1) - vx1;
contour(vx1, vx2, y, 30, 'LineWidth', 2);
grid on;
%  绘制SQP搜索步长
plot([0, 1], [1, 1], 'r->', 'LineWidth', 3);
