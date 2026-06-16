% A.11(P7.8) SQP 迭代算法示例
%  SQP 迭代算法示例
clear all; close all; clc;
%  初始化
vars = 2;  %  变量数量
cons = 1;  %  约束数量
maxIter = 100;  %  最大迭代次数
xrecord = zeros(vars, maxIter + 1);
x = [-0.5; 4];  %  初始猜测点
xrecord(:, 1) = x;
lambda = 0;  %  拉格朗日乘子向量
H = eye(vars, vars);  %  初始海森矩阵
%  初始点处的函数值与梯度计算
fEval = sqpf(x);
gEval = sqpg(x);
[gViol, lViol] = Viols(gEval, lambda);
gradfEval = gradf(x);
gradgEval = gradg(x);
P = Penalty(fEval, gViol, lViol);
%  算法迭代过程
for iter = 1: maxIter
    %  求解KKT条件（二次近似的最优解）
    sol = SolveKKT(gradfEval, gradgEval, gEval, H);
    xSol = sol(1: vars);
    lSol = sol(vars + 1: vars + cons);
    %  若拉格朗日乘子为负，将其置零
    for j = 1: length(lSol)
        if  lSol(j) < 0
            sol = H - gradfEval';
            xSol = sol(1: vars);
            lSol(j) = 0;
        end
    end
    %  新候选点的函数值与梯度计算
    xNew = x + xSol;
    lNew = lSol;
    fEvalNew = sqpf(xNew);
    gEvalNew = sqpg(xNew);
    gradfEvalNew = gradf(xNew);
    gradgEvalNew = gradg(xNew);
    [gViolNew, lViolNew] = Viols(gEvalNew, lNew);
    PNew = Penalty(fEvalNew, gViolNew, lViolNew);
    %  若惩罚函数值增加，将步长减半
    while  PNew - P >1e-4
        xSol = 0.5*xSol;
        xNew = x + xSol;
        fEvalNew = sqpf(xNew);
        gEvalNew = sqpg(xNew);
        gradfEvalNew = gradf(xNew);
        gradgEvalNew = gradg(xNew);
        [gViolNew, lViolNew] = Viols(gEvalNew, lNew);
        PNew = Penalty(fEvalNew, gViolNew, lViolNew);
    end
    %  终止条件判断
    if norm(xNew(1:vars) - x(1:vars)) <= 1e-2
        break;
    end
    %  海森矩阵更新。注意：使用lNew而非l！
    gradLEval = gradLagr(gradfEval, gradgEval, lNew, vars);
    gradLEvalNew = gradLagr(gradfEvalNew, gradgEvalNew, lNew, vars);
    Q = gradLEvalNew - gradLEval;
    dx = xNew - x;
    HNew = UpdateH(H, dx, Q);
    %  为下一次迭代更新参数
    H = HNew;
    fEval = fEvalNew;
    gEval = gEvalNew;
    gradfEval = gradfEvalNew;
    gradgEval = gradgEvalNew;
    P = PNew;
    x = xNew;
    xrecord(:, iter + 1) = x;
end
%  结果展示
[vx1, vx2] = meshgrid(-2: 0.1: 1, -1: 0.1: 6);
y = (vx1.^4) - (2*vx2.*(vx1.^2)) + (vx2.^2) + (vx1.^2) - (2*vx1) + 5;
figure(1)
patch([-2, -2, 1, 1], [-1, 4.0833, 2.0833, -1], [0.6, 0.9, 0.85]);
hold  on;
contour(vx1, vx2, y, 30, 'LineWidth', 1.5);
hold on;
%  绘制约束边界
plot([-2, 1], [4.0833, 2.0833], 'k--', 'LineWidth', 2.5);
% 绘制初始点
plot(xrecord(1, 1), xrecord(2, 1), 'ko', 'LineWidth', 4);
%  绘制最终解
plot(x(1), x(2), 'kd', 'MarkerSize', 8, 'LineWidth', 3);
%  绘制SQP迭代路径
plot(xrecord(1, 1:iter), xrecord(2, 1:iter), 'r', 'LineWidth', 2);
xlabel('x1');  ylabel('x2');
disp(['x(1) = ', num2str(x(1))]);
disp(['x(2) = ', num2str(x(2))]);
disp([' 迭代次数 = ', num2str(iter)]);

function  y = sqpf(x)
y = x(1)^4 - 2*x(2)*x(1)^2 + x(2)^2 + x(1)^2 - 2*x(1) + 5;
end

function  y = sqpg(x)
y(1) = -(x(1) + 0.25)^2 + 0.75*x(2);
end

function  y = gradf(x)
y(1) = 2*x(1) - 4*x(1)*x(2) + 4*x(1)^3 - 2;
y(2) = -2*x(1)^2 + 2*x(2);
end

function y = gradg(x)
y(1,1) = -2*x(1) -1/2;
y(1,2) = 3/4;
end

function  y = gradLagr(gradfEval, gradgEval, l, n)
y = gradfEval';
sum = zeros(n, 1);
for i = 1:length(l)
    sum = sum - l(i)*gradgEval(i: n)';
end
y = y + sum;
end

function  y = SolveKKT(gradfEval, gradgEval, gEval, Hessian)
A = [Hessian, -gradgEval'; gradgEval, 0];
b = [-gradfEval, -gEval]';
y = A\b;
end

function y = UpdateH(H, dx, gamma)
term1 =(gamma*gamma')/(gamma'*dx);
term2 =((H*dx)*(dx'*H))/(dx'*(H*dx));
y = H + term1 - term2;
end

function [gViol, lViol] = Viols(gEval, l)
gViol = [];
lViol = [];
for i = 1: length(gEval)
    if gEval(i) < 0
        gViol(i) = gEval(i);
        lViol(i) = l(i);
    end
end
end

function y = Penalty(fEval, gViol, lViol)
sum = 0;
y = fEval;
for i = 1: length(gViol)
    sum = sum + lViol(i)*abs(gViol(i));
end
y = y + sum;
end
