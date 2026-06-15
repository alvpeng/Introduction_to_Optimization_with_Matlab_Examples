% 例程 4.14  伽辽金法近似解与理论解的对比
%  伽辽金法近似解与理论解对比
x = 0: 0.1: 2;
yT = (sin(x)/sin(1)) - x;
yA = x.*(1 - x).*((71/369) + (7/41)*x);
figure(1)
plot(x, yT, 'r');  hold on;  %  绘制解析解（红色）
plot(x, yA, 'b');
xlabel('x');  ylabel ('y');
