% 例程 1.6  三维场景中的鞍点
[x1, x2] = meshgrid(-1: 0.05: 1);
z = x1.^2 - x2.^2;
figure(1)
mesh(x1 ,x2 ,z);
hold  on;
plot(0, 0, 'ro', 'LineWidth', 4);
colormap('cool');
view(20, 20);
