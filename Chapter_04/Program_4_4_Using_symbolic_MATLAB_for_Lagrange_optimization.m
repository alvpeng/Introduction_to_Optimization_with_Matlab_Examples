% 例程 4.4  利用符号型 MATLAB 求解拉格朗日优化问题
%  符号型 MATLAB 实现拉格朗日乘数法示例
syms  x  y  lambda
J = exp (x) - sin(y);  %  目标函数
g = x^2 + 3*y^2 - 1;  %  等式约束
L = J - lambda*g;
dL_dx = (diff(L, x) == 0);
dL_dy = (diff(L, y) == 0);
dL_dlambda = (diff(L, lambda) == 0);
system = [dL_dx; dL_dy; dL_dlambda];
[x_opt, y_opt, lambda_opt] = solve(system, [x, y, lambda], 'Real', true);
results_numeric = double([x_opt, y_opt, lambda_opt]);
Jmin = (exp(x_opt) - sin(y_opt));
% 绘图展示
figure(1)
m = -1: 0.2: 1;
[vx, vy] = meshgrid(m);
zJ = exp(vx) - sin(vy);
surf(vx, vy, zJ);
hold on;  %  绘制目标函数曲面
colormap('cool');
xlabel('x');  ylabel('y');
%  绘制椭圆约束曲线
q = sqrt(1/3);
y = -q: 0.002: q;
x = sqrt(1 - (3*y.^2));
z = 0*y;
sz = exp(x) - sin(y);
plot3(x, y, z, 'r');
plot3(x, y, sz, 'g', 'LineWidth', 3);
sz = exp(-x) - sin(y);
plot3(-x, y, z, 'r');
plot3(-x, y, sz, 'g', 'LineWidth', 3);
%  标注最小值点
plot3(x_opt, y_opt, Jmin, 'r*', 'LineWidth', 4);
view(-20, 35);
%  输出数值最优解
Jmin
x_opt
y_opt
