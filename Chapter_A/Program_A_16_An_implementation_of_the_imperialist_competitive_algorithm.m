% A.16(P13.3) 帝国竞争算法（ICA）的实现
%  帝国竞争算法（ICA）示例
clear all;
%  种群规模 & 问题维度
pop_size = 100;
dim = 2;
%  迭代条件
max_iteration = 500;
%  记录迭代过程中的最优结果
Best_fit = zeros(max_iteration, 1);
%  变量取值范围
from = 0;
to = 10;
%  函数评价次数（Nfe）条件
nfe = 0;
max_nfe = 40000;
%  随机初始化种群（国家）
Countries = from + ((to - from)*rand(pop_size, dim));
%  国家数量
n_empire = ceil(0.1*pop_size);
Empires = zeros(n_empire, dim + 1);
%  殖民地数量
n_col = pop_size - n_empire;
Colonies = zeros(n_col, dim + 2);
%  每个国家的最小殖民地数
min_col = 3;
%  革命率
rev_rate = 0.2;
%  计算适应度 & 排序
[sorted_Countries, nfe, F_result] = ...
    ICA_Sort(Countries, pop_size, nfe, dim, max_nfe);
%  初始化帝国
Empires(:, 1: dim) = sorted_Countries(1: n_empire, :);
Empires(:, dim + 1) = F_result(1, 1: n_empire)';
%  初始化殖民地
Colonies(:, 1:dim) = sorted_Countries(n_empire + 1:end, :);
Colonies(:, dim + 1) = F_result(1, n_empire + 1:end)';
%  绘制初始帝国分布图
figure(1)
[vx1, vx2] = meshgrid(0: 0.1:10, 0:0.1: 10);
y = (vx1.*sin(4*vx1)) + 1.1*(vx2.*sin(2*vx2));
colormap('cool');
contour(vx1, vx2, y, 10);
hold  on;
plot(Empires(:, 1), Empires(:, 2), 'k*', 'MarkerSize', 14);
xlabel('x');  ylabel('y');
%  每个帝国的归一化适应度
emptyE = zeros(1, n_empire);
cn = emptyE;
Cn = emptyE;
cn(1, :) = Empires(:, dim + 1)';
Cn(1, :) = max(cn) - cn(1, :);
Best_fit(1) = min(Empires(:, dim + 1));  %  初始最优拟合
%  每个帝国的相对实力
pn = emptyE;
pn(1, :) = abs(Cn(1, :)/sum(Cn));
%  每个帝国分配的初始殖民地数量
NCn = emptyE;
NCn(1, :) = min_col;
NCn(1, :) = NCn(1, :) + (round(pn(1, :)*(n_col - (n_empire*min_col))));
%  打乱殖民地顺序
randx = randperm(n_col);
Colonies = Colonies(randx, :);
%  将殖民地分配给各个帝国
j = 1;
k = NCn(1, 1);
for  i = 1: n_empire
    Colonies(j: k, dim + 2) = i;
    j = j + NCn(1, i);
    if i + 1 > n_empire
        break;
    end
    k = k + NCn(1, i + 1);
end
%  控制分配边界
if size(Colonies, 1) > n_col
    Colonies = Colonies(1: n_col, :);
end
for i = 1: n_col
    if Colonies(i, dim + 2) == 0
        rand_empire = 1+ round((n_empire - 1)*rand);
        Colonies(i, dim + 2) = rand_empire;
    end
end
%  主循环开始
for  iteration = 1: max_iteration
    %  计算帝国与其殖民地之间的欧氏距离
    distance = zeros(n_col, dim);
    for  i = 1: n_empire
        for j = 1: n_col
            if Colonies(j, dim + 2) == i
                distance(j, :) = sqrt(sum((Empires(i, 1: dim) - Colonies(j, 1: dim)).^2));
            end
        end
    end
    %  殖民地向帝国移动
    beta = 2;
    teta = (-pi /4) + ((pi /2)*rand(n_col, dim));
    x = zeros(n_col, dim);
    aux = beta*distance(:, :);
    [Mx, Nx] = size(aux);
    x(:, :) = aux.*rand(Mx, Nx);
    X = teta.*x;
    Colonies(:, 1: dim) = X + Colonies(:, 1: dim);
    %  控制殖民地的取值范围
    for  i = 1: n_col
        for  j = 1: dim
            r_c = rand;
            if (Colonies(i, j) > to)
                Colonies(i, j) = to - r_c;
            elseif (Colonies(i, j) < from)
                Colonies(i, j) = from + r_c;
            end
        end
    end
    %  计算新殖民地的适应度
    Colonies(:, dim + 1) = ImpObj(Colonies(:, 1: dim));
    nfe = nfe + n_col;
    %  终止条件判断
    if (nfe >= max_nfe)
        break;
    end
    %  帝国与殖民地位置交换（若殖民地适应度更优）
    for  i = 1: n_empire
        for j = 1: n_col
            if Colonies(j, dim + 2) == i
                if Colonies(j, dim + 1) < Empires(i, dim + 1)
                    temp = Empires(i, 1: dim + 1);
                    Empires(i, 1: dim + 1) = Colonies(j, 1: dim + 1);
                    Colonies(j, 1: dim + 1) = temp;
                end
            end
        end
        %  计算每个帝国殖民地的平均适应度
        ind = find(Colonies(:, dim + 2) == i);
        if (isempty(ind) == 0)
            Empires(i, dim + 2) = mean(Colonies(ind(1): ind(end), dim + 1));
        end;
    end;
    %  每个帝国的综合实力
    zeta = 0.05;
    TCn = Empires(:, dim + 1) + (zeta*Empires(:, dim + 2));
    %  每个帝国的归一化综合实力
    NTCn = max(TCn) - TCn;
    %  每个帝国的接管概率
    %  加1避免除零错误
    Ppn = abs(NTCn/(1 + sum(NTCn)));
    %  殖民地竞争
    if (size(Empires, 1) > 1)
        R = rand(n_empire, 1);
        D = Ppn - R;
        %  找出最弱帝国
        weak_emp_ind = find(NTCn == min(NTCn));
        weak_colonies = sortrows(Colonies(Colonies(:, dim + 2) ...
            == weak_emp_ind(1), :), (dim + 1));
        colonies_takeover_size = ceil(size(weak_colonies, 1)*0.5);
        takeover_ind = find(D == max(D));
        for i = 1: colonies_takeover_size
            aux1 = (Colonies(:, dim + 2) == weak_emp_ind(1));
            aux2 = (Colonies(:, dim + 1) == weak_colonies(i, dim + 1));
            fx = find(aux1 & aux2);
            weakest_colonies_ind = fx(1);
            Colonies(weakest_colonies_ind, dim + 2) = takeover_ind;
        end
    end
    %  最弱帝国的消亡
    if (size(weak_colonies,1) - colonies_takeover_size) == 0
        if n_empire - 1 ~= 0
            n_col = n_col + 1;
            n_empire = n_empire - 1;
            Colonies(n_col, 1: dim + 1) = Empires(weak_emp_ind(1), 1: dim + 1);
            rand_empire = 1 + round((n_empire - 1)*rand);
            Colonies(n_col, dim + 2) = rand_empire;
            Empires(weak_emp_ind(1), :) = [];  %  删除最弱帝国行
            %  重新编号
            for  index = n_empire + 1: -1: weak_emp_ind(1)
                if index - 1 ~= 0
                    Colonies(Colonies(:, dim + 2) == index, dim + 2) = index - 1;
                end
            end
        end
    end
    %  革命过程
    y = from + ((to - from)*rand(floor(rev_rate*n_col), dim));
    for i = 1: size(y, 1)
        rand_rev = 1 + round((n_col - 1)* rand);
        Colonies(rand_rev, 1: dim) = Colonies(rand_rev, 1:dim) + y(i, :);
    end
    Best_fit(iteration + 1) = min(Empires(:, dim + 1));
end
x = Empires(1, 1)
y = Empires(1, 2)
optim.value = Empires(1, 3)
figure(2)
y = (vx1.*sin(4*vx1)) + 1.1*(vx2.*sin(2*vx2));
colormap('winter');
contour(vx1, vx2, y, 10);
hold  on;
plot(Colonies(:, 1), Colonies(:, 2), 'mx', 'MarkerSize', 12, 'LineWidth', 2);
xlabel('x');  ylabel('y');
figure(3)
nn = 1: iteration;
plot(nn, Best_fit(nn), 'm');
xlabel('迭代次数');  ylabel('最优适应度值');

%  函数定义
%  ICA排序函数（按适应度升序排序）
function  [Out, nfe, fitness_result] = ICA_Sort(X, n_size, nfe, dim, max_nfe)
s = size(X, 1);
F_result = zeros(1, s);
for i = 1:s
    F_result(1, i) = ImpObj(X(i, :));
    nfe = nfe + 1;
    if (nfe >= max_nfe)
        break;
    end
end
[F_result, sorted_index] = sort(F_result, 2);
sorted = zeros(n_size, dim);
for j = 1: n_size
    sorted(j, :) = X(sorted_index(1, j), :);
end
Out = sorted;
fitness_result = F_result;
end

%  目标函数（Schwefel 2.26变体）
function [Out] = ImpObj(X)
x = X(1);
y = X(2);
Out = x*sin(4*x) + 1.1*y*sin(2*y);
end
