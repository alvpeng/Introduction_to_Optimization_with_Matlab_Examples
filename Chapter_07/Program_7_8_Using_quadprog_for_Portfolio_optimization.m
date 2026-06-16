% 例程 7.8  使用 quadprog () 实现投资组合优化
%  资产数据
returns = [0.0229, 0.0359, -0.0058, 0.0335, -0.0043];
R = 0.02;  %  目标收益率
covariance = [0.109611, 0.048688, 0.033886, 0.050926, 0.041998];
asset_var = diag(covariance);  %  各资产的方差
asset_std = sqrt(asset_var);  %  各资产的标准差
%  可视化协方差矩阵（彩色热力图）
figure(1)
imagesc(covariance);
colormap('colorcube');
[rows, cols] = size(covariance);
for i = 1:rows
    for j = 1:cols
        textHandles (j,i) = text (j, i, num2str(covariance(i, j)), ...
            'horizontalAlignment', 'center');
    end
end
%  在热力图上标注数值
H = covariance;
f = [];  %  线性项系数（本例未使用）
A1 = returns;
b1 = R;
%  组合权重之和 = 1（资金全部分配）
A2 = [1 ,1 ,1 ,1 ,1];
b2 = 1;
%  等式约束（整合上述约束）
Aeq = [A1; A2];
beq = [b1; b2];
%  不等式约束（禁止卖空）
Aineq = -eye(5);
bineq = zeros(5, 1);
%  解的上下界
LB = zeros(5, 1);
UB = [1; 1; 1; 1; 1];
%  调用 quadprog 求解（求解最优资金配置）
%  设置求解器参数
options = optimset('LargeScale', 'off', 'Display', 'off');
x = quadprog(H, f, Aineq, bineq, Aeq, beq, LB, UB, [], options);
%  结果输出
%  投资组合方差（组合风险）
port_var = x'*covariance*x;
port_std = sqrt(port_var);
%  投资组合期望收益率
port_EXPreturn = returns*x;
disp(sprintf('方差 = %.3f', port_var));
disp(sprintf('标准差 = % .3f', port_std ));
disp(sprintf('期望收益率 = % .2f', port_EXPreturn));
%  可视化结果
figure(2)
subplot(2, 1, 1)
bar(returns, 0.3, 'c ');
title('各项资产收益率', 'FontSize', 12);
subplot(2, 1, 2)
bar(x, 0.3, 'r');
title('最优资产投资权重', 'FontSize', 12);
%  生成一系列目标收益率
b1 = linspace(0.005, 0.1, 200);
%  计算对应每个目标收益率的最优解
xset = zeros(5, 200);
for i = 1:200
    beq = [b1(i); b2];
    options = optimset('LargeScale','off', 'Display', 'off');
    xset(:, i) = quadprog(H, f, Aineq, bineq, Aeq, beq, LB, UB, [], options);
end
optPF_var = zeros(200, 1);
optPF_std = zeros(200, 1);
optPF_return = zeros(200, 1);
for i = 1:length(xset)
    optPF_var(i) = xset(:, i)'*covariance*xset(:, i);
    optPF_std(i) = sqrt(optPF_var(i));
    optPF_return(i) = returns*xset(:, i);
end
figure(3)
plot(optPF_std, optPF_return, 'LineWidth', 3)
title('有效边界', 'FontSize', 12);
hold on;
xlabel('风险(标准差)');  ylabel('收益率');
scatter(asset_std, returns, 'filled');
axis([0.1, 0.5, -0.04, 0.08]);
hold off ;
