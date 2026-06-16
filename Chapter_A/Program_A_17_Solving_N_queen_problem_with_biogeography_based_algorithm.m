% A.17 (P13.6) 基于生物地理学优化算法求解N皇后问题
%  基于生物地理学的优化算法示例
%  求解N皇后问题
clear all;
%  皇后数量（可修改）
nQueen = 12;
nVar = nQueen;  %  决策变量数
VarSize = [1, nVar];  %  决策变量矩阵尺寸
VarMin = 0;  %  变量下界
VarMax = 1;  %  变量上界
%%  BBO算法参数
MaxIt = 50;  %  最大迭代次数
nHb = 100;  %  栖息地数量（种群规模）
KeepRate = 0.2;  %  保留率
%  保留的栖息地数量
nKeep = round(KeepRate*nHb);
nNew = nHb - nKeep;  %  新生成的栖息地数量
%  迁移率参数
mu = linspace(1, 0, nHb);  %  迁出率
lambda = 1 - mu;  %  迁入率
alpha = 0.9;
pMutation = 0.4;
sigma = 0.02*(VarMax - VarMin);
%  定义空栖息地结构体
habitat.Position = [];
habitat.Cost = [];
habitat.Sol = [];
%  创建栖息地数组
Hpop = repmat(habitat, nHb, 1);
%  初始化栖息地
for i = 1: nHb
    aux = (VarMax - VarMin)*rand(1, nVar) + VarMin;
    Hpop(i).Position = aux;
    [Hpop(i).Cost, Hpop(i).Sol] = CostF(Hpop(i).Position);
end;
%  种群排序
[aux, SortOrder] = sort([Hpop.Cost]);
Hpop = Hpop(SortOrder);
%  最优解初始化
Final = Hpop(1);
%  记录迭代过程中的最优代价
CostValue = zeros(MaxIt, 1);
%%  BBO算法主循环
for  it = 1: MaxIt
    newHpop = Hpop;
    for  i = 1: nHb
        for  k = 1: nVar
            %  迁移操作
            if rand <= lambda(i)
                %  计算迁出概率
                EP = mu;
                EP(i) = 0;
                EP = EP/sum(EP);
                %  轮盘赌选择迁出源栖息地
                j = RWS(EP);
                %  执行迁移
                newHpop(i).Position(k) = Hpop(i) .Position(k) ...
                    + alpha*(Hpop(j).Position(k) - Hpop(i).Position(k));
            end
            %  变异操作
            if rand <= pMutation
                newHpop(i).Position(k) = newHpop(i).Position(k) + sigma*randn;
            end;
        end;
        %  应用变量边界约束
        newHpop(i).Position = max(newHpop(i).Position, VarMin);
        newHpop(i).Position = min(newHpop(i).Position, VarMax);
        %  代价评估
        [newHpop(i).Cost newHpop(i).Sol] = CostF(newHpop(i).Position);
    end;
    %  新种群排序
    [aux, SortOrder] = sort([newHpop.Cost]);
    newHpop = newHpop(SortOrder);
    %  选择下一代种群
    Hpop = [Hpop(1: nKeep), newHpop(1: nNew)];
    %  种群重新排序
    [aux, SortOrder] = sort([Hpop.Cost]);
    Hpop = Hpop(SortOrder);
    %  更新全局最优解
    Final = Hpop(1);
    %  记录本轮最优代价
    CostValue(it) = Final.Cost;
    %  绘制当前最优解
    figure(1);
    ShowRes(Final.Sol);
    if CostValue(it) == 0
        break;
    end
end
%%  最优结果进化曲线
figure(2);
plot(CostValue, 'r-');
xlabel('迭代次数');  ylabel('代价值');
%  轮盘赌选择函数
function i = RWS(P)
r = rand;
C = cumsum(P);
ix = find(r <= C);
i = ix(1);
end

%  结果可视化函数
function ShowRes(sol)
X = sol.X -0.5;
Y = sol.Y - 0.5;
Hit = sol.Hit;
z = sol.z;
n = prod(size(X));
for  i = 1:n - 1
    for  j = i + 1: n
        if Hit(i, j) == 1
            plot([X(i), X(j)], [Y(i), Y(j)], 'b:', 'LineWidth', 2);
            hold on;
        end
    end
end

plot(X, Y, 'k^', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
strTitle = [num2str(n), '-皇后问题'];
if z == 0
    title([strTitle, '无冲突']);
elseif  z == 1
    title([strTitle, '仅1处冲突']);
else
    title([strTitle, num2str(z), '处冲突']);
end;
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
grid  on;
axis square;
set(gca, 'XTick ',0:n);  set(gca, 'YTick', 0:n);
xlim([0, n]);  ylim([0, n]);
hold off;
end

%  代价函数（计算皇后冲突数）
function  [z, sol] = CostF(s)
n = prod(size(s));
[aux, X] = sort(s);
Y = 1: n;
Hit = zeros(n, n);
z = 0;
for  i = 1:n - 1
    for  j = i + 1: n
        if abs(X(i) - X(j)) == abs(Y(i) - Y(j))
            Hit(i, j) = 1;
            Hit(j, i) = 1;
            z = z + 1;
        end
    end
end
sol.X = X;
sol.Y = Y;
sol.Hit = Hit;
sol.z = z;
end
