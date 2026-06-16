% 例程 13.2  和声搜索算法示例
Nvar = 2;  %  变量数量
Nq = 6;  %  不等式约束数量
Ne = 0;  %  等式约束数量
MaxItr = 1000;  %  最大迭代次数
HMS = 8;  %  和声记忆库大小
HMCR = 0.9;  %  和声记忆库保留概率 0 < HMCR < 1
PARmin = 0.4;  %  最小音调微调率
PARmax = 0.9;  %  最大音调微调率
bwmin = 0.01;  %  最小带宽
bwmax = 0.5;  %  最大带宽
PVB = [1.0, 4.0; 1.0, 4.0];  %  变量取值范围（每行对应一个变量的上下界）
%  为矩阵预分配内存
HM = zeros(HMS, Nvar);  %  和声记忆库矩阵
NCHV = zeros(1, Nvar);
BestGen = zeros(1, Nvar);
Hfitness = zeros(1, HMS);
BW = zeros(1, Nvar);
gx = zeros(1, Nq);
BestObjVal = zeros(1, MaxItr/100);
%  初始化
%  为和声记忆库随机生成初始值
for i =1: HMS
    for j = 1:Nvar
        HM(i, j) = randval(PVB(j, 1), PVB(j, 2));
    end
    Hfitness(i) = HObjVal(HM(i, :), Nq);
end
%  目标函数可视化
[vxp, vyp] = meshgrid(linspace(1.0, 4.0, 120));
for i = 1:120
    for j = 1:120
        vzp(i, j) = (((vxp(i, j)^2) + vyp(i, j) - 11)^2) + ((vxp(i, j) + (vyp(i, j)^2) - 7)^2);
    end
end
figure(1)
contour(vxp, vyp, vzp, 30);
hold  on;
%  绘制约束区域
for  x = 1.5: 0.005: 2.5
    for  y = 1: 0.01: 4
        gz1 = 4.84 - (x - 0.005)^2 - (y - 2.5)^2;
        gz2 = x^2 + (y - 2.5)^2 - 4.84;
        if ((gz1 > 0) & (gz2 > 0))
            plot(x, y, 'g.');
        end
    end
end
%  绘制理论最优解位置（无约束时的最小值点 (3,2)）
plot(3, 2, 'mx', 'MarkerSize', 14);
%主循环
Iter = 0;
ncent = 0;
CentCount = 0;
while (Iter < MaxItr)
    PAR = (PARmax - PARmin)/(MaxItr)*Iter + PARmin;
    coef = log(bwmin/bwmax)/MaxItr;
    for  pp = 1: Nvar
        BW(pp) = bwmax*exp(coef*Iter);
    end;
    %  即兴生成新和声向量
    for i = 1:Nvar
        ran = rand(1);
        if (ran < HMCR)  %  从和声记忆库取值
            index = randint(1, HMS);
            NCHV(i) = HM(index, i);
            pvbRan = rand(1);
            if (pvbRan < PAR)  %  执行音调微调
                pvbRan1 = rand(1);
                result = NCHV(i);
                if (pvbRan1 < 0.5)
                    result = result + rand(1)*BW(i);
                    if (result < PVB(i, 2))
                        NCHV(i) = result;
                    end;
                else
                    result = result - rand(1)*BW(i);
                    if (result > PVB(i, 1))
                        NCHV(i) = result;
                    end
                end
            end
        else
            %  随机生成新值（探索新区域）
            NCHV(i) = randval(PVB(i, 1), PVB(i, 2));
        end
    end
    NewFit = HObjVal(NCHV, Nq);
    %  更新和声记忆库
    if (Iter == 0)
        BestFit = Hfitness(1);
        for  i = 1:HMS
            if (Hfitness(i) < BestFit)
                BestFit = Hfitness(i);
                BestIndex = i;
            end;
        end;
        BestObjVal(1)= BestFit;
        WorstFit = Hfitness(1);
        for  i = 1: HMS
            if (Hfitness(i) > WorstFit)
                WorstFit = Hfitness(i);
                WorstIndex = i;
            end
        end
    end
    if (NewFit < WorstFit)
        if (NewFit < BestFit)
            HM(WorstIndex, :) = NCHV;
            BestGen = NCHV;
            Hfitness(WorstIndex) = NewFit;
            BestIndex = WorstIndex;
        else
            HM(WorstIndex, :) = NCHV;
            Hfitness(WorstIndex) = NewFit;
        end;
        WorstFit = Hfitness(1);
        WorstIndex = 1;
        for  i = 1: HMS
            if (Hfitness(i) > WorstFit)
                WorstFit = Hfitness(i);
                WorstIndex = i;
            end
        end
    end
    Iter = Iter +1;
    [BestFitness, aix] = min(Hfitness);
    %  每100次迭代绘制一次最优解
    ncent = ncent + 1;
    if  ncent == 100
        ncent = 0;
        CentCount = CentCount + 1;
        BestObjVal(1 + CentCount) = BestFitness;
        plot(HM(aix, :), 'ro');
    end
end  %  主循环结束
% 绘制最优目标函数值进化曲线
figure(2)
aux = BestObjVal(:);
nc = 0:(MaxItr/100);
plot(nc, aux, 'm');
xlabel('迭代次数');  ylabel('最优函数值 f(x,y)');

%  函数：生成指定区间内的随机数
function val1 = randval(Maxv, Minv)
val1 = rand(1)*(Maxv - Minv) + Minv;
end

%  函数：生成指定区间内的随机整数
function val2 = randint(Maxv, Minv)
val2 = round(rand(1)*(Maxv - Minv) + Minv);
end

%  函数：计算含惩罚项的目标函数值（适应度）
function S = HObjVal(sol, Nq)
%  F(x) = f(x) + penalty:
S = ((sol(1)^2 + sol(2) - 11)^2) + ((sol(1) + sol(2)^2 - 7)^2) + Heg(sol, Nq);
end

%  函数：计算约束违反惩罚值
function  Q = Heg(sol, Nq)
%  约束条件 g(x) > 0
gx(1) = 4.84 - (sol(1) - 0.005)^2 - (sol(2) - 2.5)^2;
gx(2) = sol(1)^2+(sol(2) - 2.5)^2 - 4.84;
gx(3) = 6 - sol(1);
gx(4) = sol(1);
gx(5) = 6 - sol(2);
gx(6) = sol(2);
%  静态惩罚函数处理约束
Q = 0;
for i =1: Nq
    if (gx(i) < 0)
        Q = Q - 1000 * gx(i);
    end
end
end