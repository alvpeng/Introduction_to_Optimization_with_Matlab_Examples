% 例程 12.2  混合蛙跳算法示例
%  混合蛙跳算法简易实现代码
m = 4;  %  模因组数量
n = 4;  %  每个模因组中的青蛙数量
F = m*n;  %  青蛙总数量
Nvar = 10;  %  变量维度数
MaxIter = 1000;  %  最大迭代次数
%  记录迭代过程中的最优代价（用于追踪迭代效果）
bestc = zeros(MaxIter, 1);
w = 1;
C1 = 1;
C2 = 2;
%  初始化青蛙种群
population = cell(1, F);
for  i = 1:F
    population{i} = frogmaker(Nvar);
end
%  优化主循环
for iter = 1:MaxIter
    for  i = 1:F
        cost(i) = objfcn(population{i});
    end
    [vals, idxs] = sort(cost);
    best_cost = vals(1);
    Xg = population{idxs(1)};  %  全局最优青蛙（最优解）
    bestc(iter) = best_cost;  %  记录当前迭代的最优代价（用于绘图）
    %  按代价升序重新排列种群
    aux = prod(size(population));
    for  nn = 1:aux
        U2{nn} = population{idxs(nn)};
    end
    population = U2;
    %  划分模因组并进行局部搜索
    for  i = 1: m
        X = {};
        for  j = (i - 1)*n + 1: i*n
            X = [X, population{j}];
        end
        Xb = X{1};  %  模因组内最优青蛙（局部最优）
        Xw = X{end};  %  模因组内最差青蛙（局部最差）
        aux = prod(size(X));
        for  j = 2: aux - 1
            X2 = w*X{j} + C1*rand*(Xb - Xw);
            if  objfcn(X2) < objfcn(X{j})
                X{j} = X2;
            else
                X2 = w*X{j} + C2*rand*(Xg - Xw);
                if objfcn(X2) < objfcn(X{j})
                    X{j} = X2;
                end
            end
        end
        X{end} = frogmaker(Nvar);  %  替换模因组内最差的青蛙（重新随机生成）
        for nx = 1:numel(X)
            Xcost(nx) = objfcn(X{nx});
        end
        [nnx, Xidx] = sort(Xcost);
        aux = prod(size(X));
        for  nn = 1:aux  %  对更新后的模因组重新排序
            Y2{nn} = X{Xidx(nn)};
        end
        X = Y2;
        memeplex{i} = X;  %  存储更新后的模因组
    end
    newpop = [];
    for i = 1:m
        newpop = [newpop, memeplex{i}];
    end
    population = newpop;
end
best_solution = Xg
best_cost
figure(1)
ni = 1:MaxIter;
plot(ni, bestc(ni), 'm');
xlabel('迭代次数');  ylabel('最优值');
%  子函数：目标函数
function  cost = objfcn(X)
cost = 0;
aux = prod(size(X));
for i = 1:aux
    cost = cost + X(i)^2;
end
end
%  子函数：生成单个青蛙（随机初始化解）
function  frog = frogmaker(NF)
minv = -5;
maxv =5;
frog = minv + (maxv - minv)*rand(1, NF);
end
