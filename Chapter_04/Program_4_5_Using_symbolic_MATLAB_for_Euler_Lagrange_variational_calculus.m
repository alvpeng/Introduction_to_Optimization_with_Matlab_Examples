% 例程 4.5  使用符号型 MATLAB 求解欧拉-拉格朗日变分问题
syms  x(t)
F  = x(t)^2 + (diff(x(t), t)^2);  %  积分内的被积函数F
D1 = diff(F, x(t));
Dp = diff(F, diff(x(t), t));
D2 = diff(Dp, t);
ode = D1 - D2 == 0;
cond1 = x(0) == 0;
cond2 = x(1) == 1;
conds = [cond1, cond2];
xsol = dsolve(ode, conds);
xsol
