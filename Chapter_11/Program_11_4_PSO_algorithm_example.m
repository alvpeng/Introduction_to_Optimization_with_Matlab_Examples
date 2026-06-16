% 例程 11.4  粒子群优化算法示例
%  简易示例
Np = 50;  %  粒子数量
Niter = 40;  %  最大迭代次数
C1 = 2.03 ;  %  认知系数
C2 = 2.03 ;  %社会系数
W = 0.9;  %  初始惯性权重
minW = 0.4;  %  最终惯性权重
alpha = ((W - minW)/Niter);  %  用于监控惯性权重的衰减
Lb = -5;  %  搜索空间下界
Ub = 5;  %  搜索空间上界
init_Vel = 0;  %  粒子初始速度
var_W = W;  %  用于绘图
%  生成粒子群
Aux.pos = [];
Aux.val = [];
Aux.velocity = [];
prt = repmat(Aux, Np, 1);
%  为Np个粒子分配存储空间
%  粒子初始化
for i = 1:Np
    %  在搜索空间内随机生成粒子的二维位置
    prt(i).pos = Lb + (Ub - Lb)*rand(1, 2);
    %  计算粒子当前位置的目标函数值 (调用Fitness函数)
    prt(i).val = Fitness(prt(i).pos);
    %  设置粒子初始速度
    prt(i).velocity = init_Vel.*ones(1, 2);
end
%  保存每个粒子的个体最优值，初始迭代时个体最优即为自身
bprt = prt;
%  确定所有个体最优粒子中的全局最优
[aux, idx] = min([bprt.val]);
%  保存全局最优解
gprt = prt(idx);
%  为主循环做准备
%  目标函数值的平均值
avrg = mean([prt.val]);
best = gprt.val;  %  最优目标函数值
iter = 1;  %  迭代次数
W_vector = W;
%  主循环
while  iter < Niter
    for i = 1: Np
        %  更新速度
        prt(i).velocity = W.*prt(i).velocity ...
            + C1.*rand(1, 2).*(bprt(i).pos - prt(i).pos) ...
            + C2.*rand(1, 2).*(gprt(iter).pos - prt(i).pos);
        %  更新位置
        prt(i).pos = prt(i).pos + prt(i).velocity;
        %  更新后施加边界约束：
        %  超出上界时
        crup = prt(i).pos >= Ub;
        prt(i).pos(crup) = Ub;
        %  超出下界时
        crdn = prt(i).pos <= Lb;
        prt(i).pos(crdn) = Lb;
        %  计算粒子当前位置的目标函数值
        prt(i).val = Fitness(prt(i).pos);
        %  优化目标为求最小值
        if prt(i).val < bprt(i).val
            bprt(i) = prt(i);
        end;
    end;
    if W > minW
        W = W - alpha ;
    end;
    iter = iter + 1;
    [aux, idx] = min([bprt.val]);
    gprt(iter) = bprt(idx);
    best(iter) = gprt(iter).val;
    %  avrg(iter) = mean([prt.val])
    W_vector = [W_vector, W];
end
%  最优位置
gprt(end).pos
%  最优值
best(end)
%  结果可视化
figure(1)
[X, Y] = meshgrid(Lb: 0.1: Ub, Lb: 0.1: Ub);
Z = X.^2 + Y.^2 + (25*(sin(X).^2 + sin(Y).^2));
contour(X, Y, Z, 20);
hold  on;
for i = 1: Np
    plot(prt(i).pos(1), prt(i).pos(2), 'or');
end
xlabel('X');  ylabel('Y');
figure(2)
subplot(1, 2, 1)
plot(1: Niter, best, 'r');
ylabel('最优适应度值');  xlabel ('迭代次数');
subplot(1, 2, 2)
plot(1: Niter, W_vector, 'm');
ylabel('惯性权重 W');  xlabel('迭代次数')
%  适应度函数（目标函数）
function  [v] = Fitness(S)
v = S(1).^2 + S(2).^2 + (25*(sin(S(1)).^2 + sin(S(2)).^2));
end
