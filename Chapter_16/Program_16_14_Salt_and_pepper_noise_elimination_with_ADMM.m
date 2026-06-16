% 例程 16.14  基于 ADMM 的椒盐噪声去除
%  源图像与参数设置
F = imread('martaBW.jpg');
sigma = 0.1;  %  噪声密度
M = imnoise(F, 'salt & pepper', sigma);
M = double(M);
lamb  = 0.1;
rho = 0.01 ;
niter = 70;
L = zeros(size(M));  %  低秩矩阵
S = zeros(size(M));  %  稀疏矩阵
Mu = zeros(size(M));  %  拉格朗日乘子
%  主循环
for i = 1: niter
    %  L子问题：奇异值阈值处理
    X = M + Mu./rho;
    [U, P, V] = svd(X - S, 'econ');
    L = U*shrink1(P, 1/rho)*V';
    %  S子问题：软阈值处理
    S = shrink1(X - L, lamb/rho);
    %  拉格朗日乘子更新
    Mu = Mu - rho*(L + S - M);
end
%  结果显示
figure(1)
subplot(1, 2, 1)
imshow(uint8(M));
title('原始含噪图像');
subplot(1, 2, 2)
imshow(uint8(L));
title('修复后图像');

%  收缩函数定义
function  Z = shrink1(X, r)
Z = sign(X).*max(abs(X) - r, 0);
end
