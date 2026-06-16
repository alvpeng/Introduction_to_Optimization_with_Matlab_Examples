% 例程 14.8  混合整数问题的帕雷托分析示例
%  x1 为连续变量，取值范围 -2 至 2（共 101 个取值点）
%  x2 为整数变量，取值范围 -4 至 4
%  生成决策变量空间的点
L = 101;  %  x1 取值集合的长度
N = 9*L;  %  变量点的总数
x = zeros(N, 2);
i = 1;
for  k = -4: 1: 4
    for  j = 1: L
        x(i, 1) = -2 + ((4*(j - 1))/100);
        x(i, 2) = k;
        i = i + 1;
    end
end
%  以下目标函数映射得到的点在目标空间的像
%  内存预分配
J1 = zeros(N, 1);
J2 = zeros(N, 1);
J = zeros(N, 2);
for  i = 1: N
    J1(i) = x(i, 1) + x(i, 2);
    J2(i) = x(i, 1)^2 + x(i, 2)^2;
    J(i, 1) = J1(i);
    J(i, 2) = J2(i);  %  形成一个矩阵
end;
%  在目标函数空间中检测非支配点
ndmt = J;  %  初始化非支配点矩阵
ndmt_ix = 1: N;
other_ix = [];
%  （不存在其他行在所有元素上都更优）
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
figure(1)
plot(J1(:), J2(:), 'b.');
hold  on
plot(J1(ndmt_ix), J2(ndmt_ix), 'r.');
xlabel('J1');  ylabel('J2');
axis([-7, 7, -1, 21]);
figure(2)
plot(x(:, 1), x(:, 2), 'b.');
hold  on
plot(x(ndmt_ix, 1), x(ndmt_ix, 2), 'r.');
xlabel('x1');  ylabel('x2');
axis ([-2, 2, -5, 5]);
