% 例程 10.6  内点法求解二次规划示例
%  问题定义
Q = [2, 0; 0, 2];
c = [-2; -5];
%  多边形约束条件
A =[1  -2; -1 -2];
b = [-2; -6];
x0 = [3; 0.2];  %  初始点
n = 2;  %  变量维度
E = [1; 1];  %  全1列向量
%  调用quadprog()获取参考解
%  注：需传入-A和-b以适配quadprog的约束格式
solRef = quadprog(Q, c, -A, -b, [], [], [], [], x0, optimset('Display', 'off'));
%  内点法（IPM）初始化
%  用于记录迭代过程中的数据
Nit = 100;
ux = zeros(2, Nit);
us = zeros(2, Nit);
uy = zeros(2, Nit);
umalpha = zeros(1, Nit);
usigma = zeros(1, Nit);
mu = [];
s = [1.15; 1];  %  松弛变量s的试探性初始值
y = [40; 40];  %  拉格朗日乘子y（λ）的试探性初始值
x = x0;
%  迭代主循环
for nn = 1: Nit,  %  可修改最大迭代次数
mu(end + 1) = (sum(y.*s))/n;
%  计算仿射预测步
Dp = A*x - b - s;
Dd = Q*x - (A'*y) + c;
rxs = -s.*y;
xaux = (s.*((A'\Q)*E)) + (y.*(A*E));
raux = rxs - (s.*(A'\Dd)) - (y.*Dp);
dx_a = raux./xaux;
ds_a = Dp + (A*dx_a);
dy_a = A'\(Dd + (Q*dx_a));
%  确定仿射步的最大允许步长alpha_aff（简易线搜索）
paux = 1;
alpha = 1;
while  paux > 0
yaux = min(y + (alpha*dy_a));
saux = min(s + (alpha*ds_a));
if (yaux < 0 || saux < 0)
alpha = alpha - 0.001;
if alpha <= 0
alpha = 0;
alpha_aff = 0;
paux = 0;
end;
else
alpha_aff = alpha;
paux = 0;
end;
end;
muaff = sum((y + (alpha_aff*dy_a).*(s + (alpha_aff*ds_a))))/n;
%  计算中心参数sigma
sigma = min((muaff/mu(end))^3, 1);
%  计算聚合步
rxs = (sigma*mu(end) - y.*s - dy_a.*ds_a);
raux = rxs - (s.*(A'\Dd )) - (y.*Dp);
dx = raux./xaux;
ds = Dp + (A*dx);
dy = A'\Dd + (Q*dx));
%  确定最终步长
tau = 0.1;
my = -tau*y./dy;
my(dy > 0) = Inf;
laux1 = min(my);
ms = -tau*s./ds;
ms(ds > 0) = Inf;
laux2 = min(ms);
malpha = min(laux1, laux2);
x = x + malpha*dx;
y = y + malpha*dy;
s = s + malpha*ds;
%  保存迭代数据
ux(:, nn) = x;
us(:, nn) = s;
uy(:, nn) = y;
umalpha(nn) = malpha;
usigma(nn) = sigma;
end;
%  绘制等高线图（目标函数+约束）
%  等高线数据
[vx1, vx2] = meshgrid(0: 0.05: 6, 0: 0.05:4);
z = 0.5*Q(1, 1)*(vx1.^2) + (Q(2, 1) + Q(1, 2))*vx1.*vx2 + ...
0.5*Q(2, 2)*(vx2.^2) + c(1)*vx1 +c(2)*vx2;
figure(1)
colormap('hsv');
patch([0, 2, 6, 0, 0], [1, 2, 0, 0, 1], [0.3, 0.8, 0.7]);
hold on;
contour(vx1, vx2, z, 30, 'LineWidth', 1.5);
plot([0, 5], [1, 7/2], 'k--', 'LineWidth', 2);  %  绘制约束1
plot([0, 5], [3, 1/2], 'k--', 'LineWidth', 2);  %  绘制约束2
%  绘制quadprog参考解
plot(solRef(1), solRef(2), 'bo', 'MarkerSize', 10, 'LineWidth', 3);
plot(ux(1, :), ux(2, :), 'or');
x
J = (0.5*x'*Q*x) + (c'*x)
figure(2)
subplot(1, 2, 1)
plot(us(1, :), 'r'); hold  on ;
plot(us(2, :), 'b');
subplot(1 ,2 ,2)
plot(uy(1, :), 'r'); hold  on ;
plot(uy(2, :), 'b');
figure(3)
subplot(1, 2, 1)
plot(umalpha(1, :), 'r');
subplot(1, 2, 2)
plot(usigma(1, :), 'm');
figure(4)
plot(mu, 'k');
