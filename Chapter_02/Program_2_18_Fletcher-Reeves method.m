% 例程 2.18  弗莱彻-里夫斯方法
v = -2: 0.1: 2;
[vx1, vx2] = meshgrid(v);
y = (2*vx1.^2) + (7*vx2.^2);
%  绘制函数等高线
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  设置初始点
x1i = -1.7;
x2i = 1.2;
yi = 2*(x1i^2) + 7*(x2i^2);
%  计算初始点梯度
g = [(4*x1i), (14*x2i)];
%  判断梯度在x1轴上的分量符号
s = 1;
if g(1) < 0
s = -1;
end;
%  第一段搜索路径
m = g(2)/g(1);  %计算梯度方向的斜率
flag = 1;
yref = yi;
x1 = x1i;
while flag == 1,
x2 = m*(x1 - x1i) + x2i;
y = 2*(x1^2) + 7*(x2^2);
if y > yref
flag = 0;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2;
x1 = x1 - (s*0.01);
end;
end;
%  后续多段搜索路径
x1i = x1o;
x2i = x2o; 
go = g;
po = -g;
for M = 1:4
yi = 2*(x1i^2) + 7*(x2i^2);
g = [(4*x1i), (14*x2i)];  %  计算当前点的梯度
q = (norm(g))^2/(norm(go)^2);
p = -g + (q*po);  %  生成新的共轭梯度搜索方向
%  判断沿x1轴搜索的符号
s = 1;
if  p(1) > 0
s = -1;
end;
m = p(2)/p(1);  %  计算新搜索方向的斜率
flag = 1;
yref = yi;
x1 = x1i;
while flag == 1
x2 = m*(x1 - x1i) + x2i;
y = 2*(x1^2) + 7*(x2^2);
if y > yref
flag =0;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2;
x1 = x1 - (s*0.01);
end;
end;
x1i = x1o;
x2i = x2o;
go = g;
po = p;
end;
