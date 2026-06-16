% 例程 2.14  割线法的分步演示
%  割线法的应用 - 迭代过程的分步可视化演示
%  函数：y = -2x  sin(0.8x) + exp(-2x);
%  第一步：绘制函数曲线及其一阶导数曲线
x = -1.2: 0.1 : 6;
y = -2*x.*sin(0.8*x) + exp(-2*x);
k = 2*0.8;
dy = -2*sin(0.8*x) - k*x.*cos(0.8*x) - 2*exp(-2*x);
figure(1)
subplot(2, 1, 1);
plot(x, y, 'k');
title('原函数');
hold  on;
subplot(2, 1, 2)
plot(x, dy, 'r');
title('一阶导数曲线；dy = 0 对应黑色竖线');
hold  on;
%  标注导数为零的位置（函数极值点）
plot([2.5388, 2.5388], [-50, 50], 'k');
%  设置迭代初始区间 [a, b]
a= -1;  b = 5.3;
%  注意：a点和b点处的一阶导数符号必须相反
%  绘制初始区间的两个端点
ya = -2*a*sin(0.8*a) + exp(-2*a);
yb = -2*b*sin(0.8*b) + exp(-2*b);
subplot(2, 1, 1)
plot(a, ya, 'bd');
plot(b, yb, 'rd');
%  第一次迭代
%  计算a点和b点的一阶导数值
dya = -2*sin(0.8*a) - k*a*cos(0.8*a) - 2*exp(-2*a);
dyb = -2*sin(0.8*b) - k*b*cos(0.8*b) - 2*exp(-2*b);
%  计算割线法迭代公式中的商项
q = ((b - a)*dya)/(dyb - dya);
%  计算新的迭代点c
c = a - q  %  输出供用户查看
%  可视化第一次迭代的导数与新迭代点
figure(2)
plot(x, dy, 'r ');
hold on;
plot([x(1), x(end)], [0, 0], 'k');  %  绘制横轴
plot([a, b], [dya, dyb], 'b');
plot([c, c], [-10, 10], 'mx-');  %  绘制新迭代点c
title('一阶导数曲线与第一次迭代');
%  注释1：点c是a-b割线（蓝色）与横轴（黑色直线）的交点
%  注释2：函数极小值点对应导数曲线（红色）与横轴的交点
%  第二次迭代，更新b点为新的迭代点c：
b = c;
%  重新计算b点的函数值和一阶导数值
yb = -2*b*sin(0.8*b) + exp(-2*b);
dyb = -2*sin(0.8*b) - k*b*cos(0.8*b) - 2*exp(-2*b);
%  计算割线法迭代公式中的商项
q = ((b - a)*dya)/(dyb - dya);
%  计算新的迭代点c
c = a - q  %  输出供用户查看
%  可视化第二次迭代的导数与新迭代点
figure(3)
plot(x, dy, 'r');
hold on;
plot([x(1), x(end)], [0, 0], 'k');  %  绘制横轴
plot([a, b], [dya, dyb], 'b');
plot([c, c], [-10, 10], 'mx-');  %  绘制新迭代点c
title('一阶导数曲线与第二次迭代');
%  计算c点的一阶导数值
dyc = -2*sin(0.8*c) - k*c*cos(0.8*c) - 2*exp(-2*c)
%  该导数值为负，因此将a点更新为c
a = c;
%  第三次迭代
ya = -2*a*sin(0.8*a) + exp(-2*a);
dya = -2*sin(0.8*a) - k*a*cos(0.8*a) - 2*exp(-2*a);
%  计算割线法迭代公式中的商项
q = ((b-a)*dya)/(dyb - dya);
%  计算新的迭代点c
c = a - q  %  输出供用户查看
%  可视化第三次迭代的导数与新迭代点
figure(4)
plot(x, dy, 'r');
hold  on;
plot([x(1), x(end)], [0, 0], 'k');  %  绘制横轴
plot([a, b], [dya, dyb], 'b');
plot([c, c], [-10, 10], 'mx-');  %  绘制新迭代点c
title('一阶导数曲线与第三次迭代');
%  计算c点的一阶导数值
dyc = -2*sin(0.8*c) - k*c*cos(0.8*c) - 2*exp(-2*c)
%  该导数值为负，因此将a点更新为c
a = c;
%  以此类推（后续迭代逻辑相同）
