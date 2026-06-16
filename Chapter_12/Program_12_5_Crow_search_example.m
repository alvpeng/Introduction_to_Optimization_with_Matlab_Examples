% 例程 12.5  乌鸦搜索算法示例
format long;
pd = 10;  %  问题维度
N = 20;  %  种群规模（乌鸦数量）
AP = 0.1;  %  感知概率
fl = 2;  %  飞行长度（fl）
[x, l, u] = init(N, pd);  %  初始化乌鸦位置
xn = x;
ft = Cfitness(xn, N, pd);  %  适应度评估
mem = x;  %  位置记忆矩阵
fit_mem = ft;  %  适应度记忆数组
%  主循环
tmax = 200;  %  最大迭代次数
for t =1:tmax
    %  随机选择待跟踪的目标乌鸦编号
    num = ceil(N*rand(1, N));
    for i = 1:N
        if rand > AP
            %  生成乌鸦i的新位置（状态1：跟踪成功，向目标藏匿点靠近）
            xnew(i, :) = x(i, :) + fl*rand*(mem(num(i), :) - x(i, :));
        else
            for j = 1:pd
                %  生成乌鸦i的新位置（状态2：被发现，随机游走）
                xnew(i, j) = l - (l - u)*rand;
            end
        end
    end
    xn = xnew;
    %  新解的适应度评估
    ft = Cfitness(xn, N, pd);
    for  i = 1: N  %  更新位置与记忆矩阵
        if xnew(i, :) >= l & xnew(i, :) <= u
            x(i, :) = xnew(i, :);  %  更新乌鸦位置
            if ft(i) < fit_mem(i)
                mem(i, :) = xnew(i, :);  %  更新记忆的位置
                fit_mem(i) = ft(i);
            end
        end
    end
    %  记录第t次迭代时的最优适应度值
    ffit(t) = min(fit_mem);
end
ngbest = find(fit_mem == min(fit_mem));
g_best = mem(ngbest(1), :)
% 绘制最优结果的迭代曲线
figure(1)
plot(log10(ffit), 'm');

%  子函数：初始化乌鸦位置
function  [x, l, u] = init(N, pd)
l = -10;  u = 10;  %  搜索空间下界与上界
%  生成初始解（乌鸦位置）
for i =1: N
    for j =1: pd
        %  初始化乌鸦在搜索空间中的位置
        x(i, j) = l - (l - u)*rand;
    end
end
end

%  子函数：适应度评估
function  ft = Cfitness(xn, N, pd)
for i =1: N
    ft(i) = sum(xn(i, :).^2);  %  球函数（平方和函数）
end
end
