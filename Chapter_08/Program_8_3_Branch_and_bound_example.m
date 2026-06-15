% 例程 8.3  分支定界法示例
%  求解由整数构成的最小值解
%  变量准备-全局变量
global  f  A  B  Aeq  Beq
%  分支节点（主元）
Pval = zeros(6, 12);
Pix = zeros(6, 12);
nPval = zeros(6, 12);
nPix = zeros(6, 12);
%  初始化
niter = 1;
flg_stop = 0;
%  待求解问题 
%  需最小化的目标函数（Winston 教材例题）
f = [-8; -5];
%  约束条件
A = [1, 1; 9, 5];
B = [6; 45];
Aeq = [];
Beq = [];
%  线性规划边界
global  lb1  ub1  lb2  ub2;
nvar = 2;
lb = zeros(nvar, 1);
ub = (10000)*ones(nvar, 1);
lb1 = lb;
lb2 = lb;
ub1 = ub;
ub2 = ub;
%  首次求解线性规划
flag_intg = 1;
options = optimoptions('linprog', 'Display', 'none');
[X, v, flg] = linprog(f, A, B, Aeq, Beq, lb, ub, options);
%  判断是否找到可行解
if (flg == 1)
disp('初始线性规划解存在：');
X
v
else
disp('无初始线性规划解');
return;
end;
%  检查是否存在非整数变量
%  (flag_intg = 1 表示所有变量均为整数)
[flag_intg, var_val, var_index] = fbab_int(X);
%  是否从初始解就得到整数最优解
if (flag_intg == 1)
disp('初始解即为优良整数解');
X
v
return;
end;
%  继续执行分支定界法
disp(' ')
disp('层级 a) ++++++++++++++++++++++ ')
Fla = 0;
Fua = 0;
L = 1; J = 1;  %  第一层，最左侧分支节点
Pval(L, J) = var_val;  Pix(L, J) = var_index; % 记录第一个分支节点
%  生成两个分支
[Fla, Fua, nPval, nPix] = f2bb(Pval, Pix, L, J);
Pval = nPval ; Pix = nPix ;  %  更新分支节点矩阵
%  分支层级 b
disp(' ');
disp('层级 b) ++++++++++++++++++++++ ');
Flb1 = 0;  Flb2 = 0;  Fub1 = 0;  Fub2 = 0;
if (Fla == 1)
L = 2;  J = 1;  %  b层左分支
lb2 = lb;
ub2(Pix(1, 1)) = Pval(1, 1);
%  生成两个分支（b层左分支）
[Flb1, Fub1, nPval, nPix] = f2bb(Pval, Pix, L, J);
Pval = nPval; Pix = nPix;  %  更新分支节点矩阵
end;
if (Fua == 1)
L = 2;  J = 2;  %  b层右分支
ub1 = ub;
ub2 = ub;
lb1(Pix(1, 1)) = Pval(1, 1) + 1;
lb2(Pix(1, 1)) = Pval(1, 1) + 1;
%  生成两个分支（b层右分支）
[Flb2, Fub2, nPval, nPix] = f2bb(Pval, Pix, L, J);
Pval = nPval; Pix = nPix;  %  更新分支节点矩阵
end;
%  分支层级 c
disp(' ')
disp('层级 c) ++++++++++++++++++++++ ')
%  c层左分支（包含两个子分支）
if (Flb1 == 1)
L = 3;  J = 1;  %  c层左-左分支
lb1 = lb;  lb2 = lb;  ub2 = ub;
ub2(Pix(2, 1)) = Pval(2, 1);
%  生成两个分支
[Flc1, Fuc1, nPval, nPix] = f2bb(Pval, Pix, L, J);
end;
if (Fub1 == 1)
L = 3; J = 2;  %  c层左-右分支
lb1 = lb;  lb2 = lb;  ub2 = ub;
ub2(Pix(2, 1)) = Pval(2, 1);
%  生成两个分支
[Flc2, Fuc2, nPval, nPix] = f2bb(Pval, Pix, L, J);
end
%  c层右分支（包含两个子分支）
if (Flb2 == 1)
L = 3; J = 3;  %  c层右-左分支
lb1 = lb;  lb2 = lb;  ub2 = ub;
ub2(Pix(2, 2)) = Pval(2, 2);
%  生成两个分支
[Flc3, Fuc3, nPval, nPix] = f2bb(Pval, Pix, L, J);
end;
if (Fub2 == 1)
L = 3; J = 4;  %  c层右-右分支
lb1 = lb;  lb2 = lb;  ub2 = ub;
ub2(Pix(2, 2)) = Pval(2, 2);
%  生成两个分支
[Flc4, Fuc4, nPval, nPix] = f2bb(Pval, Pix, L, J);
end
