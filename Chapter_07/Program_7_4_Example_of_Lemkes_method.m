% 例程 7.4  莱姆克方法示例
[vx1, vx2] = meshgrid(-2: 0.1: 5, -4: 0.1: 4);
y = (vx1.^2) + 1.5*(vx1.*vx2) + 4*(vx2.^2) - 3*vx1 + vx2;
figure(1)
contour(vx1, vx2, y, 25, 'LineWidth', 1.5); hold on
plot([5, -2], [-1, 11/3], 'k--', 'LineWidth', 2);  %  绘制约束1
plot([-2, 1], [-1, -4], 'b--', 'LineWidth', 2);  %  绘制约束2
plot(3.5469, -0.0312, 'mo', 'LineWidth', 5);  %  绘制最优解点
