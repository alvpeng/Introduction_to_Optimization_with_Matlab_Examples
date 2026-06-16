% 例程 14.6  基于 NBI 方法生成帕雷托前沿
%  定义目标函数
J1 = @(x) x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 9*x(1)^2 + 25;
J2 = @(x) x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - 3*x(2)^2 + 5;
%  单个目标函数最小化求解
x0 = [1; 1];
lb = [0; 0];
ub = [3; 3];
options = optimoptions('fmincon', 'Display', 'off');
[xmJ1, J1optval] = fmincon(J1, x0, [], [], [], [], lb, ub, [], options);
[xmJ2, J2optval] = fmincon(J2, x0, [], [], [], [], lb, ub, [], options);
%  理想点
Jid = [J1optval; J2optval];
%  构建支付矩阵 P
%  计算非对角元素（交叉目标函数值）
J2ex = feval(J2, xmJ1);
J1ex = feval(J1, xmJ2);
P = [J1optval - Jid(1), J2ex - Jid(1); J1ex - Jid(2), J2optval - Jid(2)];
%  生成CHIM直线上的点
N = 50;
Jim = zeros(N, 2);
Jpareto = zeros(N, 2);
xpareto = zeros(N ,2);
for  i = 1:N
    w = [(N-i)/N; i/N];
    Jim(i, :) = P*w;
end;
%  求解法向方向
%  切线近似计算
m = (Jim(N, 2) - Jim(1, 2))/(Jim(N, 1) - Jim(1, 1));
nd = -1/m;  %  垂直方向（法向）斜率
nX = 5;
nY = nd*nX;  %  法向线段长度
%  选取CHIM直线上任意一点作为原点
orX = Jim(30, 1);
orY = Jim(30, 2);
%  生成帕雷托前沿
x0 = [1.9; 1.7];
lb = [0; 0];
ub = [5; 5];
for i = 6:44
    w = [(N-i)/N; i/N];
    %  CHIM直线上的法向原点（随i变化）
    orig = P*w;
    %  沿法向搜索参数D
    %  当D未超过阈值时，dnew值较小；超过阈值即抵达可行域边界
    dnew = 0.0;
    xnew = [0; 0];
    D = 0.0;
    while  dnew < 0.04
        dold = dnew;
        xold = xnew;
        [xnew, dnew] = fmincon(@(x) obj_NBI(x, Jid, orig, D, nd), ...
            x0, [], [], [], [], lb, ub, [], options);
        Dold = D;
        D = D + 0.1;  %  步长0.1（十分位）
    end
    if Dold == 0
        D = Dold;
    else
        D = Dold - 0.1;
    end
    dnew = 0.0;
    xnew = [0; 0];
    while  dnew < 0.05
        dold = dnew;
        xold = xnew;
        [xnew, dnew] = fmincon(@(x) obj_NBI(x, Jid, orig, D, nd), ...
            x0, [], [], [], [], lb, ub, [], options);
        Dold = D;
        D = D + 0.01;  %  步长0.01（百分位）
    end
    xpareto(i, :) = xold;
    Jp1 = J1(xold);
    Jp2 = J2(xold);
    Jpareto(i, :) = [Jp1; Jp2];
end
%  结果可视化
figure(1)
plot(Jim(:, 1), Jim (:, 2), 'b-', 'LineWidth' ,2);
hold on;
xlabel('J1s');  ylabel('J2s');
plot(Jpareto(:, 1), Jpareto(:, 2), 'k*');
grid on;

function f = obj_NBI(x, Jid, orig, D, nd)
%  目标函数（求解法向直线与可行域边界的交点）
%  沿法向的移动坐标
lx = orig(1) - D;
ly = orig(2) - (nd*D);
% 计算目标函数值与法向直线的距离
distx = (x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - ...
    9*x(1)^2 + 25 - lx -Jid(1));
disty = (x(1)^4 + x(2)^4 + x(1)*x(2) - (x(1)^2)*(x(2)^2) - ...
    3*x(2)^2 + 5 - ly - Jid(2));
f = max(distx, disty);
end