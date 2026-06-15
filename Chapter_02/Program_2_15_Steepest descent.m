% 例程 2.15  最速下降法
x1 = -2: 0.05: 2;
x2 = -2: 0.05: 2;
N = length(x1);
y = zeros(N, N);  %  预分配内存
%  计算网格上所有点的函数值
for i = 1:N
for j = 1:N
y(j, i) = 2*(x1(i)^2) + 7*(x2(j)^2);
end;
end;
%  绘制函数等高线
figure(1)
contour(x1, x2, y, 26);
hold  on;
xlabel('x1');  ylabel('x2');
%  最速下降搜索
%  设置迭代初始点
x1i = -1.7;
x2i = 1.2;
yi = 2*(x1i^2) + 7*(x2i^2);
g = [(4*x1i), (14*x2i)];  %  计算初始点的梯度 [∂y/∂x1, ∂y/∂x2]
%  判断梯度在x1轴上的分量符号
s =1;
if g(1) < 0
s = -1;
end;
%  第一段搜索路径
m = g(2)/g(1);  %计算梯度方向的斜率（搜索路径的斜率）
flag = 1;
yref = yi;
x1 = x1i ;
while flag == 1
x2 = m *(x1 - x1i) + x2i ;
y = 2*(x1^2) + 7*(x2^2);
if y > yref 
flag = 0;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2 ;
x1 = x1 - (s*0.01 );
end;
end;
%  后续多段搜索路径
for M = 1:4
x1i = x1o;
x2i = x2o;
x1 = x1i;
g = [(4*x1i), (14*x2i)];  %  计算新初始点的梯度
m = g(2)/g(1);  %  计算新梯度方向的斜率
flag = 1;
while flag == 1
x2 = m*(x1 - x1i) + x2i;
y = 2*(x1^2) + 7*(x2^2);
if y>yref
flag = 0;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2;
x1 = x1 - (s*0.01);
end;
end;
end;
