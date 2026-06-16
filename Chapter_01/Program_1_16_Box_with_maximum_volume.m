% 例程 1.16  最大容积的盒子
x = 0.6: 0.05: 2;
z = (5 - x.^2)./(2*x);
vol = z.*(x.^2);
xopt = sqrt(5/3);
figure(1)
plot(x, z, 'k');
hold on;
plot(x, vol, 'r');
plot([xopt, xopt], [0, 3.5], 'b--');
xlabel('x');  ylabel('z');
legend('表面积 = 10', '容积');
