% 例程 9.1  二阶锥规划示例
%  约束定义，范数约束： norm(Asc *x - bsc) <= d'*x - gamma;
Asc = diag([0.9, 1/2, 0.7]);
bsc = zeros(3, 1);
d = [0; 0; 1];
gamma = 0;
%  定义二阶锥约束：
socCT = secondordercone(Asc, bsc, d, gamma);
f = [-2, -3,1];  %  目标函数系数向量
Aineq = [];
bineq = [];
Aeq = [];
beq = [];
lb = [-Inf, -Inf, 0];
ub = [Inf, Inf, 2];
[x, fval] = coneprog(f, socCT, Aineq, bineq, Aeq, beq, lb, ub)
