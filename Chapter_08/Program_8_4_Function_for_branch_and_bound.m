% 例程 8.4  分支定界法函数
%  函数功能：生成两个分支并分析其求解结果
function [Fgl, Fgu, nPV, nPX] = f2bb(PV, PX, L, J)
global  f  A  B  Aeq  Beq  lb1  ub1  lb2  ub2;
Fgu = 1;  Fgl = 1;  %  标记初始状态：节点未被剪枝
K = 1 + ((J - 1)*2);  %  分支对的横向索引（用于定位子节点）
nPV = PV;
nPX = PX;
%  初始化子节点状态为“已剪枝”（默认值）
nPV(L+1, K) = -1;
nPX(L+1, K) = -1;
nPV(L+1, K + 1) = -1;
nPX(L+1, K + 1) = -1;
%  从输入的分支节点中提取信息
var_index = PX(L, J);
var_val = PV(L, J);
ub1(var_index) = var_val;
lb2(var_index) = var_val + 1;
options = optimoptions('linprog', 'Display', 'none');
%  求解左分支（下界分支）
[X1, v1, flg1] = linprog(f, A, B, Aeq, Beq, lb1, ub1, options);
%  求解右分支（上界分支）
[X2, v2, flg2] = linprog(f, A, B, Aeq, Beq, lb2, ub2, options);
if (flg1 == 1)  %  左分支存在可行解
    %  检查左分支解是否为全整数解
    [flg_intg1, V1_val, V1_idx] = fbab_int(X1);
    if (flg_intg1 == 1)
        disp('找到整数解-----')
        X1
        v1
        Fgl = 0;  %  标记该节点已剪枝（无需继续分支）
    else
        disp('非整数解-----')
        X1
        %  记录新的左分支节点信息（供下一层分支使用）
        nPV(L+1, K) = V1_val;
        nPX(L+1, K) = V1_idx;
    end
else
    Fgl = 0;  %  标记该节点已剪枝（无可行解）
    disp('$$ >>  左分支：未找到可行解')
end
if (flg2 == 1)  %  右分支存在可行解
    %  检查右分支解是否为全整数解
    [flg_intg2, V2_val, V2_idx] = fbab_int(X2);
    if (flg_intg2 == 1)
        disp('找到整数解 -----')
        X2
        v2
        Fgu = 0;  %  标记该节点已剪枝（无需继续分支）
    else
        disp('非整数解 -----')
        X2
        %  记录新的右分支节点信息（供下一层分支使用）
        nPV(L+1, K + 1) = V2_val;
        nPX(L+1, K + 1) = V2_idx;
    end
else
    Fgu = 0;  %  标记该节点已剪枝（无可行解）
    disp('$$ >>  右分支：未找到可行解')
end
return
