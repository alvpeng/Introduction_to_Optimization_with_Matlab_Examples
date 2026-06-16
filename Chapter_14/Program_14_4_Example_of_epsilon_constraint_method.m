% 例程 14.4  ε-约束法示例
%  目标函数（J1）
fun = @(x) x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 9*x(1)^2 + 25;
%  流程准备
x0 = [1; 1];  %  初始点
UB = [3; 3];  %  上界
LB = [0; 0];  %  下界
options = optimoptions('fmincon', 'Display', 'off');
N = 50;  %  帕雷托点数量
epsi_min = 0;
epsi_max = 25;
epsi = epsi_min: (epsi_max - epsi_min)/(N - 1): epsi_max;
%  预分配内存空间
xopt = zeros(N, length(x0));
J1 = zeros(N, 1);
J2 = zeros(N, 1);
%  求解标量化后的问题
%  遍历每个ε值
for i =1: N
    limt = epsi(i);
    [xopt(i, :), J1(i)] = fmincon(fun, x0, [], [], [], [], ...
        LB, UB, @(x) nonlcon_epsi(x, limt), options);
    x = xopt(i, :);
    J2(i) = x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 3*x(2)^2 + 5;
end
%  结果可视化
figure(1)
plot(xopt(:, 1), xopt(:, 2), 'rs ');
hold on;
xlabel('x1');  ylabel('x2');
figure(2);
plot(J1(:), J2(:), 'ro');
hold  on;
xlabel('J1');  ylabel('J2');

function [C, Ceq] = nonlcon_epsi(x, limt)
%  约束函数（基于J2构建）
C = x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 3*x(2)^2 + 5 - limt;
Ceq = [];
end
