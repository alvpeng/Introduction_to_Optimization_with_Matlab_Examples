% 例程 4.7  使用 functionalDerivative 符号函数求解问题
%  求解最速降线微分方程
%  借助符号函数functionalDerivative实现
syms  g  y(x)
assume(g, 'positive')
f = sqrt((1 + diff(y)^2)/(2*g*y));
eqn = functionalDerivative(f, y) == 0;
eqn = simplify(eqn)
