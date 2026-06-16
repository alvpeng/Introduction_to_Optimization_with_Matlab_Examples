% 例程 8.6  使用 MATLAB 函数 intlinprog ()
f = [-3; -2; -1];
intcon = 3;  %  第三个变量为整数变量
A = [1, 1, 1];
b = 7;
Aeq = [4, 2, 1];
beq = 12;
lb = zeros(3, 1);
ub = [Inf; Inf; 1];
X = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub);
X
