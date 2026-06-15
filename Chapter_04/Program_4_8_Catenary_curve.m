% 例程 4.8 悬链线
%  悬链线绘制
t = -1: 0.1: 1;
K1 = 3;
K2 = 0;
x = (K1*t) + K2; 
y = K1*cosh(t);
%  绘图展示
plot([-4, 4], [0, 0], 'k--');
hold on;
plot([0, 0], [-2, 6], 'k--');
plot(x, y, 'k');
xlabel('x');  ylabel ('y');
