% 例程 12.1  人工蜂群算法（ABC）示例
%  调用一个辅助函数
%  算法参数
SN = 10;  %  种群规模
niter = 50;  %  迭代次数
flim = 3;  %  最大失败次数
%  目标函数边界
l = [-1.2, -1.2];  %  下限
u = [1.2, 1.2];  %  上限
%  向量初始化
D = length(u);  %  问题空间维度（待优化参数个数）
OFV = zeros(SN, 1);  %  目标函数值数组
fit = zeros(SN, 1);  %  适应度值数组
trial = zeros(SN, 1);  %  失败次数数组
%  生成初始种群（随机初始化食物源位置）
PP = repmat(l, SN, 1) + repmat((u - l), SN, 1).*rand(SN, D);
%  绘制目标函数曲面及初始种群
[vx1, vx2] = meshgrid(-1.2: 0.02: 1.2, -1.2: 0.02: 1.2);
y = 0.2 + (vx1.^2) + (vx2.^2) - (0.1*cos(6*pi*vx1)) - (0.1*cos(6*pi*vx2));
figure(1)
colormap('cool')
mesh(vx1, vx2, y);  hold on;
plot(PP(:, 1), PP(:, 2), 'r*');
%  评估初始种群的目标函数值和适应度值
for i = 1: SN
    x1 = PP(i, 1);
    x2 = PP(i, 2);
    OFV(i) = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2));
    aux = OFV(i);
    if aux >= 0
        fit(i) = 1/(1 + aux);
    else
        fit(i) = 1 + abs(aux);
    end
end
%  记录初始最优解及其对应的目标函数值
[best_obj, ix] = min(OFV);
best_loc = PP(ix, :);
%  算法主迭代过程
for  g = 1: niter
    % 引领蜂阶段，调用genNewsolution函数生成新解
    for jj = 1:SN
        [trial, PP, fit, OFV] = genNewsolution(l, u, SN, jj, PP, fit, trial, OFV, D);
    end
    %  跟随蜂阶段，计算每个食物源被选择的概率（缩放至[0.1,1]区间）
    pblty = 0.9*(fit/max(fit)) + 0.1;
    mm = 0;
    nn = 1;
    while  (mm < SN)
        if (rand(1) < pblty(nn))
            [trial, PP, fit, OFV] = genNewsolution(l, u, SN, nn, PP, fit, trial, OFV, D);
            mm = mm + 1;
        end
        nn = 1 + mod(nn, SN);
    end
    [best_obj, ix] = min([OFV; best_obj]);
    combined_sol = [PP; best_loc];
    best_loc = combined_sol(ix, :);
    %  侦察蜂阶段
    [val, ix] = max(trial);
    if (val > flim)
        trial(ix) = 0;
        %  随机生成新的食物源位置
        PP(ix, :) = l + (u - l).*rand(1, D);
        %  评估新食物源的目标函数值和适应度
        x1 = PP(ix, 1);
        x2 = PP(ix, 2);
        OFV(ix) = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2));
        aux = OFV(ix);
        if aux >= 0
            fit(ix) = 1/(1 + aux);
        else
            fit(ix) = 1 + abs(aux);
        end
    end
end
[best_fitness, ix] = min([OFV; best_obj]);
combined_sol = [PP; best_loc];
best_loc = combined_sol(ix, :);
best_loc
best_fitness
figure(2)
contour(vx1, vx2, y);
hold on;
plot(PP(:, 1), PP(:, 2), 'ro');
plot(best_loc (1), best_loc(2), 'k*', 'MarkerSize', 14);
%  辅助函数：生成新解（核心搜索逻辑）
function [trial, PP, fit, OFV] = genNewsolution (l, u, SN, n, PP, fit, trial, OFV, D)
%  随机选择待更新的维度
k = 1 + round ((D - 1)*rand(1));
%  随机选择一个邻域解（不能是当前解）
q = 1 + round((SN - 1)*rand(1));
while  (q == n)
    q = 1 + round((SN - 1)*rand (1));
end
Xnew = PP(n, :);  %  初始化新解为当前解
%  生成[-1, 1]的随机数
Phi = -1 + (2*rand(1));
%  按ABC公式更新选定维度的数值
Xnew(k) = PP(n, k) + Phi*(PP(n, k) - PP(q, k));
%  边界约束（确保新解在合法范围内）
Xnew(k) = min(Xnew(k), u(k));
Xnew(k) = max(Xnew(k), l(k));
%  计算新解的目标函数值和适应度
x1 = Xnew (1);  x2= Xnew (2);
obv = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2));
if obv >= 0
    fitNewsol = 1/(1 + obv);
else
    fitNewsol = 1 + abs(obv);
end
%  贪婪选择：新解更优则更新，否则增加失败次数
if (fitNewsol > fit(n))
    PP(n, :) = Xnew;
    fit(n) = fitNewsol;
    OFV(n) = obv;
    trial(n) = 0;
else
    trial(n) = trial(n) + 1;
end
end
