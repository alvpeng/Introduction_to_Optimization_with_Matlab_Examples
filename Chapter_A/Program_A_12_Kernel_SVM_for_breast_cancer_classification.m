% A.12(P7.13) 基于核函数的支持向量机（Kernel-SVM）乳腺癌分类
%  基于核函数的支持向量机（Kernel-SVM）乳腺癌分类
D = dlmread('wdbc.data');  %  读取数据文件（按列存储）
X = [D(:, 3), D(:, 7)];  %  选取两列特征作为x、y维度
N = size(D, 1);
%  预处理标签：将恶性（M）替换为-1，良性（B）替换为1
Y = D(:, 2);
%  特征归一化
X(:, 1) = X(:, 1)/30;
X(:, 2) = X(:, 2)/0.18;
%  构建二次规划问题（SVM核心）
C = 8.1;  %  惩罚系数（软间隔参数）
threshold = 0.05;  %  支持向量筛选阈值（软间隔用）
%  标签对角矩阵
Dy = diag(Y);
%  高斯核函数计算
ps = X*X';  %  向量内积
normx = sum(X.^2, 2);
[nps, mps] = size(ps);
aux = -2*ps + repmat(normx, 1, mps) + repmat(normx', nps, 1);
K = exp(-aux/2);  %  高斯核矩阵
H = (Dy*K*Dy);
H = (H + H')/2;  %  强制对称化（保证数值稳定性）
f = -ones(N, 1);
Aeq = Y';
ceq = 0.0;
%  变量边界（alpha的范围）
cL = zeros(N, 1);
cU = repmat(C, N, 1);
%  优化器参数设置
options = optimset('LargeScale', 'off', 'Display', 'off', 'MaxIter', 600);
alpha = quadprog(H, f, [], [], Aeq, ceq, cL, cU, [], options);
%  筛选满足条件的支持向量索引
serial_n =(1: size(X, 1))';
ser_sv = serial_n((alpha > threshold) &(alpha <(C - 0.05)));
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
b = baux/size(ser_sv, 1);  %  决策函数的偏置项
%  构建可视化网格测试点
[xg1, xg2] = meshgrid([0: 0.01: 1], [0: 0.01: 1]);
[nl, nc] = size(xg1);
q = nl*nc;
xt1 = reshape(xg1, 1, q);
xt2 = reshape(xg2, 1, q);
xt = [xt1; xt2]';  %  测试点集合
xtest = xt;
%  对测试点计算高斯核
ps = xt*xsup';  %  测试点与支持向量的内积
normxt = sum(xt.^2, 2);
normxsup = sum(xsup.^2, 2);
[nps, mps] = size(ps);
yt = zeros(nps, 1);
aux = -2*ps + repmat(normxt, 1, mps) + repmat(normxsup', nps, 1);
Kt = exp(-aux/2);  %  测试点的高斯核矩阵
yt(:) = yt(:) + Kt*w(1:mps);
yt = yt + b;
yt2d = reshape(yt, nl, nc);
%  结果可视化
figure(1)
%  背景颜色映射
colormap('summer')
contourf(xg1, xg2, yt2d, 20);
shading flat;
hold on
%  绘制原始数据点
for ii = 1: N
    if Y(ii) < 0
        plot(X(ii, 1), X(ii, 2), 'r*', 'MarkerSize', 8);
    else
        plot(X(ii, 1), X(ii, 2), 'co', 'MarkerSize', 6);
    end
end
%  绘制分类超平面和间隔边界
[L, A] = contour(xg1, xg2, yt2d, [-1, 0, 1], 'k');
clabel(L, A);  %  标注超平面（0）和间隔（±1）
xlabel('x1');  ylabel('x2');
title('核函数SVM：不可分数据分类');
axis([0, 1, 0, 1]);
