% 例程 2.19  弗莱彻-里夫斯法示例
%  函数：y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
[vx1, vx2] = meshgrid(0: 0.1: 10, -4: 0.1: 4);
y = (exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  画图展示
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  设置初始点
x1i = 9;
x2i = 3.5;
yi = (exp(-(x1i - 3)/2)) + (exp((x1i + 4*x2i)/10)) + (exp((x1i - 4*x2i)/10));
%  计算初始点梯度
aux1 = (-0.5*exp(-(x1i - 3)/2)) ...
    + (0.1*exp((x1i + 4*x2i)/10)) + (0.1*exp((x1i - 4*x2i)/10));
aux2 = (0.4*exp((x1i + 4*x2i)/10)) - (0.4*exp((x1i - 4*x2i)/10));
g = [aux1, aux2];
%  判断梯度在x1轴上的分量符号
s = 1;
if g(1) < 0
    s = -1;
end
%  第一段搜索路径
m = g(2)/g(1);  %  计算梯度方向的斜率
flag = 1;
yref = yi;
x1 = x1i;
while flag == 1
    x2 = m*(x1 - x1i) + x2i;
    y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
    if y > yref
        flag = 0;
    else
        yref = y;
        plot(x1, x2, 'k.');
        x1o = x1;
        x2o = x2;
        x1 = x1 - (s*0.01);
    end
end
%  后续多段搜索路径
x1i = x1o;
x2i = x2o;
go = g;
po = -g;
for M = 1:4
    yi = (exp(-(x1i - 3)/2)) + (exp((x1i + 4*x2i)/10)) + (exp((x1i - 4*x2i)/10));
    aux1 = (-0.5*exp(-(x1i - 3)/2)) + ...
        (0.1*exp((x1i + 4*x2i)/10)) + ...
        (0.1*exp((x1i - 4*x2i)/10));
    aux2 = (0.4*exp((x1i + 4*x2i)/10)) - (0.4*exp((x1i - 4*x2i)/10));
    g = [aux1, aux2];  %  当前点的梯度向量
    q = (norm(g))^2/(norm(go)^2);
    p = -g + (q*po);  %  生成新的共轭梯度搜索方向
    %  判断沿x1轴搜索的符号
    s = 1;
    if p(1) >0
        s = -1;
    end
    m = p(2)/p(1);  %  计算新搜索方向的斜率
    flag = 1;
    yref = yi;
    x1 = x1i;
    while flag == 1
        x2 = m*(x1 - x1i) + x2i;
        y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
        if y > yref
            flag = 0;
        else
            yref = y;
            plot(x1, x2, 'k.');
            x1o = x1;
            x2o = x2;
            x1 = x1 - (s*0.01);
        end
    end
    x1i = x1o;
    x2i = x2o;
    go = g;
    po = p;
end
