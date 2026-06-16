% 例程 2.20  牛顿法示例
v = -2: 0.1: 2;
[vx1, vx2] = meshgrid(v);
y = (2*vx1.^2) + (7*vx2.^2);
%  函数图像绘制
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  初始点
x1i = -1.7;
x2i = 1.2;
yi = 2*(x1i^2) + 7*(x2i^2);
%  梯度
g = [(4*x1i), (14*x2i)];
%  海森矩阵
H = [4, 0; 0, 14];
delta = H\-g';  %  迭代步长
x1f = x1i + delta(1);
x2f = x2i + delta(2);
plot([x1i, x1f], [x2i, x2f], 'k');
