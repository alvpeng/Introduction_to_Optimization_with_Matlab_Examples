% 例程 10.3  基于障碍函数的牛顿迭代示例
%  障碍函数示例
%  每一步的牛顿迭代计算
v = 0: 0.1: 1;
[vx1, vx2] =  meshgrid(v);
y = ((vx1 + 1).^2) + ((vx2 + 1).^2);
%  函数图像绘制
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  向最优解收敛的迭代轨迹
%  初始迭代点
x1o = 0.6;
x2o = 0.8;
plot(x1o, x2o, 'm*', 'MarkerSize', 12);
for mhu =1.3: -0.1: 0.1
%  计算梯度
gr1 = (2*(x1o + 1)) - (mhu/x1o);
gr2 = (2*(x2o 1)) - (mhu/x2o);
g = [gr1; gr2];
%  计算海森矩阵
h11 = 2 + (mhu/(x1o^2));
h22 = 2 + (mhu/(x2o^2));
H = [h11, 0; 0, h22];
delta = H\-g;  %  计算牛顿步长
x1n = x1o + delta(1);
x2n = x2o + delta(2);
plot([x1o, x1n], [x2o, x2n], 'k', 'LineWidth', 2);
plot(x1n, x2n, 'r*', 'MarkerSize', 8)
x1o = x1n;
x2o = x2n;
end;
xlabel('x1');  ylabel('x2');
