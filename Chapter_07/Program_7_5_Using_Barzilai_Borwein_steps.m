% 例程 7.5  使用巴尔齐莱‑博温步长
%  最速下降法示例
%  采用巴尔齐莱-博温（Barzilai-Borwein）步长
x1 = -2: 0.05: 2;
x2 = -2: 0.05: 2;
N = length(x1);
y = zeros(N, N);  %  预分配内存，存储函数值矩阵
%  计算所有网格点的函数值
for i = 1: N
    for j = 1: N
        y(j, i) = 2*(x1(i)^2) + 7*(x2(j)^2);
    end
end
%  函数可视化
figure(1)
contour(x1, x2, y, 26);  hold on;
xlabel('x1');  ylabel('x2');
%  初始化计算所需向量
xi = zeros(2, 1);
xn = zeros(2, 1);
%  搜索过程
%  初始点
xi = [-1.7; 1.2];
yi = 2*(xi(1)^2) + 7*(xi(2)^2);
g = [(4*xi(1)); (14*xi(2))];  %  计算初始点的梯度
%  确定梯度在x1方向的符号
sg = 1;
if g(1) < 0
    sg = -1;
end
%  第一段搜索（沿初始梯度方向的一维搜索）
m = g(2)/g(1);  %  梯度方向的斜率
flag = 1;
yref = yi;
xn(1) = xi(1);
while flag == 1
    xn(2) = m*(xn(1) - xi(1)) + xi(2);
    y = 2*(xn(1)^2) + 7*(xn(2)^2);
    if y > yref
        flag = 0;
    else
        yref = y;
        plot(xn(1), xn(2), 'k.');
        xn(1) = xn(1) - (sg*0.02);
    end
end
%  开始使用巴尔齐莱‑博温（BB）步长
%  后续多段搜索
for M = 1:4
    so = xn - xi;
    xi = xn;
    gro = g;
    g = [(4*xi(1)); (14*xi(2))];  %  计算新的梯度值
    yo = g - gro;
    %  计算B-B  长步长
    Lalpha = (so'*so)/(so'*yo);
    xn = xi - (Lalpha*g);
    plot([xi(1), xn(1)], [xi(2), xn(2)], 'k-');
end
