% 例程 1.18  多项式拟合
x = 0: 0.1: 10;  %  自变量数据集
y = x.^2 + 3*x + 15;  %  函数 y = f(x)
N = length(x);  %  数据点的数量
di = randn(1, N);  %  随机分布
ym = y + (10*di);  %  给数据添加一些扰动
%   对含扰动的数据进行多项式拟合:
[P, S] = polyfit(x, ym, 2);
ye = polyval (P, x);  %  估算的y值
%  结果画图
figure(1)
plot(x, y, ':g'); hold on;  %  绘制原始数据
plot(x, ym, 'xr');  %  绘制含扰动的数据
plot(x, ye, 'k');  %  绘制拟合曲线
xlabel('x');  ylabel('y');
cor = corrcoef(ym, ye);  %  拟合质量检验
