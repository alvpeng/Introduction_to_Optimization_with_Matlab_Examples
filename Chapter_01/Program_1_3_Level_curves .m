% 例程 1.3  等高线
m = -3: 0.05: 3;
[vx1, vx2] = meshgrid(m);
z = (vx1.^2) + (vx2.^2);
figure(1)
contour(vx1, vx2, z, 'LineWidth', 2);
xlabel('x1');  ylabel('x2');
