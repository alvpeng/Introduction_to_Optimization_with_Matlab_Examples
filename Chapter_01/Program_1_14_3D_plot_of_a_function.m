% 例程 1.14  函数的三维图像
[x1, x2] = meshgrid(-3: 0.1: 3);
z = -x1.*x2.*(exp(-(x1.^2 + x2.^2))/2);
figure(1)
surf(x1, x2, z);
colormap('hsv');
view(25, 35);
