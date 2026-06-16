% 例程 1.15  三维函数的等高线
[x1, x2] = meshgrid( -3: 0.1: 3);
z = - x1.*x2.*(exp(-(x1.^2 + x2.^2))/2);
figure(1)
contourf(x1, x2, z, 16);
colormap('hsv');
