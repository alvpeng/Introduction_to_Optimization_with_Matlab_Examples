% 例程 13.3  引力搜索算法示例
clear all
%  种群数量 & 维度
pop_size = 60;
dim = 2;
%  迭代条件
max_iter = 30;
%  搜索空间范围
from = -30;
to = -1*from;
%  函数评价次数（Nfe）条件
nfe = 1;
max_nfe = 20000;
%  初始化随机种群
X = from + ((to - from)*rand(pop_size, dim));
%  计算适应度值
F_result = zeros(1, pop_size);
for i = 1: pop_size
    F_result(1, i) = GRobj(X(i, :));
    nfe = nfe + 1;
end
%  初始化最优 & 最差适应度值 (最小化问题)
fit_best = min(F_result(1, :));
fit_worst = max(F_result(1, :));
%  引力相关参数初始化
G = zeros(1, max_iter);
G0 = 0.98;
beta = 0.99;
empty = zeros(1, pop_size);
emptyX = zeros(pop_size, dim);
m = empty;
M = empty;
F_ij = emptyX;
F = emptyX;
acceleration = emptyX;
velocity = emptyX;
BestFit = zeros(1, max_iter);
%  主循环
for  iter = 1:max_iter
    %  计算引力常数
    %  引力常数衰减公式
    G(1, iter) = G0*((max_iter/(iter + max_iter))^beta);
    %  计算每个物体的质量
    m(1, :) = (F_result(1, :) - fit_worst)/(fit_best - fit_worst);
    M(1, :) = (m(1, :)/sum(m));
    %  计算作用在每个物体上的引力
    for nn = 1: pop_size
        F(nn, :) = zeros(1, dim);
        for jj = 1: pop_size
            dd = sum((X(nn, :) - X(jj, :)).^2);
            if (dd ~= 0)
                den = sqrt(dd) + eps;
                F_ij(nn, :) = G(1, iter)*((M(1, nn)*M(1, jj))/den)*(X(jj, :) - X(nn, :));
                F(nn, :) = F(nn, :) + (rand(1, dim).*F_ij(nn, :));
            end
        end
    end
    %  动力学计算（加速度、速度、位置更新）
    for nn = 1: pop_size
        acceleration(nn, :) = F(nn, :)/(M(1, nn) + eps);
        velocity(nn, :) = rand(1)*velocity(nn, :) + acceleration(nn, :);
        X(nn, :) = rand(1)*X(nn, :) + velocity(nn, :);
    end
    % 重新计算适应度值
    for  nn = 1: pop_size
        F_result(1, nn) = GRobj(X(nn, :));
        nfe = nfe + 1;
        if (nfe == max_nfe)  %  达到最大评价次数则终止
            break;
        end;
    end;
    %  更新最优和最差适应度值
    [fit_best, index] = min(F_result(1, :));
    fit_worst = max(F_result(1, :));
    BestFit(iter) = fit_best;
end  %  主循环结束
%  结果输出
X(index, :)
fit_best
figure(1)
L = -4;
U = 4;
nx = meshgrid(linspace(L, U, 31));
ny = meshgrid(linspace(L, U, 31))';
for i = 1:31
    for j = 1:31
        nz(i, j) = GRobj([nx(1, i), ny(j, 1)]);
    end
end
colormap('jet');
contour(nx, ny, nz, 8);
hold on;
plot(X(:, 1), X(:, 2), 'k*');
figure(2)
plot(0: max_iter - 1, BestFit, 'm');
xlabel('迭代次数');  ylabel('最优结果');

%  函数定义：Ackley函数（目标函数）
function  [Out] = GRobj(X)
T1 = -20*exp(-0.2*(sqrt(sum(X.^2, 2)*1./size(X, 2))));
T2 = exp(sum(cos(X*2*pi), 2)*1./size(X, 2));
Out = T1 - T2 + 20 + exp(1);
end