% 例程 3.11  具有无穷多最优解的案例
%  绘制二维可行解集与目标函数
%  无穷多解情形
%  直线方程：ax + by = c
a1 = -3;
b1 = 2;
c1 = 3;
a2 = -1;
b2 = 2;
c2 = 8;
%  约束条件的角点坐标
X1 = c1/a1;
Y1 = c1/b1;
X2 = c2/a2;
Y2 = c2/b2; 
%  计算两条约束直线的交点
aux1 = (Y2 - Y1);
aux2 = (Y2*X1) - (Y1*X2);
xi = (X1*X2*aux1)/aux2;
yi = Y1 - ((Y1*xi)/X1);
%  最右侧点（在第二条约束直线上）
xr = 4*xi;
yr = (c2 - (a2*xr))/b2;
figure(1)
%  绘制可行解集（无界区域）
patch([0, 0, xi, xr, xr], [0, Y1, yi, yr, 0], 'g', 'EdgeColor', 'g');
hold on;
%  绘制坐标轴
plot([-2, 12], [0, 0], '');
plot([0, 0], [-2, 12], 'b');
%  绘制约束直线
plot([0, xi], [Y1, yi], 'k');
plot([xi, xr], [yi, yr], 'k');
%  绘制目标函数值对应的直线段
%  目标函数：-3x + 2y = z;
a = -3;
b = 2;
%  目标函数直线段的端点坐标
z = -10;
X1 = z/a;
xr1 = X1 + 7;
yr1 = (z -(a* xr1))/ b;
z = -6;
X2 = z/a;
xr2 = X2 + 7;
yr2 = (z - (a*xr2))/b;
z = -2;
X3 = z/a;
xr3 = X3 + 7;
yr3 = (z - (a*xr3))/b;
z = 2.8;
X4 = z/a;
xr4 = X4 + 7;
yr4 = (z - (a*xr4))/b;
plot([X1, xr1], [0, yr1], 'r');
plot([X2, xr2], [0, yr2], 'r');
plot([X3, xr3], [0, yr3], 'r');
plot([X4, xr4], [0, yr4], 'm');
