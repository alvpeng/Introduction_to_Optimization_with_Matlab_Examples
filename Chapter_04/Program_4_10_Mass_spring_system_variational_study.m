% 例程 4.10  质量-弹簧系统的变分法分析
%  欧拉-拉格朗日方程示例
%  简易质量-弹簧系统
syms  m  k  x(t)
T = 1/2*m*diff(x, t)^2;
V = 1/2*k*x^2;
L = T - V
eqn = functionalDerivative(L, x) == 0
assume(m, 'positive')
assume(k, 'positive')
Dx(t) = diff(x(t), t);
xSol = dsolve(eqn, [x(1) == 10, D(1) == 0])
%  输出求解结果
xSol 
