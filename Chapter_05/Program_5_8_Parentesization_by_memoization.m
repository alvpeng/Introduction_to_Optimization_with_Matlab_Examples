% 例程 5.8  记忆化实现加括号法
n = 4;
p = [7, 3, 6, 5, 9];
h = 100000*ones(n, n);
global m;
m = triu(h);
Mchain(p, 1, n);
m
