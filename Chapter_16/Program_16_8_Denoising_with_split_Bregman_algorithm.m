% 例程 16.8  基于分裂布雷格曼算法的图像去噪
%  分裂布雷格曼各向同性全变差（TV）去噪
%  初始化参数
lambda = 0.5;
mu = 0.4;
P = imread('ActressH.jpg');
[M, N] = size(P);
%  注：该图像为正方形，M=N
A = imnoise(P, 'poisson');
f = reshape(A, [], 1);  %  转换为单列向量（含噪声图像）
n = length(f);
F = double(f);
%  分裂布雷格曼全变差（TV）去噪算法
%  初始化
d = zeros(2*n, 1);
b = d;
%  梯度算子
D = spdiags([-ones(N, 1), ones(N, 1)], [0, 1], N, N + 1);
D(:, 1) = [];
D(1, 1) = 0;
del_x = kron(speye(N), D);
del_y = kron(D, speye(N));
B = [del_x; del_y];
Bt =B';
BtB = Bt*B;
%  迭代循环
for iter = 1:5
    %  图像更新
    aux1 = speye(n)+ BtB ;
    aux2 = lambda *Bt *(b-d);
    [u_update, r] = cgs(aux1, F - aux2, 1e-5, 100);
    %  更新d和b
    Bub = (B*u_update) + b;
    s = sqrt(Bub(1: n).^2 + Bub(n + 1: end).^2);
    q = mu/lambda;
    d = [max(s - q, 0).*Bub(1:n)./s;
        max(s - q, 0).*Bub(n + 1:end)./s];
    b = Bub - d;
    %  计算原始图像与去噪图像的差值总和
    acuDif = sum(F - u_update)
end
%  结果显示
figure;
imshow(A);
title('含噪声图像');
u_den = reshape(u_update, N, N);
figure;
imshow(uint8(u_den));
title('去噪后图像');
