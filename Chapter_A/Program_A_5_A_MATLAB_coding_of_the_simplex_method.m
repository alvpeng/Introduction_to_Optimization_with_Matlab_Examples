% A.5 (P3.6) 单纯形法的 MATLAB 实现代码
%  示例 1：
%  最大化目标函数 z = 8x1 + 6x2
%  约束条件：
%  4x1 + x2 ≤ 160
%  2x1 + 3x2 ≤ 240
%  问题定义：（添加2个松弛变量）
c = [8; 6; 0; 0];
A = [4, 1, 1, 0; 2, 3, 0, 1];
b = [160; 240];
%  算法初始化
ib = [3, 4];  %  初始基变量索引（s1, s2）
%  初始zj行
z = zeros(1, 4);
p1 = c(ib(1));
p2 = c(ib(2));
for nn = 1:4
    z(nn) = p1*A(1, nn) + p2*A(2, nn);
end
q = p1*b(1) + p2*b(2);
%  cj - zj行（检验数）
u = c - z';
ic = 0;  ir = 0;  %  主元位置指针（列/行）
pv = 0;  %  主元值
%  基变量名称（单元格数组）
bs = {'x1', 'x2', 's1', 's2'};
%  表格内容存储（单元格数组）
C = cell(4, 1);  R = cell(2, 4);  Z = cell(4, 1);  U = cell(4, 1);  B = cell(2, 1);
%  格式分隔符
P1 = [' | '];  P2 = [' | '];  %  负号专用分隔符
for nn = 1:4
    C{nn} = num2str(c(nn));
    aux = num2str(z(nn), '%2.2f');
    Z{nn} = [aux, P1];
    sg = sign(u(nn));
    aux2 = P1;
    aux1 = num2str(u(nn), '%2.2f');
    if sg < 0
        aux2 = P2;
    end
end
U{nn} = [aux2, aux1];
%  表格核心区域
r = A;  %  初始约束系数
for i = 1:2
    for j = 1:4
        sg = sign(r(i, j));
        aux2 = P1;
        aux1 = num2str(r(i, j), '%2.2f');
        if sg < 0
            aux2 = P2;
        end
    end
    R{i, j} = [aux2, aux1];
end
%  b列格式化
for nn = 1:2
    B{nn} = num2str(b(nn), '%3.1f');
end
Q = num2str(q, '%2.2f');
%  格式排版（空格与分隔线）
O = ['       |  '];
LL = ['-'];
LM = ['_'];
for n = 1:60
    LL = [LL, '-'];
    LM = [LM, '_'];
end
V1 = bs{ib(1)}; V2 = bs{ib(2)};  %  当前基变量名称
W1 = C{ib(1)}; W2 = C{ib(2)};  %  c当前基变量的cj系数
%  输出初始单纯形表
str1 = ['| cj -> |      |', C{1}, 0, C{2}, 0, C{3}, 0, C{4}, 0, ' ', 0];
str2 = ['|   | Basis | x1   | x2   | s1   | s2 | b | '];
str3 = ['|', W1, ' |', V1, ' ', R{1, 1}, R{1, 2}, R{1, 3}, R{1, 4}, P1, B{1}, P1];
str4 = ['|', W2, ' |', V2, ' ', R{2, 1}, R{2, 2}, R{2, 3}, R{2, 4}, P1, B{2}, P1];
str5 = ['|', '  | zj  |', Z{1}, Z{2}, Z{3}, Z{4}, Q, P1];
str6 = ['|', ' | cj - zj', U{1}, U{2}, U{3}, U{4}, P1];
%  显示初始表格
disp(LM);
disp('***  初始单纯形表  *** ');
disp(LL);  disp(str1);
disp(LL);  disp(str2);
disp(LL);  disp(str3);
disp(LL);  disp(str4);
disp(LM); disp(str5);
disp(LL);  disp(str6);
disp(LM);
%  迭代生成后续单纯形表
nT = 1;  %  表格编号
%  表格迭代循环
K = 1;  %  循环标志（1=继续，0=终止）
while K == 1
    %  寻找主元（枢轴元素）
    [mx, ic] = max(u);  %  检验数最大值对应列=主元列
    %  防止除以0
    vv = 0.00001;
    aux = b./(vv + r(:, ic));
    %  找到最小非负比值
    [Y, I] = sort(aux);
    fl = 0;
    nn = 1;
    while fl == 0
        if Y(nn)<0
            nn = nn + 1;
        else
            ir = I(nn);  %  主元行
            fl = 1;
        end
    end
    pv = r(ir, ic);  %  主元值
    ib(ir) = ic;  %  更新基变量索引
    V1 = bs{ib(1)};
    V2 = bs{ib(2)};
    %  更新表格核心区域，主元行归一化
    r(ir, :) = r(ir, :)/pv;
    b(ir) = b(ir)/pv;
    %  更新其余行
    for nn = 1:2
        if nn ~= ir
            op = r(nn, ic);  %  非主元行在主元列的元素
            vaux = op*r(ir, :);
            r(nn, :) = r(nn, :) - vaux;  %  行变换
            b(nn) = b(nn) - (op*b(ir));
        end;
    end
    %  更新zj行
    p1 = c(ib(1));
    p2 = c(ib(2));
    for nn = 1:4
        z(nn) = p1*r(1, nn) + p2*r(2, nn);
        q = p1*b(1) + p2*b(2);
    end  %  更新检验数行
    u = c - z';
    %  重新格式化表格内容
    for nn = 1:4
        aux = num2str(z(nn), '%2.2f');
        Z{nn} = [aux, P1];
        sg = sign(u(nn));
        aux2 = P1;
        aux1 = num2str(u(nn), '%2.2f');
        if sg < 0
            aux2 = P2;
        end
        U{nn} = [aux2, aux1];
    end
    %  核心区域
    for i = 1:2
        for j = 1:4
            sg = sign(r(i, j));
            aux2 = P1;
            aux1 = num2str(r(i,j), '%2.2f');
            if sg < 0
                aux2 = P2;
            end
            R{i,j}=[aux2,aux1];
        end
    end
    %  b列
    for nn = 1:2
        B{nn} = num2str(b(nn), '%3.1f');
    end
    Q = num2str(q, '%2.2f');
    V1 = bs{ib(1)}; V2 = bs{ib(2)};  %  当前基变量
    W1 = C{ib(1)}; W2 = C{ib(2)};  %  当前基变量cj系数
    %  拼接迭代后表格字符串
    str1 = ['| cj -> |  |', C{1}, 0, C{2}, 0, C{3}, 0, C{4}, 0, ' ', 0];
    str2 = ['|   | Basis | x1   | x2   | s1   | s2| b  |'];
    str3 = ['|', W1, ' | ', V1, ' ', R{1, 1}, R{1, 2}, R{1, 3}, R{1, 4}, P1, B{1}, P1];
    str4 = ['|', W2, ' |', V2, ' ', R{2, 1}, R{2, 2}, R{2, 3}, R{2, 4}, P1, B{2}, P1];
    str5 = ['|', ' | zj  |', Z{1}, Z{2}, Z{3}, Z{4}, Q, P1];
    str6 = ['|', ' | cj - zj', U{1}, U{2}, U{3}, U{4}, P1];
    %  显示迭代后表格
    disp(' ');  disp(LM);
    msg = ['***  第  ', num2str(nT), '张单纯形表***'];
    disp(msg);
    disp(LL);  disp(str1);
    disp(LL);  disp(str2);
    disp(LL);  disp(str3);
    disp(LL);  disp(str4);
    disp(LM);  disp(str5);
    disp(LL);  disp(str6);
    disp(LM);
    nT = nT + 1;
    %  判断是否终止迭代
    [aux, I] = max(u);
    if aux <= 0
        K = 0;  %  退出循环
    end  %  防止循环迭代（最大迭代次数限制）
    if nT > 30
        K = 0;  %  退出循环
    end
end
