% 例程 7.1  沃尔夫方法示例
%  沃尔夫方法示例的可视化
[vx1, vx2] = meshgrid(0: 0.1: 5, 0: 0.1: 5);
y = (-8*vx1) - (16*vx2) + (vx1.^2) + 4*(vx2.^2);
figure(1)
colormap('hsv');
patch([0, 0, 3, 3, 0], [0, 5, 2, 0, 0], [0.5, 0.7, 0.7]);
hold  on;
contour(vx1, vx2, y, 25, 'LineWidth', 1.5);
plot([0, 5], [5, 0], 'k--', 'LineWidth', 2);  %  约束条件 1
plot([3, 3], [0, 5], 'k--', 'LineWidth', 2);  %  约束条件 2
plot(3, 2, 'm*', 'LineWidth', 5);  %  最优解
