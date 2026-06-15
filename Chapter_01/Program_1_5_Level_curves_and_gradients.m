% 例程 1.5  等高线与梯度
m = -3: 0.3: 3;
[vx1, vx2] = meshgrid(m);
z = (vx1.^2) + (vx2.^2);
[g1, g2] = gradient(z, 0.3, 0.3);
figure(1)
contour(vx1, vx2, z, 'LineWidth', 2);
hold on;
quiver(vx1, vx2, g1, g2);
xlabel('x1');  ylabel('x2');
