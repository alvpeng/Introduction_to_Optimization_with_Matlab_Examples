% 例程 12.4  蝙蝠算法示例
Np = 20;  %  种群规模，通常取20至40
it_max = 500;  %  最大迭代次数
A = 1;  %  初始响度（固定值或递减）
%  初始脉冲发射率（固定值或递减）
r0 = 1;
alpha = 0.97;  %  衰减系数α
gamma = 0.1;  %  系数γ
%  频率范围
Freq_min = 0;  %  最小频率
Freq_max = 2;  %  最大频率
iter = 0;  %  迭代计数器
d = 10;  % 搜索空间维度
%  初始化所有数组
Freq = zeros(Np, 1);  %  频率调节数组
v = zeros(Np, d);  %  等效速度或增量数组
Lb = -5*ones(1, d);  %  变量下界
Ub = 5*ones(1, d);  %  变量上界
%  追踪迭代过程中的最优目标函数值（fmin）
vfmin = zeros(1, it_max/50);
nvfx = 1;  %  vfmin的索引值
%  初始化种群/解
for i = 1:Np,
    Sol(i, :) = Lb + (Ub - Lb).*rand(1, d);
    Fitness(i) = Fun(Sol(i, :));
end;
%  找到初始种群中的最优解
[fmin, ix] = min(Fitness);
best = Sol(ix, :);
%  主循环
while  (iter < it_max)
    %  调整响度（A）和脉冲发射率（r）
    r = r0*(1 - exp(-gamma*iter));
    A = alpha*A;
    %  遍历所有蝙蝠/解
    for i = 1: Np
        Freq (i)= Freq_min + (Freq_max - Freq_min)*rand;
        v(i, :) = v(i, :) + (Sol(i, :) - best)*Freq(i);
        S(i, :) = Sol(i, :) + v(i, :);
        %  随机游走切换条件
        if rand < r
            S(i, :) = best + 0.1*randn(1, d)*A;
        end
        %  边界约束处理
        S(i, :) = simplebounds(S(i, :), Lb, Ub);
        %  评估新解的适应度
        Fnew = Fun(S(i, :));
        %  若新解更优 或 响度未过低，则接受新解
        if ((Fnew <= Fitness(i))&(rand > A)), Sol(i, :) = S(i, :);
            Fitness(i)= Fnew ;
        end
        %   更新当前全局最优解
        if Fnew <= fmin
            best = S(i, :);
            fmin = Fnew;
        end
    end
    iter = iter + 1;  %  更新迭代计数器
    %  每50次迭代保存一次最优结果
    if ~ mod(iter, 50),
        vfmin(nvfx) = fmin;
        nvfx = nvfx + 1;
    end
end  %  主循环结束
%  输出最优解
disp('最终结果-------------');
fmin
best
figure(1)
nn = 1:(it_max/50);
plot(nn*50, log10(vfmin(nn)), 'm');
xlabel('迭代次数');  ylabel('log10(fmin)');
%  子函数：边界约束函数
function s = simplebounds(s, Lb, Ub)
%  应用下界约束
ns_tmp = s;
I = ns_tmp < Lb;
ns_tmp(I) = Lb(I);
%  应用上界约束
J = ns_tmp > Ub;
ns_tmp(J) = Ub(J);
%  更新约束后的位置
s = ns_tmp;
end
%  子函数：目标函数
function  z= Fun(x)
%  最优解为fmin = 0，对应位置(2, 2, ..., 2)
z = sum((x - 2).^2);
end
