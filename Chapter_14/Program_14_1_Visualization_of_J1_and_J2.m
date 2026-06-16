% 例程 14.1  J1 和 J2 的可视化
b = 0: 0.05: 3;
[vx1, vx2] = meshgrid(b);
J1 = vx1.^4 + vx2.^4 + vx1.*vx2 - (vx1.^2).*(vx2.^2) - 9*vx1.^2 + 25;
J2 = vx1.^4 + vx2.^4 + vx1.*vx2 - (vx1.^2).*(vx2.^2) - 3*vx2.^2 + 5;
figure(1)
subplot(1, 2, 1)
contour(vx1, vx2, J1, 30, 'LineWidth', 1.5);
xlabel('x1');  ylabel('x2');
subplot(1, 2, 2)
contour(vx1, vx2, J2, 30, 'LineWidth', 1.5);
xlabel('x1');  ylabel('x2');
