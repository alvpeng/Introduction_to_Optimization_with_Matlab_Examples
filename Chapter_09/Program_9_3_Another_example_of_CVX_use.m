% 例程 9.3  CVX 工具箱的另一个使用示例
c = [1; 1; -1; 1; -1];
A = [1, 1, 1, 1, 1; 1, 2, 3, 4, 5];
b = [1; 10];
cvx_begin
variable  x(5);
minimize(c'*x);
subject to
A*x == b;
{x(1: 2), x(3)} == lorentz(2);
{x(4), x(5)} == lorentz(1);
x(5) >= 1;
cvx_end
