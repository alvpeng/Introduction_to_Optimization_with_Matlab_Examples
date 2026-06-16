% A.8 (P3.15) 更完整的食谱问题；对偶单纯形法
%  不显示表格的单纯形法
%  食谱问题 1：对偶问题
%  问题定义
N = 4;  %  变量数量
L = 4;  %  约束条件数量
W = N + (2*L);  %  总变量数（原变量 + 新增变量）
Oc = [2; 8; 1.5; 11];
OA = [4, 7, 1.3, 8; 1, 9, 0.1, 7; 15, 0.4, 22.6, 0; 90, 106, 97, 130];
Ob = [-10; 8; 10; 300];  %  注意负号
c = zeros(W, 1);
A = zeros(L, W);
p = zeros(L, 1);
%  添加L个松弛变量和L个剩余变量
M = -1000;  %  大负M值（可修改）
c(1: N) = Ob;
c(N + L + 1: end) = M*ones(L, 1);  %  对偶问题目标函数系数
A(:, 1:N) = OA';  %  对偶问题约束系数
A(:, N + 1: N + L) = [-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
A(:, N + L + 1: end) = eye(L);
b = Oc;  %  对偶问题约束右端项
%  算法初始化
z = zeros(1, W);
q = 0;
r = A;  %  待迭代操作的矩阵
ic = 0;  ir = 0;  %  主元位置指针
pv = 0;  %  主元值
ib = zeros(1, L);
ib = [N + L + 1: W];  %  初始基变量索引
%  初始zj行计算
for  nn = 1:L
    p(nn) = c(ib(nn));
end
for nn = 1:W
    aux = 0;
    for  m = 1:L
        aux = aux + p(m)*r(m, nn);
    end
    z(nn) = aux;
end
q = 0;
for m = 1:L
    q = q + p(m)*b(m);
end
%  cj - zj 行
u = c - z';
%  后续（不显示的）单纯形表迭代
nT = 1;  %  表格编号
%  不显示表格的迭代循环
K = 1;  %  循环标志（1=继续，0=终止）
while K == 1
    %  寻找主元
    [mx, ic] = max(u);  %  最大检验数对应列=主元列
    %  避免除法异常
    aux = zeros(1, L);
    vv = 0.001;  %  极小值（防止除以0）
    for j = 1:L
        if b(j) == 0
            b(j) = 0.01;  %  微小扰动（避免0分母）
        end
        if r(j, ic) == 0
            aux(j) = b(j)/vv;  %  赋值大数
        else
            aux(j) = b(j)/r(j, ic);
        end
    end
    %  找到最小非负比值
    [Y, I] = sort(aux);
    fl = 0;
    nn = 1;
    while  fl == 0
        if Y(nn)<0
            nn = nn + 1;
        else
            ir = I(nn);  %  主元行
            fl = 1;
        end
    end
    pv = r(ir, ic);  %  主元值
    ib(ir) = ic;  %  更新基变量索引
    % 避免主元为0
    if pv ==0
        pv = vv;
    end
    %  更新核心矩阵，主元行归一化
    r(ir, :) = r(ir, :)/pv;
    b(ir) = b(ir)/pv;
    %  更新其余行
    for  nn = 1:L
        if nn ~= ir
            op = r(nn, ic);  %  非主元行在主元列的元素
            vaux = op*r(ir, :);
            raux = r(nn, :);
            r(nn, :) = raux - vaux;  %  行变换更新
            b(nn) = b(nn) -(op*b(ir));
        end
    end
    %  更新zj行
    for  nn = 1:L
        p(nn) = c(ib(nn));
    end
    for nn =1:W
        aux = 0;
        for  m = 1:L
            aux = aux + p(m)*r(m, nn);
        end
        z(nn) = aux;
    end
    q = 0;
    for m = 1:L
        q = q + p(m)*b(m);
    end
    %  更新检验数行
    u = c - z';
    nT = nT + 1
    %  判断是否终止迭代
    [aux, I] = max(u);
    if aux <=0
        K = 0;  %  退出循环
    end
    %  防止循环迭代
    if nT > 20
        K = 0;  %  退出循环
    end
    ib
end
%  输出结果
ib
b
q
