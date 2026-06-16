% A.15(P12.7) 布谷鸟搜索算法实现
%  布谷鸟搜索算法，向量化实现
%  参数设置
Nn = 25;  %  鸟巢数量
rd = 0.25;  %  发现概率
tol = 0.001;  %  收敛容忍度
%  变量边界
Nd = 2;  %  问题维度
bl = -5*ones(1, Nd);
bu = 5*ones(1, Nd);
%  目标函数可视化
[vx1, vx2] = meshgrid(-5: 0.1: 5, -5:0.1:5);
y =(vx1.^2) +(vx2.^2) +(25*((sin(vx1)).^2)) +(25*((sin(vx2)).^2));
figure(1)
colormap('winter');
mesh(vx1, vx2, y);
hold on;
contour(vx1, vx2, y);
%随机初始化鸟巢
for jj = 1: Nn
    nest(jj, :) = bl +(bu - bl).*rand(size(bl));
end
%  初始化适应度值
fitness = (10^10)*ones(Nn, 1);
[OFV, bestnest, nest, fitness] = bestNest(nest, nest, fitness);
%  算法主循环
niter = 0;
while (OFV > tol)
    %  生成新解（保留当前最优解）
    new_nest = getCucks(nest, bestnest, bl, bu);
    [Fnew, best, nest, fitness] = bestNest(nest, new_nest, fitness);
    niter = niter + Nn;  %  更新迭代计数器
    %  发现与替换劣质鸟巢
    new_nest = emptyNests(nest, bl, bu, rd);
    %  评估替换后的新解
    [Fnew, best, nest, fitness] = bestNest(nest, new_nest, fitness);
    niter = niter + Nn;  %  再次更新迭代计数器
    %  更新全局最优
    if(Fnew < OFV)
        OFV = Fnew;
        bestnest = best;
    end
end
%  结果输出
OFV
bestnest
figure(2)
contour(vx1, vx2, y, 20);
hold  on;
for i = 1: Nn
    plot(nest(i, 1), 'ro');
    nest(i, 2);
end

%  函数定义，生成布谷鸟新解
function  nest = getCucks(nest, best, bl, bu)
N = size(nest, 1);
beta = 3/2;
aux1 = gamma(1 + beta);
aux2 = gamma((1 + beta)/2);
aux3 = 2^((beta - 1)/2);
sigma = (aux1*sin(pi*beta/2)/(aux2*beta*aux3))^(1/beta);
%  Levy飞行生成新解
for i = 1: N
    s = nest(i, :);
    aux = size(s);
    u = sigma*randn(aux);
    v = randn(aux);
    step = u./abs(v).^(1/beta);
    stepsize = 0.01*step.*(s - best);
    s = s + stepsize.* randn(aux);
    nest(i, :) = useBounds(s, bl, bu);
end
end

%  寻找最优鸟巢
function [OFV, bnest, nest, fitness] = bestNest(nest, newnest, fitness)
%  评估新解的适应度
for i = 1: size(nest, 1)
    aux = newnest(i, :);
    %  蛋箱函数
    x1 = aux(1);
    x2 = aux(2);
    fnew = (x1^2) + (x2^2) + (25*((sin(x1))^2)) + (25*((sin(x2))^2));
    if fnew <= fitness(i)
        fitness(i) = fnew;
        nest(i, :) = newnest(i, :);
    end
end
[OFV, ix] = min(fitness);
bnest = nest(ix, :);
end

%  替换被发现的劣质鸟巢
function new_nest = emptyNests(nest, bl, bu, rd);
%  以概率rd发现劣质鸟巢并替换
N = size(nest, 1);
K = rand(size(nest)) > rd;
%  生成新解
stepsize = rand*(nest(randperm(N), :) - nest(randperm(N), :));
new_nest = nest + stepsize.*K;
for  i = 1: size(new_nest, 1)
    aux = new_nest(i, :);
    new_nest(i, :) = useBounds(aux, bl, bu);
end
end

%  边界约束处理函数
function s = useBounds(s, bl, bu);
%  应用下边界约束
qaux = s;
ix = qaux < bl;
qaux(ix) = bl(ix);
%  应用上边界约束
jx = qaux > bu;
aux(jx) = bu(jx);
s = qaux;
end
