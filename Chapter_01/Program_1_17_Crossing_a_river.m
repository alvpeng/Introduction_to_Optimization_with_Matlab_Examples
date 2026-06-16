% 例程 1.17  过河问题
x = 0: 0.02: 8;
T = (sqrt(x.^2 + 9)/6) + ((8 - x)/8);
xopt = 9/sqrt(7);
figure(1)
plot(x, T, 'r');
hold on;
plot([xopt, xopt], [1.25, 1.55], 'b--');
axis([0, 8, 1.25, 1.55]);
xlabel('x');  ylabel('时间（小时）');
