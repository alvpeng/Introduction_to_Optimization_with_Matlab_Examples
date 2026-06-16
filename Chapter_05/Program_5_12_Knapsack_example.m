% 例程 5.12  背包问题示例
%  变量定义
N = 6;  %  物品总数
W = 10;  %  背包最大承重
w = [4, 2, 3, 1, 6, 4];  %  各物品的重量
v = [6, 4, 5, 3, 9, 7];  %  各物品的价值
x = zeros(6, 1);  %  记录物品是否被选中（1=选中，0=未选中）
f = zeros(6, 11);  %  动态规划表（行=物品数，列=重量）
%  填充表格
%  填充第一行（仅考虑第一个物品）
for nc = 1: W+1
    g = nc - 1;
    if (w(1) > g)
        f(1, nc) = 0;
    else
        f(1, nc) = v(1);
    end
end
%  填充其余行
for nr = 2:N  %  遍历第2到第N个物品（行）
    for nc = 1: W + 1  %  遍历所有重量（列）
        g = nc - 1;
        if (w(nr) > g)
            f(nr, nc) = f(nr - 1, nc);
        else
            f(nr, nc) = max((v(nr) + f(nr - 1, nc - w(nr))), f(nr - 1, nc));
        end
    end
end
%  回溯获取选中的物品
g = W;
for nr = N: -1: 2
    if (f(nr, g + 1) ~= f(nr - 1, g + 1))
        x(nr) = 1;
        g = g - (w(nr)*x(nr));
    end
end
f
x
