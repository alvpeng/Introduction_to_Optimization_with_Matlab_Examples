% 例程 5.4  矩阵链迭代法
%  矩阵链迭代法
n = 4;
p = [7, 3, 6, 5, 9];
m = zeros(n, n);  s = zeros(n, n);
for i = 1: n
m(i, i) = 0;
end;
for v = 2: n
for i = 1:(n - v + 1)
j = i + v - 1;
m(i, j) = 100000;
for k = i:(j - 1)
q = m(i, k) + m(k+1, j) + (p(i)*p(k + 1)*p(j + 1));
if (q < m(i, j)),
m(i, j) = q;
s(i, j) = k;
end;
end;
end;
end;
m
s
