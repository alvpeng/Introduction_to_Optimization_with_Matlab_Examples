% 例程 5.13  序列比对的编辑距离计算
%  编辑距离计算示例
A = 'KITCHEN';
B = 'CHICKEN';
n = length(A);
m = length(B);
D = zeros(n + 1, m + 1);
%  填充表格
%  填充第一列（边界条件：一个字符串为空时的编辑距离）
for i = 1:n
    D(i + 1, 1) = i;
end
%  填充第一行（边界条件：另一个字符串为空时的编辑距离）
for j = 1:m
    D(1, j + 1) = j;
end
%  填充其余表项
for i = 1:n
    for j =1: m
        if (A(i) == B(j))
            t = 0;
        else
            t = 1;
        end
        D(i + 1, j + 1) = min([(1 + D(i + 1, j)), (1 + D(i, j + 1)), (t + D(i, j))]);
    end
end
D
