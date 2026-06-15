% 例程 1.11  多项式‑三角函数示例
x = 0: 0.005: 3;
y = 3*cos(11*x) + x.^3 - x.^2 - 4*x + 12;
%  画图
figure (1)
plot(x, y, 'k');
axis([0, 3, 2, 20]);
grid on;
xlabel ('x');  ylabel ('y');
