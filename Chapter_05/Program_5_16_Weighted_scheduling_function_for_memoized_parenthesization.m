% 例程 5.16  加权调度：记忆化求解的核心函数
function q = M_opt(j, A, p)
global M pred;
if (j == 0)
q = 0;
else
if (M(j) == 10000)
[q, ix] = max([M_opt(j - 1, A, p), (A(j, 3) + M_opt(p(j), A, p))]);
if (ix == 1)
pred(j) = j - 1;  %  情况1：不选第j项活动，前驱为j-1
else
pred(j) = p(j);  %  情况2：选第j项活动，前驱为p(j)（相容前驱）
end;
M(j) = q;
else
q = M(j);
end;
end;
end;
