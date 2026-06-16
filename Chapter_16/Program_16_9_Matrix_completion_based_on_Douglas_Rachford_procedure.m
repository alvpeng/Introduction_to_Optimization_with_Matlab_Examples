% 例程 16.9  基于道格拉斯-拉赫福德方法的矩阵补全
%  矩阵补全示例（使用道格拉斯-拉赫福德算法）
clear all;
disp('运行中...');
%  生成秩为r的随机矩阵
n = 100;
r = 16;  %  矩阵的秩
A = randn(n, r)*randn(r, n);  %  原始随机矩阵
disp('原始矩阵的核范数：');
[u, d, v] = svd(A);
nuc_N = sum(diag(d));
%  对矩阵A进行随机采样：随机选取A中p个元素作为观测值
p = round(n*log(n)*r);  %  采样数量（参考理论公式）
aux = randperm(n*n);
ix = aux(1: p)';  %  提取前p个随机数作为采样位置索引
%  构造观测值列向量b
b = A(ix);  %  保留A中对应采样位置的元素值
%  算法初始化
X = zeros(n, n);  %  待重建的矩阵（初始化为零矩阵）
Y = zeros(n, n);
L = n*n;
niter = 80; %  迭代次数
lambda = 1;
gamma = 2;
rnx = zeros(niter, 1);
for nn = 1: niter
    %  更新X
    O = zeros(L, 1);
    %  累积重复采样位置的残差
    for j = 1: p
        ox = ix(j);
        O(ox) = O(ox) + (b(j) - Y(ox));
    end
    Q = reshape(O, [n, n]);
    %  邻近算子proxF（对应指示函数）
    X = Y + Q;  %  更新X
    %  更新Y
    %  邻近算子proxG（奇异值软阈值处理）
    P = (2*X) - Y;
    [U, D, V] = svd(P);
    for j = 1:n ,
        aux = D(j, j);
        if abs(aux) <= gamma
            D(j, j) = 0;
        else
            if aux > gamma
                D(j, j) = aux - gamma;
            end;
            if aux < -gamma
                D(j, j) = aux + gamma;
            end
        end 
    end
    S = U*D*V';  %  奇异值阈值处理结果
    Y = Y + (lambda*(S - X));
    %  记录当前迭代的核范数
    [u, d, v] = svd(X);
    rnx(nn) = sum(diag(d));  %  计算X的核范数
end
%  结果显示
%  绘制核范数的迭代变化曲线
figure(1)
plot(rnx, 'k');
xlabel('迭代次数');
%  验证重建精度
figure(2)
%  X为重建后的矩阵
%  生成另一随机矩阵用于对比
B = randn(n, r)*randn(r, n);
subplot(1, 2, 1)
imshow(A - B);  %  显示A与B的差值
title('A - B', 'FontSize', 14);
subplot(1, 2, 2)
DI = A - X;
J = imcomplement(DI);
imshow(J);  %  显示A与重建矩阵X的差值
title('A - X', 'FontSize', 14);
%  计算累积误差
er = sum(sum(A - X))
