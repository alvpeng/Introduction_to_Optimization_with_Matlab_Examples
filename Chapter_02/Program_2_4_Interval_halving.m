% 例程 2.4  区间对分法
%  函数： y = (1.6*sin(x)) - x
%  由区间搜索法确定的初始区间
L = 0.16;
xh = 1.12;
xl = xh - (2*L);
%  在定位区间内绘制函数曲线（用于可视化）
x = xl: 0.01: xh;
y = (1.6*sin(x)) - x;
for n = 1:4  %  限定搜索迭代次数为4步
b = (xh - L);  %  计算当前区间中点
yb = (1.6*sin(b)) - b;
a = b - (L/2);  %  计算左内点（中点左侧1/2步长处）
ya = (1.6*sin(a)) - a;
c = b + (L/2);  %  计算右内点（中点右侧1/2步长处）
yc = (1.6*sin(c)) - c;
if ya > yb ,
xh = b;  %  若左内点函数值更大，舍弃第3、4子区间，更新上界
elseif yc > yb
xl = b;  %  若右内点函数值更大，舍弃第1、2子区间，更新下界
else
xl = a; xh = c;  %  否则保留第2、3子区间，同时更新上下界
end;
L = L/2;
yl = (1.6 * sin(xl)) - xl;
yh = (1.6 * sin(xh)) - xh;
%  结果可视化展示
figure(1)
subplot(2, 2, n)
plot(x, y, 'k');
axis([0.79, 1.12, 0, 0.4]);
hold on;
plot([xl, xl], [0, yl], 'b--');
plot([xh, xh], [0, yh], 'r--');
end;
