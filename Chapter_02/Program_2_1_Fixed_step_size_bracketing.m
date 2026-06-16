% 例程 2.1  固定步长区间搜索法
%  函数：y = (1.6*sin(x)) - x
%  第一步，绘制函数曲线
%  绘制该函数在指定区间内的图像
x = 0: 0.05: 1.4;
y = (1.6*sin(x)) - x;
figure(1)
plot(x, y, 'k');
hold on;
%  采用固定步长法确定极值所在区间
L = 0.16;  %  设定步长
x = 0;  %  设定x的初始值
flag = 0;
while flag == 0
    yold = (1.6*sin(x)) - x;
    plot([x, x], [0, yold], 'g');
    x = x + L;
    ynew = (1.6*sin(x)) - x;
    if ynew < yold
        flag = 1;
    end
end
%  极值解落在 x 和 x-2L 之间
plot([x, x], [0, ynew], 'r');
