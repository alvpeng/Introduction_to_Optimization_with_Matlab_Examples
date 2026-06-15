% 例程 2.23  布罗伊登方法
%  函数定义：y =(exp(-(x1 - 3)/2)) + (exp((x1 + 4*x2)/10)) + (exp((x1 - 4*x2)/10));
[vx1, vx2] = meshgrid(0: 0.1: 10, -4: 0.1: 4);
y = (exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  函数图像绘制 
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  初始点
x1i = 9;
x2i = 3.5;
a = (exp(-(x1i - 3)/2));
b = (exp((x1i + 4*x2i)/10));
c = (exp((x1i- 4*x2i)/10));
yi = a + b +c;
%  计算梯度
aux1 = (-0.5*a) + (0.1*b) + (0.1*c);
aux2 = (0.4*b) - (0 .4*c);
g = [aux1; aux2];
%  初始化矩阵 A
A = eye (2);
%  第一步迭代
delta = -A*g;
%  确定delta在x1方向的符号
s = 1;
if delta(1) < 0
s = -1;
end;
%  第一次直线搜索
m = delta(2)/delta(1);
flag = 1;
yref = yi;
x1 = x1i;
while flag == 1,
x2 = m*(x1 - x1i) + x2i;
a = (exp(-(x1 - 3)/2));
b = (exp((x1 + 4*x2)/10));
c = (exp((x1 - 4*x2)/10));
y = a + b + c;
if y>yref
flag = 0;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2;
x1 = x1 + (s*0.01);
end;
end;
x1 = x1o;
x2 = x2o;
%  后续迭代步骤
for M =1:4 
a = (exp(-(x1 - 3)/2));
b = (exp((x1 + 4*x2)/10));
c = (exp((x1 - 4* x2)/10));
aux1 = ( -0.5*a) + (0.1*b ) + (0.1*c);
aux2 = (0.4*b) - (0.4*c);
go = g;  %  保存梯度的旧值
g = [aux1; aux2];  %  计算梯度的新值
dg = g - go; 
dx = [x1 - x1i; x2 - x2i];
Ao = A;  %  保存矩阵A的旧值
%  QA (代码片段开始)
%  更新矩阵A的新值
A = Ao + ((dx - A*dg)*(dx - A*dg)')/((dx - A*dg)'*dg);
% QB (代码片段结束)
x1i = x1;
x2i = x2;  %  更新迭代起始点
%  直线搜索
delta = -A*g;
%  确定delta在x1方向的符号
s = 1;
if delta(1) < 0
s = -1;
end;
m = delta(2)/delta(1);  %  搜索方向斜率
flag = 1;
x1 = x1i;
while flag == 1,
x2 = m*(x1 - x1i) + x2i;
a = (exp(-(x1 - 3)/2));
b = (exp((x1 + 4*x2)/10));
c = (exp((x1 - 4*x2)/10));
y = a + b + c;
if y > yref
flag = 0;
else
yref = y;
plot(x1, x2, 'k.');
x1o = x1;
x2o = x2;
x1 = x1 + (s*0.01);
end;
end;
x1 = x1o;
x2 = x2o;
end;
