% 例程 2.17  鲍威尔法（Powell’s method）
%  函数： y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
[vx1, vx2] = meshgrid(0: 0.1: 10, -4: 0.1: 4);
y = (exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  绘制函数等高线
figure(1)
contour(vx1, vx2, y, 20);
hold  on;
xlabel('x1');  ylabel('x2');
%  第一轮迭代
%  设置初始点
x1i = 9;
x2i = 3.5;
yi = (exp(-(x1i - 3)/2)) + (exp((x1i + 4*x2i)/10)) + (exp((x1i - 4*x2i)/10));
x1 = x1i;
x2 = x2i;
yref = yi;
for M = 1:3  %  搜索段计数器（共3段）
flag = 1;
if M == 3
m1 = (x2 - x2i)/(x1 - x1i);  %  计算斜率（第三段搜索用）
end
%  三次搜索过程
while flag == 1
y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
if y > yref
flag = 0;
x1 = x1o;
x2 = x2o;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2;
switch  M,
case 1,
x1 = x1 - 0.01;  %  第一段：从右向左移动
case  2
x2 = x2 - 0.01; % 第二段：向下移动
case 3,
% 第三段：从左向右移动
x1 = x1 + 0.01;
x2 = m1*(x1 - x1i) + x2i;
end;
end;
end;
end;
%  第二轮迭代
x1i = x1;
x2i = x2;
for M =1:3  %  搜索段计数器（共3段）
flag = 1;
if M == 3
m2 = (x2 - x2i)/(x1 - x1i);  %  计算斜率（第三段搜索用）
end;
%  三次搜索过程
while flag == 1
y = (exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
if y > yref
flag = 0;
x1 = x1o;
x2 = x2o;
else
yref = y;
plot(x1, x2, 'r.');
x1o = x1;
x2o = x2;
switch  M,
%  第一段：向下移动
case 1,
x2 = x2 - 0.01; 
x1p = x1;
x2p = x2;
case 2,
%  第二段：从左向右移动
x1 = x1 + 0.001;
x2 = m1*(x1 - x1p) + x2p;
case 3
%  第三段：从左向右移动
x1 = x1 + 0.01;
x2 = m2*(x1 - x1i) + x2i;
end;
end;
end;
end;
