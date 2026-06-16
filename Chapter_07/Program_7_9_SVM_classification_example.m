% 例程 7.9  支持向量机（SVM）分类示例
%  鸢尾花（IRIS）数据集，x = 萼片宽度，y = 花瓣长度
%  读取鸢尾花数据集
D = dlmread('iris.data');  %  读取数据文件（按列存储）
%  类别A有50个样本点，类别B有100个样本点
X = [D(:, 2), D(:, 3)];  %  提取两列数据（x, y）
Y = ones(150, 1);
Y(1: 50) = -Y(1: 50);  %  标签：1 或 -1
%  准备二次规划求解参数
%  对约束条件两边同时乘以-1
H = eye(3);
H(3, 3) = 0;
f = zeros(3, 1);
Z = [X, ones(150, 1)];  %  辅助矩阵（拼接X和全1列）
A = -diag(Y)*Z;
b = -ones(150, 1);
%  调用quadprog求解
%  关闭求解过程输出
options = optimset('LargeScale', 'off', 'Display', 'off');
M = quadprog(H, f, A, b, [], [], [], [], [], options);
slop = M(2)/M(1);
%  结果可视化
figure(1)
%  绘制数据点
scatter(X(1:50, 1), X(1:50, 2), 32, 'k');  hold on;
scatter(X(51:150, 1), X(51: 150, 2), 32, 'r');
%  绘制直线
vx = [0: 0.1: 6];
vy = -(M(1)*vx + M(3))/M(2);
%  绘制最优分类直线
plot(vx, vy, 'r', 'LineWidth', 2);
vyUP = (1 - M(1)*vx - M(3))/M(2);
plot(vx, vyUP, 'g', 'LineWidth', 2);  %  绘制上间隔线
vyDW = (-1 - M(1)*vx - M(3))/M(2);
plot(vx, vyDW, 'g', 'LineWidth', 2);  %  绘制下间隔线
axis([0, 6, 0, 8]);
title('基于鸢尾花数据的线性支持向量机分类');
xlabel('萼片宽度');  ylabel ('花瓣长度');
