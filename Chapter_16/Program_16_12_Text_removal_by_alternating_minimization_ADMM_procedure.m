% 例程 16.12  基于交替最小化（ADMM）方法的文字去除
%  将矩阵分解为低秩矩阵（L）和稀疏矩阵（S）
%  交替最小化算法
figu = imread('grafiti1.jpg');  %  读取图像文件
F = double(figu);
n = 350;
M = F(1: n, 1: n);  %  裁剪图像
aux = mean(mean(M));
M = M - aux;
%  参数设置
lambda = 0.1;
lambF = 1.01 ;
Th = 1;  %  阈值
rank0 = 1;  %  秩的初始猜测值
irk = 1;  %  秩的增量
nnL = 1000;  %  循环次数
rank = rank0 ; %当前秩
%  算法开始迭代
[UL, SL, VL] = lansvd(M, rank, 'L');  %  对M进行部分奇异值分解
L1 = UL*SL*VL';  %  初始低秩近似矩阵
aux = M - L1;
S1 = sign(aux).*max(0, abs(aux) - lambda);  %  软阈值收缩
for nn = 2: nnL
    if irk == 1
        %  每次迭代调整lambda
        lambda = lambda*lambF;
        rank = rank + irk;  %  增加秩的取值
    end
    [UL, SL, VL] = lansvd(M - S1, rank, 'L');  %  对M - S1进行部分奇异值分解
    L1 = UL*SL*VL';  %  更新低秩近似矩阵
    aux = M - L1;
    S1 = sign(aux).*max(0, abs(aux) - lambda);  %  软阈值收缩更新S1
    %  适时调整秩的增量
    vv = diag(SL);
    rho = vv(end)/sum(vv(1:end - 1));
    if rho < Th
        irk = 0;
    else
        irk = 1;
    end
end
%  结果显示
figure(1)
imshow(M, []);
title('原始图像', 'FontSize', 14)
figure(2)
subplot(1, 2, 1)
imshow(L1, []);
title('低秩分量', 'FontSize', 14)
subplot(1, 2, 2)
imshow(S1, []);
title('稀疏分量', 'FontSize', 14)
