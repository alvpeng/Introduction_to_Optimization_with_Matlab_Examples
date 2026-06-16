% 例程 16.10  分解为低秩矩阵与稀疏矩阵
%  将矩阵分解为低秩矩阵（L）和稀疏矩阵（S）
%  采用道格拉斯-拉赫福德算法
%  生成秩为r的随机矩阵
n = 100;
r = 8;  %  矩阵的秩
L0 = randn(n, r)*randn(r, n);  %  构造低秩矩阵
%  构造稀疏（十字形）矩阵
nn = 1: 100;
aux = diag(0.2*nn, 0);
S0 = aux + aux(end: -1: 1, :);
%  构造原始合成矩阵
M = L0 + S0;
%  参数设置
lambda = 0.2;
tk = 1;
Th = 1;  %  收缩阈值
niter = 40;  %  迭代次数
rnx = zeros(niter, 1);
L = zeros(n, n);
S = zeros(n, n);
%  算法开始迭代
for nn = 1: niter
    Le = 0.5*(M + L - S);
    Se = 0.5*(M - L + S);
    %  核范数收缩操作
    aux1 = (2*Le) - L;
    [U, D, V] = svd(aux1);
    for j =1:n
        D(j, j) = max(D(j, j) - Th, 0);
    end
    aux = U*D*V';
    L = L + (tk*(aux - Le));
    %  L1范数软阈值操作
    aux1 = (2*Se) - S;
    aux = sign(aux1).*max(0, abs(aux1) - lambda);
    S = S + (tk*(aux - Se));
    [u, d, v] = svd(L);
    rnx(nn) = sum(diag(d));  %  计算并存储L的核范数
end
%  结果显示
figure(1)
subplot(1, 2, 1)
imshow(L0, []);
title('原始低秩矩阵', 'FontSize', 14);
subplot (1, 2, 2)
imshow(S0, []);
title('原始稀疏矩阵', 'FontSize', 14)
figure(2)
imshow(M, []);
title('原始合成矩阵', 'FontSize', 14);
figure(3)
subplot(1, 2, 1)
imshow(L, []);
title('恢复的低秩矩阵', 'FontSize', 14)
subplot(1, 2, 2)
imshow(S, []);
title('恢复的稀疏矩阵', 'FontSize', 14)
figure(4)
DI = L0 - L;
J = imcomplement(DI);
imshow(J);  %  观察A 和 X 之间的区别
title('低秩矩阵：原始-恢复', 'FontSize', 14);
