% 例程 2.16  最速下降法示例
[vx1, vx2] = meshgrid(0: 0.1: 10, -4: 0.1: 4);
y = (exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  绘制函数等高线
figure(1)
contour(vx1, vx2, y, 20);
hold  on;
xlabel('x1');  ylabel('x2');
%  最速下降搜索
%  设置迭代初始点
x1i = 9;
x2i = 3.5;
%  多段搜索路径迭代
for M = 1:4
yi = (exp(-(x1i - 3)/2)) + (exp((x1i + 4*x2i)/10)) + (exp((x1i - 4*x2i)/10));
%  计算梯度
aux1 = (-0.5*exp(-(x1i - 3)/2)) ...
+ (0.1*exp((x1i + 4*x2i)/10)) ...
+ (0.1*exp((x1i - 4*x2i)/10));
aux2 = (0.4*exp((x1i + 4*x2i)/10)) ...
- (0.4*exp((x1i - 4*x2i)/10));
g = [aux1, aux2];
m = g(2)/g(1);  %  计算梯度方向的斜率
%  判断梯度在x1轴上的分量符号
s = 1;
if g (1) < 0
s= -1;
end;
flag =1;
yref = yi;
x1 = x1i;
while flag == 1
x2 = m*(x1 - x1i) + x2i;
y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
if y > yref
flag = 0;
else
yref = y;
plot(x1, x2, 'k. ');
x1o = x1;
x2o = x2;
x1 = x1 - (s*0.01);
end;
end;
x1i = x1o;
x2i = x2o;
end;
