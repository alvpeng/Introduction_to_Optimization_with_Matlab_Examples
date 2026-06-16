% A.14(P12.2) 磷虾群算法简易实现
%  磷虾群算法简易实现
format  long
NR = 10;  %  运行次数
NK = 25;  %  磷虾个体数量
MI  = 50;  %  迭代次数
C_flag = 1;  %  交叉操作标志 [启用=1]
%  变量边界
UB = 10*ones(1, 10);
LB = -10*ones(1, 10);
NP = length(LB);  %  参数维度
Dt = mean(abs(UB - LB))/2;  %  尺度因子
F = zeros(NP, NK);  D = zeros(1, NK);  N = zeros(NP, NK);
Vf = 0.02;
Dmax = 0.005;
Nmax = 0.01;
Sr = 0;
%  主循环
for  nr = 1: NR
    %  初始化磷虾位置
    for  z1 = 1: NP
        X(z1, :) = LB(z1) + (UB(z1) - LB(z1)).*rand(1, NK);
    end
    for  z2 = 1: NK
        K(z2) = cost(X(:, z2));
    end
    Kib = K;
    Xib = X;
    [Kgb(1, nr), A] = min(K);
    Xgb(:, 1, nr) = X(:, A);
    for  j = 1: MI
        %  虚拟食物位置计算
        for  ll = 1: NP
            Sf(ll) =(sum(X(ll, :)./K));
        end
        Xf(:, j) = Sf./(sum(1./K));  %  食物位置
        %  边界检查与修正
        Xf(:, j) = findlimits(Xf(:, j)', LB, UB, Xgb(:, j, nr)');
        Kf(j) = cost(Xf(:, j));
        if 2 <= j
            if Kf(j - 1) < Kf(j)
                Xf(:, j) = Xf(:, j - 1);
                Kf(j) = Kf(j - 1);
            end
        end
        Kw_Kgb = max(K) - Kgb(j, nr);
        w =(0.1 + 0.8*(1 - j/MI));
        for  i = 1: NK
            %  距离计算
            Rf = Xf(:, j) - X(:, i);
            Rgb = Xgb(:, j, nr) - X(:, i);
            for  ii = 1: NK
                RR(:, ii) = X(:, ii) - X(:, i);
            end
            R = sqrt(sum(RR.*RR));
            %  运动计算
            %  全局最优磷虾的诱导作用
            if Kgb(j, nr) < K(i)
                alpha_b = -2*(1 + rand*(j/MI))*(Kgb(j, nr) - ...
                    K(i))/Kw_Kgb/sqrt(sum(Rgb.*Rgb))*Rgb;
            else
                alpha_b = 0;
            end
            %  邻域磷虾的诱导作用
            nn = 0;
            ds = mean(R)/5;
            alpha_n = 0;
            for  n = 1: NK
                if  R < ds  &&  n ~= i
                    nn = nn + 1;
                    if  nn <= 4  &&  K(i) ~= K(n)
                        alpha_n = alpha_n -(K(n) - K(i))/Kw_Kgb/R(n)*RR(:, n);
                    end;
                end;
            end;
            %  诱导运动更新
            N(:, i) = w*N(:, i) + Nmax*(alpha_b + alpha_n);
            %  觅食行为
            %  食物吸引作用
            if Kf(j) < K(i)
                Beta_f = -2*(1 - j/MI)*(Kf(j) - K(i))/Kw_Kgb/sqrt(sum(Rf.*Rf))*Rf;
            else
                Beta_f = 0;
            end
            %  个体最优位置吸引作用
            Rib = Xib(:, i) - X(:, i);
            if Kib(i) < K(i)
                Beta_b = -(Kib(i) - K(i))/Kw_Kgb/sqrt(sum(Rib.*Rib))*Rib;
            else
                Beta_b = 0;
            end
            %  觅食运动更新
            F(:, i) = w*F(:, i) + Vf*(Beta_b + Beta_f);
            %  扩散行为
            D = Dmax*(1 - j/MI)*floor(rand +(K(i) - ...
                Kgb(j, nr))/Kw_Kgb)*(2*rand(NP, 1) - ones(NP, 1));
            %  总位移计算
            DX = Dt*(N(:, i) + F(:, i));
            %  交叉操作
            if C_flag == 1
                C_rate = 0.8 + 0.2*(K(i) - Kgb(j, nr))/Kw_Kgb;
                Cr = rand(NP, 1) < C_rate;
                %  随机选择用于交叉的磷虾个体
                NK4Cr = round(NK*rand + 0.5);
                %  交叉策略执行
                X(:, i) = X(:, NK4Cr).*(1 - Cr) + X(:, i).*Cr;
            end
            %  位置更新
            X(:, i) = X(:, i) + DX;
            %  边界检查与修正
            X(:, i) = findlimits(X(:, i)', LB, UB, Xgb(:, j, nr)');
            K(i) = cost(X(:, i));
            if K(i) < Kib(i)
                Kib(i) = K(i);
                Xib(:, i) = X(:, i);
            end
        end
        %  更新全局最优
        [Kgb(j + 1, nr), A] = min(K);
        if  Kgb(j + 1, nr) < Kgb(j, nr)
            Xgb(:, j + 1, nr) = X(:, A);
        else
            Kgb(j + 1, nr) = Kgb(j, nr);
            Xgb(:, j + 1, nr) = Xgb(:, j, nr);
        end
    end
end
%  后处理
[Best, Ron_No] = min(Kgb(end, :))
Xgb(:, end, Ron_No)
%  最优值收敛曲线
figure(1)
plot(1: MI + 1, Kgb(:, Ron_No), 'm');
xlabel('迭代次数');  ylabel('最优适应度值');

%  目标函数定义
function f = cost(X)
%  Ackley函数
n = 10;
a = 20;
b = 0.2;
c = 2*pi;
s1 = 0;
s2 = 0;
for  i = 1: n
    s1 = s1 + X(i)^2;
    s2 = s2 + cos(c*X(i));
end
f = -a*exp(-b*sqrt(1/n*s1)) - exp(1/n*s2) + a + exp(1);
end

%  边界约束处理函数
function [ns] = findlimits(ns, Lb, Ub, best)
%  进化边界约束处理策略
n = size(ns, 1);
for  i = 1: n
    ns_tmp = ns(i, :);
    I = ns_tmp < Lb;
    J = ns_tmp > Ub;
    A = rand;
    ns_tmp(I) = A*Lb(I) +(1 - A)*best(I);
    B = rand;
    ns_tmp(J) = B*Ub(J) +(1 - B)*best(J);
    ns(i, :) = ns_tmp;
end
end
