% 例程 4.9  旋转最小表面积
%  求解旋转最小表面积问题
%  借助符号函数functionalDerivative实现
syms  y(x)
f = (2*pi*y*sqrt(1 + diff(y)^2));
eqn = functionalDerivative(f, y) == 0;
eqn = simplify(eqn)
