% 例程 4.1  等值线与约束曲线
x = 0: 0.1: 10;
y1 = 80 - (x.^2);
y2 = 60 - (x.^2);
y3 = 40 - (x.^2);
y4 = 20 - (x.^2);
yc = 60.63 + (40*(cos(x/3)));  %  约束条件
figure(1)
plot(x, yc, 'r'); hold  on;  %  绘制约束曲线
plot(x, y1, 'k');
plot(x, y2, 'k');
plot(x, y3, 'k');
plot(x, y4, 'k');
text(5, 8, '\rightarrow', 'FontSize', 50, 'Rotation', 65, 'color', 'g');
xlabel('x');  ylabel('y');
