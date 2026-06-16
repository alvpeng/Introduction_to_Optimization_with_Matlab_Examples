% 例程 14.2  基于随机数据的帕雷托分析示例
%  两个空间上的帕雷托分析示例
%  随机生成决策变量空间的点
N = 500;  %  生成的点数
Var = 3;  %  方差
x = Var.*rand(N, 2);
%  通过以下函数计算这些点在目标空间的映射值
%  预分配内存
J1 = zeros(N, 1);
J2 = zeros(N, 1);
J = zeros(N, 2);
for  i = 1: N
    J1(i) = x(i, 1)^4 + x(i, 2)^4 + x(i, 1)*x(i, 2) - ...
    (x(i, 1)^2)*(x(i, 2)^2) - 9*x(i, 1)^2 + 25;
    J2(i) = x(i, 1)^4 + x(i, 2)^4 + x(i, 1)*x(i, 2) - ...
        (x(i, 1)^2)*(x(i, 2)^2) - 3*x(i, 2)^2 + 5;
    J(i, 1) = J1(i);
    J(i, 2) = J2(i); %  构成一个矩阵
end
%  在目标函数空间中检测非支配点
ndmt = J;  %  初始化非支配点矩阵
ndmt_ix = 1:N;
other_ix = [];  %  支配点的索引存储
i = 1;
j = 1;
while  i <= size(ndmt, 1)
    r = size(ndmt, 1);
    bb = ones(r, 1)*ndmt(i, :) - ndmt;
    bb(i, :) = ' ';
    if any(all(bb' >= 0))
        ndmt(i, :) = [];
        other_ix(j) = ndmt_ix(i);
        ndmt_ix(i) = ' ';
        j = j + 1;
        i = i - 1;
    end
    i = i + 1;
end
if isempty(ndmt_ix)
    disp('未找到帕雷托点');
end
%  寻找极小极大（minimax）非支配点
[m, ix] = min(max(J(ndmt_ix, :)'));
px = ndmt_ix(ix);  %  该点的原始索引
J(px, :)  %  输出该点的目标函数值
D = [];
np = length(ndmt_ix);
for i =1: np
    D(i) = ndmt(i, 1)^2 + ndmt(i, 2)^2;
end
[d, jx] = sort(D);
ix = jx(1);
pd = ndmt_ix(ix);  %  该点的原始索引
J(pd, :)
%  结果可视化
figure(1)
plot(J1(:), J2(:), 'bo');
hold  on
plot(J1(ndmt_ix), J2(ndmt_ix), 'r*');
%  绘制极小极大点
plot(J1(px), J2(px), 'k+', 'MarkerSize', 16, 'LineWidth', 2);
plot([0, J1(px)], [0, J2(px)], 'k--');
%  绘制距离原点最近的点
plot(J1(pd), J2(pd), 'mx', 'MarkerSize', 16, 'LineWidth', 2);
plot([0, J1(pd)], [0, J2(pd)], 'm--');
axis([0, 45, 0, 45]);
xlabel('J1');  ylabel('J2');
figure (2)
plot(x(:, 1), x(:, 2), 'bo');
hold  on;
plot(x(ndmt_ix, 1), x(ndmt_ix, 2), 'r*');
%  绘制极小极大点对应的决策变量
plot(x(px, 1), x(px, 2), 'k+', 'MarkerSize', 16, 'LineWidth', 2);
%  绘制距离原点最近点对应的决策变量
plot(x(pd, 1), x(pd, 2), 'mx', 'MarkerSize', 16, 'LineWidth', 2);
axis([0, 3, 0, 3]);
xlabel('x1');  ylabel('x2');
