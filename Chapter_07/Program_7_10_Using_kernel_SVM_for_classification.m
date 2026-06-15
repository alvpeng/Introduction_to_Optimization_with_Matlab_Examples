% 例程 7.10  核支持向量机（Kernel-SVM）分类示例
%  2个人工生成的数据簇（非线性可分）
%  二维数据（分布在两段圆弧周围）
N = 200;
M = N/2;
X1 = zeros(M, 2);
X2 = zeros(M, 2);  %  两个数据集
mu1 = 0;
sigma1 = 0.35;
mu2 = 2.5;
sigma2 = 0.25;
for nn = 1:M
R1 = mu1 + (sigma1*randn(1));
phi1 = rand(1)*2*pi;
X1(nn, 1) = R1*cos(phi1);
X1(nn, 2) = R1*sin(phi1);
R2 = mu2 + (sigma2*randn(1));
phi2 = -1.7 + (1.1*rand(1)*pi);
X2(nn, 1) = R2*cos(phi2);
X2(nn, 2) = R2*sin(phi2);
end;
X = [X1; X2];
Y = ones(N, 1);
Y(1:M, 1) = -Y(1:M, 1);  %  标签
%  准备二次规划求解参数
C = 10;
threshold = 0.05;  %  软间隔参数
%  标签对角矩阵
Dy = diag(Y);
%  高斯核函数计算
ps = X*X';  %  标量积
normx = sum(X.^2, 2);
[nps, mps] = size(ps);
aux = -2*ps + repmat(normx, 1, mps) + repmat(normx', nps, 1);
K = exp(-aux/2);  %  高斯核
H = (Dy*K*Dy);
H = (H + H')/2;  %  确保矩阵对称c
f = -ones(N, 1);
Aeq = Y';
ceq = 0.0;
%  变量上下界
cL = zeros(N, 1);
cU = repmat(C, N, 1);
% 优化器参数设置
options = optimset('LargeScale', 'off', 'Display', 'off', 'MaxIter', 1000);
alpha = quadprog(H, f, [], [], Aeq, ceq, cL, cU, [], options);
%  筛选满足条件的拉格朗日乘子索引
serial_n = (1: size(X, 1))';
ser_sv = serial_n((alpha > threshold) & (alpha < (C - 0.01)));
nVectors = size(ser_sv, 1);
%  提取支持向量
xsup = X(ser_sv, :);
ysup = Y(ser_sv);
w = alpha(ser_sv).*ysup;
baux = 0;
maux = 0;
for  ii = 1: nVectors
baux = baux + Y(ser_sv(ii));
maux = sum(alpha(ser_sv(ii))*Y(ser_sv(ii))*K(ser_sv, ser_sv(ii)));
baux = baux - maux;
end
b = baux/size(ser_sv, 1);  %  决策函数的偏置项系数
%  准备可视化用的测试点网格
[xg1, xg2] = meshgrid([-3: 0.2: 4], [-4: 0.2: 4]);
[nl, nc] = size(xg1);
q = nl*nc;
xt1 = reshape(xg1, 1, q);
xt2 = reshape(xg2, 1, q);
xt = [xt1; xt2]';  %  测试点集合
xtest = xt;
% 高斯核函数计算（测试点）
ps = xt*xsup';  %  标量积
normxt = sum(xt.^2, 2);
normxsup = sum(xsup.^2, 2);
[nps, mps] = size(ps);
yt = zeros(nps, 1);
aux = -2*ps + repmat(normxt, 1, mps) + repmat(normxsup', nps, 1);
Kt = exp(-aux/2);  %  高斯核（测试点）
yt(:) = yt(:) + Kt*w(1: mps);
yt = yt + b;
yt2d = reshape(yt, nl, nc);
%  结果可视化
figure(1)
%  背景等高线填充
colormap('cool')
contourf(xg1, xg2, yt2d, 20);
shading flat;
hold on;
%  绘制数据点
scatter(X(:, 1), X(:, 2), 16, 'y');
%  绘制分类线和间隔线（取值为-1、0、1的等高线）
[L, A] = contour(xg1, xg2, yt2d, [-1, 0, 1], 'k');
clabel(L, A);  %  绘制带标签的等高线
%  绘制支持向量
scatter(xsup(:, 1), xsup(:, 2), 60, 'kd');
xlabel('x1');  ylabel('x2');
title('核支持向量机，非线性可分数据');
axis ([-3, 4, -4, 4]);
