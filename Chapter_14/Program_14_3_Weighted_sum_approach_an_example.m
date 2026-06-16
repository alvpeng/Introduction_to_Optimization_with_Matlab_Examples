% 例程 14.3  加权和法示例
N = 100;
%  预分配内存
xopt = zeros(N, 2);  J1 = zeros(N, 1);
J2= zeros(N,1 );  J = zeros(N, 1);
%  定义目标函数（加权和形式，L为0~1之间的权重系数）
f = @(x, L)((L*(x(1)^4 + x(2)^4 + x(1)*x(2) - ...
    (x(1)^2)*(x(2)^2) - 9*x(1)^2 + 25)) + ...
    ((1 - L)*((x(1)^4 + x(2)^4 + x(1)*x(2) - ...
    (x(1)^2)*(x(2)^2) - 3*x(2)^2 + 5))));
%  针对一系列L值计算最优解
x0 = [1, 1];  %  决策变量初始值
for ix = 1:N
    L = ix/N;
    fun = @(x)f(x, L);
    options = optimoptions('fmincon', 'Display', 'off');
    %  调用fmincon进行约束优化（决策变量范围[0,0]~[3,3]）
    [x, fval] = fmincon(fun, x0, [], [], [], [], [0, 0], [3, 3], [], options);
    xopt(ix, :) = x;
    J(ix) = fval;
    J1(ix) = x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 9*x(1)^2 + 25;
    J2(ix) = x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 3*x(2)^2 + 5;
end
%  目标函数空间可视化（帕雷托前沿）
figure(1)
for ix = 1:N
    plot(J1(ix), J2(ix), 'ro');
    hold on;
end
axis([0, 30, 0, 30]);
xlabel('J1');  ylabel('J2');
%  决策变量空间可视化
figure(2)
for ix = 1:N
    plot(xopt(ix, 1), xopt(ix, 2), 'ro');
    hold  on;
end
axis([0, 3, 0, 3]);
xlabel('x1');  ylabel('x2');
%  组合曲线图（L与J1/J2/加权和的关系）
figure(3)
jx = (1: N)*(1/N );  %  生成L的取值序列（0~1）
plot(jx, J1, 'b-', 'LineWidth', 1.5);
hold on;
plot(jx, J2, 'm-', 'LineWidth', 1.5);
plot(jx, J, 'g-', 'LineWidth', 2);
xlabel('L');
%  寻找极小极大点
disp('极小极大点');
[val, kx] = min(max(J1, J2));
xopt(kx, :)
disp('J1 和 J2 的值');
J1(kx)
J2(kx)
