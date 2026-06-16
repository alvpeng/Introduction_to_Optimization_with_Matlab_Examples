% 例程 2.8  黄金分割法
%  函数：y = (1.6*sin(x)) - x
%  由区间搜索法确定的初始区间
L = 0.16;
xh = 1.12;
xl = xh - (2*L);
%  在定位区间内绘制函数曲线
x = xl: 0.01: xh;
y = (1.6*sin(x)) - x;
D = 2*L;
r = (3 - sqrt(5))/2;  %  黄金分割系数（黄金分割比）
for  n = 1:4  %   限定搜索迭代次数为4步
    a = xl + (r*D);
    ya = (1.6*sin(a)) - a;
    b = xh - (r*D);
    yb = (1.6*sin(b)) - b;
    if yb < ya
        xh = b;  %  若右内点函数值更小，舍弃第三个子区间，更新上界
    else
        xl = a;  %  否则舍弃第一个子区间，更新下界
    end
    D = xh - xl;
    yl = (1.6*sin(xl)) - xl;
    yh = (1.6*sin(xh)) - xh;
    %  结果可视化展示
    figure(1)
    subplot(2, 2, n);
    plot(x, y, 'k');
    axis([0.79, 1.12, 0, 0.4]);
    hold on;
    plot([xl, xl], [0, yl], 'b--');
    plot([xh, xh], [0, yh], 'r--');
end
