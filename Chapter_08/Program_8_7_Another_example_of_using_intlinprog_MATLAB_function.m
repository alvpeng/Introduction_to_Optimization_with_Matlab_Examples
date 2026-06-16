% 例程 8.7  使用 MATLAB 函数 intlinprog () 的另一个示例
f = [-5, -8];
intcon = 1:2;
A = [1, 1; 5, 9];
b = [6; 45];
lb = [0, 0];
ub = [Inf, Inf];
X = intlinprog(f, intcon, A, b, [], [], lb, ub);
X
