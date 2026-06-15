% 例程 2.13  割线法的应用
%  函数：y = -2x sin(0.8x) + exp(-2x);
%  第一步：绘制函数曲线
x = -1.5: 0.1: 6;
y = -2*x.*sin(0.8*x) + exp(-2*x);
figure(1)
plot(x, y, 'k');
title(' 割线法');
hold  on;
%  设置迭代初始区间 [a, b]
a = -1;
b = 5.3; 
%  绘制初始区间的两个端点
ya = -2*a*sin(0.8*a) + exp(-2*a);
yb = -2*b*sin(0.8*b) + exp(-2*b);
plot(a, ya, 'bd');
plot(b, yb, 'rd');
%  开始迭代计算
for  n =1:5  %  限定迭代次数为5次
%  计算一阶导数值（dy = y'）
k = 2*0.8;
dya = -2*sin(0.8*a) - k*a*cos(0.8*a) - 2*exp(-2*a);
dyb = -2*sin(0.8*b) - k*b*cos(0.8*b) - 2*exp(-2*b );
%  计算割线法迭代公式中的商项
q = ((b - a)*dya )/(dyb - dya);
%  计算新的迭代点c
c = a - q;
%  计算c点的一阶导数值
dyc = -2* sin(0.8*c) - k*c*cos(0.8*c) - 2*exp(-2*c);
%  根据c点导数的符号替换a或b
if dyc > 0
b = c;
yb = -2*b*sin(0.8*b) + exp(-2*b);
plot([b, b], [0, yb], 'r');
else
a = c;
ya = -2*a*sin(0.8*a) + exp(-2*a);
plot([a, a], [0, ya], 'b');
end;
end;
b
yb
