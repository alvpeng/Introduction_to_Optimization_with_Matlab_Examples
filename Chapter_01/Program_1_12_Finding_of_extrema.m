% 例程 1.12  极值求解
%  多项式-三角函数示例
x = 0: 0.005: 3;
y = 3*cos(11*x) + x.^3 - x.^2 - 4*x + 12;
deriv = diff(y)./diff(x);  %  导数近似
xb = x(1:end - 1);  %  后向差分点
%  导数过零点
N = length(xb);
prods = zeros(1, N - 1);
for nn = 1:N - 1
    prods(nn) = deriv(nn)*deriv(nn + 1);
end
xc = xb(find(prods < 0));  %  过零点
derivc = deriv(find(prods < 0));
yc = y(find(prods < 0));
%  画图
figure(1)
plot(xb, deriv, 'k');
hold on;
plot(xc, derivc, 'r*');
grid on;
xlabel('x');  ylabel('导数');
figure(2)
plot(x, y, 'k');
hold on;
plot(xc, yc, 'r*');
axis([0  3  2  20]);
grid on;
xlabel('x');  ylabel('y');
