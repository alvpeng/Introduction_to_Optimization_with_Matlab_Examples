% 例程 5.7  记忆化加括号法函数
function  q = Mchain(p, i, j)
global m;
if (m(i, j) < 100000)
q = m(i, j);
return;
end;
if (i == j)
m(i, j) = 0;
q = 0;
return;
end;
q = m(i, j);
for k = i: j - 1
u = Mchain(p, i, k) + Mchain(p, k + 1, j) + (p(i)*p(k + 1)*p(j + 1));
if (u < q)
q = u;
end;
end;
m(i, j) = q;
end;
