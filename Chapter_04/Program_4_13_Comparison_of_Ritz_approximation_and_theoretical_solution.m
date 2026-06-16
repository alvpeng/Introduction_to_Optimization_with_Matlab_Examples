% 例程 4.13  里茨法近似解与理论解的对比
%  里茨法近似解与理论解对比
x = 0: 0.1: 2;
yT = (x.*(1 - x.^3))/12;
yA = (x.*(1 - x).*(2 + 5*x))/30;
figure(1)
plot(x, yT, 'r'); hold on;  % 绘制解析解
plot(x, yA, 'b');
xlabel('x');  ylabel('y');
