% A.19(P16.15) 基于分裂布雷格曼迭代的图像修复
%  基于分裂布雷格曼迭代的图像修复示例
%  源图像与参数设置
global  uk
u = double(imread('TTo.jpg'));  %  原始照片
[height, width] = size(u);
mmk = double(imread('MK1.jpg'));  %  编辑后的掩码
Mask = mmk(1: height, 1: width);  %  必要时裁剪掩码
lambda = 255;
gamma = 0.5;
niter = 4000;
%  将掩码转换为负掩码
Lambda = zeros(size(u));
for i = 1: height
    for j = 1: width
        if Mask(i, j) > 220
            Lambda(i, j) = 0;
        else
            Lambda(i, j) = lambda;
        end
    end
end
b_x = zeros(height, width);
b_y = zeros(height, width);
uk = zeros(height, width);
e1 = ones(width, 1);
e2 = ones(height, 1);
D1 = spdiags([-e1, e1], 0:1, width, width);
D1(width, 1) = 1;
D1 = D1';
D2 = spdiags([-e2, e2], 0:1, height, height);
D2(height, 1) = 1;
%  主迭代循环
for  nn = 1: niter
    %  d子问题求解
    [x_grad, y_grad] = u_grad(uk, D1, D2);
    [d_x, d_y] = shrink2(x_grad, y_grad, b_x, b_y, gamma);
    %  u子问题求解（高斯-塞德尔迭代）
    Gk = gau_seid1(d_x, d_y, b_x, b_y, Lambda, gamma, u, uk, height, width);
    dif = (uk - Gk).^2;
    uk = Gk;
    %  更新布雷格曼辅助变量
    b_x = b_x + x_grad - d_x;
    b_y = b_y + y_grad - d_y;
end
%  结果显示
figure(1)
subplot(1, 2, 1);
imshow(uint8(u));
title('原始图像');
subplot(1, 2, 2);
imshow(uint8(uk));
title('修复后图像');

%  计算图像梯度
function  [x_grad, y_grad] = u_grad(u, D1, D2)
x_grad = u*D1;
y_grad = D2*u;
end

%  二维收缩操作（软阈值）
function  [d_x, d_y] = shrink2(x_grad, y_grad, b_x, b_y, gamma)
x1 = (x_grad + b_x)./abs(x_grad + b_x);
m1 = abs(x_grad + b_x) - 1/gamma;
m1 = max(m1, 0);
d_x = x1.*m1;
d_x(isnan(d_x)) = 0;
x2 = (y_grad + b_y)./abs(y_grad + b_y);
m2 = abs(y_grad + b_y) - 1/gamma;
m2 = max(m2, 0);
d_y = x2.*m2;
d_y(isnan(d_y)) = 0;
end

%  高斯-塞德尔迭代求解u子问题
function Gk = gau_seid1(d_x, d_y, b_x, b_y, lambda, gamma, u, uk, height, width)
D_prod = lambda.*u;
lambda_4g = lambda + 4* gamma;
coef1 = D_prod./lambda_4g;
coef2 = gamma./lambda_4g;
lapla = [0, 1, 0; 1, 0, 1; 0, 1, 0];
uk_sum = conv2(padarray(uk, [1, 1], 'replicate', 'both'), lapla, 'same');
uk_sum = uk_sum(2: height + 1, 2: width + 1);
db_sum = diff_row(d_x) + diff_col(d_y) - diff_row(b_x) - diff_col(b_y);
Gk = coef1 + coef2.*(uk_sum + db_sum);
end

%  行方向差分计算
function x_diff = diff_row(x_data)
[row, aux] = size(x_data);
x_data_rowless = [x_data(1, :);
    x_data(1: row - 1, :)];
x_diff = x_data_rowless - x_data;
end

%  列方向差分计算
function y_diff = diff_col(y_data)
[aux, col] = size(y_data);
y_data_rowless = [y_data(:,1), y_data(:, 1: col - 1)];
y_diff = y_data_rowless - y_data;
end
