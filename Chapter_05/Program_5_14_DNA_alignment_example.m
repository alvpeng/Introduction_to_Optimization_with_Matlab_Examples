% 例程 5.14  DNA 序列比对示例
A = 'ACGCATCA';
B = 'ACTGATTCA';
n = length(A);
m = length(B);
sA = [];
sB = [];
sg1 = 2;  sg2 = -3;  sg3 = -2;  sg4 = -2;  %  sigma值
S = zeros(n + 1, m + 1);
%  填充表格
%  填充第一列（边界条件：第二条序列为空，第一条序列逐个插入空位）
for i = 1: n
    S(i + 1, 1) = S(i, 1) + sg3;
end
%  填充第一行（边界条件：第一条序列为空，第二条序列逐个插入空位）
for j = 1:m
    S(1, j + 1) = S(1, j) + sg4;
end
%  填充其余表项（核心递推逻辑）
for i = 1: n
    for j = 1: m
        if (A(i) == B(j))
            t = sg1;
        else
            t = sg2;
        end
        S(i + 1, j + 1) = max([(sg4 + S(i + 1, j)), (sg3 + S(i, j + 1)), (t + S(i, j))]);
    end
end
%  回溯获取比对后的序列
i = n;  j = m;
%  空位用数字0表示
while  (i > 0 || j > 0)
    if (i > 0  &&  S(i + 1, j + 1)  ==  S(i, j + 1) + sg4)
        sA = [A(i), sA ];
        sB = [0, sB];
        i = i - 1;
    elseif (j > 0  &&  S(i + 1, j + 1)  ==  S(i+1, j) + sg3)
        sA = [0, sA];
        sB = [B(j), sB];
        j = j - 1;
    else
        sA = [A(i), sA];
        sB = [B(j), sB];
        i = i - 1;
        j = j - 1;
    end
end
S
sA
sB
