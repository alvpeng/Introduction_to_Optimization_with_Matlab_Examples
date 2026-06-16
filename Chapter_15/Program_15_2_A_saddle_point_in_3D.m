% 例程 15.2  三维空间中的鞍点
[x1, x2] = meshgrid(-1: 0.04: 1);
z = (x1.^2) - (x2.^2);
mesh(x1, x2, z); 
hold  on;
plot(0, 0, 'r*', 'MarkerSize', 10, 'LineWidth', 4);
colormap('winter');
view(20, 40);
