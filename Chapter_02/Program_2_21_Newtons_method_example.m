% 例程 2.21  牛顿法示例
%  函数定义：y = (exp(-(x1 - 3)/2))+(exp((x1 + 4*x2)/10))+(exp((x1 - 4*x2)/10));
[vx1, vx2 ] = meshgrid(0: 0.1: 10, -4: 0.1: 4);
y = (exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  函数图像绘制
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  初始点
x1i = 9;
x2i = 3.5;
%  迭代步数
for M = 1:4
    a = (exp(-(x1i - 3)/2));
    b = (exp((x1i + 4*x2i)/10));
    c = (exp((x1i - 4*x2i)/10));
    yi = a + b + c;
    %  计算梯度
    aux1 = (-0.5*a) + (0.1*b) + (0.1*c);
    aux2 = (0.4*b) - (0.4*c);
    g = [aux1, aux2];
    %  计算海森矩阵
    qH11 = (0.25*a) + (0.01*b) + (0.01*c);
    qH12 = (0.04*b) - (0.04*c);
    qH21 = (0.04*b) - (0.04*c);
    qH22 = (0.16*b ) + (0.16*c);
    H = [qH11, qH12; qH21, qH22];
    delta = H\-g';  %  求解迭代步长
    x1f = x1i + delta(1);
    x2f = x2i + delta(2);
    plot([x1i, x1f], [x2i, x2f], 'k');
    x1i = x1f;
    x2i = x2f;
end
