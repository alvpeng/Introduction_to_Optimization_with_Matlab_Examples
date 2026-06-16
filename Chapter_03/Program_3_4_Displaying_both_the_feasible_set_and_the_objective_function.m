% 例程 3.4  同时绘制可行解集与目标函数
%  绘制目标函数（取3个不同的z值）
%  目标函数方程：ax + by = z;
a = 3;
b = 2;
%  目标函数直线与坐标轴的交点
z = 10;
X1 = z/a;
Y1 = z/b;
z = 20;
X2 = z/a;
Y2 = z/b;
z = 30;
X3 = z/a;
Y3 = z/b;
z = 26.323;
Xo = z/a;
Yo = z/b;
% 画图
figure(1)
%  绘制坐标轴
plot([-2, 12], [0, 0], 'b');
hold on;
plot([0, 0], [-2, 16], 'b');
%  绘制可行解集
xi = 576/172;
xf = 7;
yf = 10;
yi = yf - ((yf*xi)/18);
patch([0, 0, xi, xf], [0, yf, yi, 0], 'g');
%  绘制目标函数直线
plot([0, X1], [Y1, 0], 'r');
plot([0, X2], [Y2, 0], 'r');
plot([0, X3], [Y3, 0], 'r');
plot([0, Xo], [Yo, 0], 'm', 'LineWidth', 2);
compass(b*4, a*4, 'k');
