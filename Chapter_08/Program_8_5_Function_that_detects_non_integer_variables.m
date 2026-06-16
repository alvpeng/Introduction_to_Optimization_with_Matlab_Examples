% 例程 8.5 检测非整数变量的函数
%  检测非整数变量
%  检测到第一个非整数变量后，varVal 返回该变量的下取整值
function [flgInt, varVal, varIx] = fbab_int(X)
flgInt = 1; varVal = 0; varIx = 0;  %  初始化：默认所有变量均为整数
k = 1;
jj = 1;
while  (k == 1)
    aux1 = round(X(jj));
    tol = 0.001;
    if ((X(jj) > aux1 + tol) || (X(jj) < aux1 - tol))
        flgInt = 0;  %  标记为非整数
        varVal = floor(X(jj));
        varIx = jj;
        k = 0;
    end
    if (jj == 2)
        k = 0;
    else
        jj = jj + 1;
    end
end
return
