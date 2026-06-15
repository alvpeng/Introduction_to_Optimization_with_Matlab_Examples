% 例程 7.2  有效集法示例
%  有效集法示例的可视化
[vx1, vx2 ] = meshgrid(0: 0.1: 5, 0: 0.1: 5);
y = ((vx1 - 1).^2) + ((vx2 - 2.5).^2);
figure(1)
colormap('hsv');
patch([0, 2, 4, 2, 0], [1, 2, 1, 0, 0], [0.5, 0.7, 0.7]);
hold on;
contour(vx1, vx2, y, 30, 'LineWidth', 1.5);
plot([0, 5], [1, 7/2], 'k--', 'LineWidth', 2);  %  约束条件1
plot([0, 5], [3, 1/2], 'k--', 'LineWidth', 2);  %  约束条件2
plot([2, 5], [0, 3/2], 'k--', 'LineWidth', 2);  %  约束条件3
plot(1.4, 1.7, 'm*', 'LineWidth', 5);  %  最优解
