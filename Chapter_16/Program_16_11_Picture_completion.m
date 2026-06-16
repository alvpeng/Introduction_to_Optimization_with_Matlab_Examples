% 例程 16.11  图像补全
%  图像补全示例（使用道格拉斯-拉赫福德算法）
clear all;
disp('运行中...')
%  读取原始图像
figu = imread('patron.jpg');  %  读取图像文件
F = double(figu);
n = 225;
A = F(1: n, 1: n);  %  裁剪图像
aux = mean(mean(A));
A = A - aux;
disp('原始矩阵的核范数');
[u, d, v] = svd(A);
nuc_N = sum(diag(d))
%  对矩阵A进行随机采样：随机选取A中p个元素作为观测值
p = 12000;
aux = randperm(n*n);
ix = aux(1: p)';  %  提取前p个随机数作为采样位置索引
%  构造观测值列向量
b = A(ix);  %  保留A中对应采样位置的像素值
%  算法初始化
X = zeros(n, n);
Y = zeros(n, n);
L = n*n;
niter = 30;
lambda = 1.8;
gamma = 1000;  %  注意gamma的取值
rnx = zeros(niter, 1);
for nn = 1: niter
    %  更新X
    %  计算R(b - M(Y))项（残差累积）
    O = zeros(L, 1);
    %  累积重复采样位置的残差
    for j = 1: p
        ox = ix(j);
        O(ox) = O(ox) + (b(j) - Y(ox));
    end
    Q = reshape(O, [n, n]);
    %  邻近算子proxF（对应指示函数）
    X = Y + Q;
    %  更新Y
    %  邻近算子proxG（奇异值软阈值处理）
    P = (2*X) - Y;
    [U, D, V] = svd(P);
    for j = 1:n
        aux = D(j, j);
        if abs(aux) <= gamma
            D(j, j) = 0;
        else
            if aux > gamma
                D(j, j) = aux - gamma;
            end
            if aux < -gamma
                D(j, j) = aux + gamma;
            end
        end
    end
    S = U*D*V';  %  奇异值阈值处理结果
    Y = Y + (lambda*(S - X));
    %  记录核范数
    [u, d, v] = svd(X);
    rnx(nn) = sum(diag(d));  %  计算当前X的核范数
end
aux = mean(mean(X));
X = X - aux;
%  结果显示
rnx(end)
%  绘制核范数的迭代变化曲线
figure(1)
plot(rnx, 'k', 'LineWidth', 2);
title('核范数的变化');
xlabel('迭代次数');
figure(2)
imshow(A);
title('原始图像');
figure(3)
imshow(X);
title('重建后的图像')
