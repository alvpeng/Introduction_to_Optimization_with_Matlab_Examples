% 例程 4.11  单摆小角度振动的变分法分析
%  欧拉-拉格朗日方程示例
%  单摆问题
syms  m  g  l  phi(t)
T = 1/2*m*(l^2)*diff(phi, t)^2;
V = m*g*l*(1 - cos(phi));
L = T - V
eqn = functionalDerivative(L, phi) == 0
eqlin = subs(eqn, sin(phi(t)), phi(t))
assume(g, 'positive')
assume(l, 'positive')
Dphi(t) = diff(phi(t), t);
xSol = dsolve(eqlin, [phi(0) == 0.1, Dphi(0) == 0])
%  绘制求解结果
g = 9.8;
l = 2;
y = subs(xSol)
fplot(y);
