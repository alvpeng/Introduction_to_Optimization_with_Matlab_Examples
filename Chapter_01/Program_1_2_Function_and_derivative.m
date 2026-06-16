% 例程 1.2  函数与导数
x = -1.8: 0.05: 1.8;
y = sin(4*x) + (x.^3);
deriv = diff(y)./diff(x);  %  导数近似
figure(1)
plot(x, y, 'k');
figure(2)
plot(x(1:end - 1), deriv, 'k');
