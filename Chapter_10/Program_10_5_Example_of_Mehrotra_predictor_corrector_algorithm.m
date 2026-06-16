% 例程 10.5  梅赫拉特拉预测-校正算法示例
%  定义优化问题
c = [-2; -3];
A = [3, 7; 5, 2];
b = [21; 10];
%  使用linprog函数获取参考解
[X, Fval] = linprog(c, A, b, [], [], zeros(1, 2));
disp('使用 linprog 求解:------------------- ')
X
Fval
%  使用梅赫拉特拉算法求解
%  为满足Ax = b引入人工变量，重构问题
c = [-2; -3; 0; 0];
A = [3, 7, 1, 0; 5, 2, 0, 1];
b = [21; 10];
m = size(A, 1);
n = size(A, 2);
%  寻找初始点
R = builtin('_cholinf', A*A');
y = R\(R'(A*c)); %求解对偶变量λ的初始值
s0 = c - (A'*y);
x0 = A'*(R\(R'\b));
dx = max(1.5*min(x0), 0);
ds = max(-1.5*min(s0), 0);
x = x0 + dx + 0.5*((x0 + dx)'*(s0 + ds))/sum(s0 + ds);
s = s0 + ds + 0.5*((x0 + dx)'*(s0 + ds))/sum(x0 + dx );
xi = x;
si = s;
nb = mean(abs(b));
mu = [];
%  迭代主循环
for nn = 1:30  %  可修改最大迭代次数
    mu(end + 1) = sum(x.*s)/n;
    %  计算右端项残量
    Dp = A*x - b;
    Dd = A'*y + s - c;
    rxs = x.*s;
    %  收敛判断
    aux = mean(abs(Dp));
    if mu(end) < 1e-6  &&  aux < 1e-6*nb,
        disp('使用 Mehrotra 算法求解:----------------------');
        disp('迭代次数:');
        nn
        x
        MeH_Fval = c'*x
        break;
    end
    R = builtin('_cholinf', A*diag(sparse(x./s))*A');
    %  计算仿射尺度步
    r = -Dp + A*((-x.*Dd + rxs)./s);
    dy_a = R\(R'\ r);
    ds_a = -Dd - A'*dy_a;
    dx_a = -( rxs + x.*ds_a)./s;
    xaff_step = Meh_dist(x, dx_a);
    saff_step = Meh_dist(s, ds_a);
    muaff = sum(( x + (xaff_step*dx_a)).*(s + (saff_step*ds_a)))/n;
    %  计算中心参数σ
    sigma = min((muaff/mu(end))^3, 1);
    %  计算校正步
    rxs = -(sigma * mu(end) - dx_a.*ds_a);
    r = A*(rxs./s);
    dy_c = R\(R'\r);
    ds_c = - A'*dy_c;
    dx_c = -(rxs + x.*ds_c)./s;
    dx = dx_a + dx_c;
    dy = dy_a + dy_c;
    ds = ds_a + ds_c;
    x_step = min(0.99*Meh_dist(x, dx), 1);
    s_step = min(0.99*Meh_dist(s, ds), 1);
    x = x + x_step*dx;
    y = y + s_step*dy;
    s = s + s_step*ds;
end
if nn == 30
    disp('未收敛');
end
%  子函数定义
%  梅赫拉特拉算法专用的步长计算函数
function  [stp] = Meh_dist(x, dx)
st = -x./dx;
st(dx >= 0) = Inf;
stp = min(st);
if stp > 1
    stp = 1;
end
end
