% 例程 5.5  矩阵链问题中矩阵相乘的函数
% 用于矩阵链乘法的函数
function  M = Multip(F, s, i, j)
if (i == j),
M = F{i};
else
X = Multip(F, s, i, s(i, j));
Y = Multip(F, s, s(i, j) + 1, j);
M = X*Y;
end;
