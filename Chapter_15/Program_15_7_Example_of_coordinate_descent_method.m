% 例程 15.7  坐标下降法示例
%  坐标下降法示例（基于梯度实现）
[vx1, vx2] = meshgrid(0: 0.2: 10, -4: 0.2: 4);
z = (vx1.^2) + (vx2.^2);
y = (exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  函数可视化
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  迭代搜索过程
N = 30;
%  存储迭代轨迹
x1rec = zeros(1 + 2*N, 1);
x2rec = zeros(1 + 2*N, 1);
%  初始点
x1 = 9;
x2 = 3.5;
x1rec(1, 1) = x1;
x2rec(1, 1) = x2;
alphai = 3;
k = 2;
for j = 1:N
    %  更新x1坐标，计算x1方向的梯度
    g1 = (-0.5*exp(-(x1-3)/2))+(0.1*exp((x1+4*x2)/10))+(0.1*exp((x1-4*x2)/10));
    %  步长更新
    alpha = alphai/sqrt(k - 1);
    x1 = x1 - (alpha*g1);
    x1rec(k, 1) = x1;
    x2rec(k, 1) = x2;
    k = k + 1;
    %  更新x2坐标，计算x2方向的梯度
    g2 = (0.4*exp((x1 + 4*x2)/10)) - (0.4*exp((x1 - 4*x2)/10));
    %  步长更新
    alpha = alphai/sqrt(k - 1);
    x2 = x2 - (alpha*g2);
    x1rec(k, 1) = x1;
    x2rec(k, 1) = x2;
    k = k + 1;
end
%  结果可视化
plot(x1rec(1: k - 1, 1), x2rec(1: k - 1, 1), 'k');
