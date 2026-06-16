% 例程 1.7  等高线与鞍点
[x1, x2] = meshgrid(-1: 0.05: 1);
z = x1.^2 - x2.^2;
figure(1)
contour(x1, x2, z, 21);
hold on;
plot(0, 0, 'ro', 'LineWidth', 4);
colormap('vga');
xlabel('x1');  ylabel('x2');
