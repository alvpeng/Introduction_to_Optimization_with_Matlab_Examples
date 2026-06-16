% 例程 15.6  随机次梯度法在基于 SVM 的分类任务中的应用
%  随机次梯度法示例
%  基于SVM的分类任务，尾花（IRIS）数据集，x=萼片宽度，y=花瓣长度
%  读取鸢尾花数据集
D = dlmread('iris.data');  %  读取数据文件（按列存储）
%  类别A有50个样本点，类别B有100个样本点
X = [D(:, 2), D(:, 3)];  %  提取两列数据（对应x和y特征）
Y = ones(150, 1);  Y(1: 50) = -Y(1: 50);  %  标签赋值：1 或 -1
lambda = 0.27;
alpha = 2.7;
maxiter = 20;
wx = 1;
wy = 1;
b = 1;
Vslop = zeros(maxiter, 1);
Vb = zeros(maxiter, 1);
%  主循环
for nn = 1: maxiter
    gx = 0;  gy = 0;  gb = 0;  %  初始化次梯度
    for i = 1:150
        x = X(i, 1);
        y = X(i, 2);
        %  次梯度计算逻辑
        if ((Y(i)*(wx*x + wy*y + b)) <= 1)
            gx = gx + (Y(i)*x);
            gy = gy + (Y(i)*y);
            gb = gb + Y(i);
        end
    end
    gx = gx/150;
    gy = gy/150;
    gb = gb/150;
    krd = 0.2;
    gx = gx + (lambda)*wx + krd*(rand(1) - 0.5);
    gy = gy + (lambda)*wy + krd*(rand(1) - 0.5);
    gb = gb + (lambda)*b + krd*(rand(1) - 0.5 );
    alpha = alpha/sqrt(nn);
    wx =wx - (alpha*gx);
    wy =wy - (alpha*gy);
    b = b - (alpha*gb);
    slop = wy/wx;
    Vslop(nn, 1) = slop;
    Vb(nn, 1) = b;
end
%  结果可视化
figure(1)
subplot(1, 2, 1);
plot(Vslop(:, 1), 'r');
ylabel('斜率');
subplot(1, 2, 2);
plot(Vb(:, 1), 'r');
ylabel('b');
figure(2)
%  绘制数据集散点图
scatter(X(1:50, 1), X(1: 50, 2), 32, 'k');
hold on;
scatter(X(51: 150,1), X(51:150, 2), 32, 'r');
%  计算并绘制分离直线及边界
slop = wy/wx;
vx = [0: 0.1: 6];
vy = (slop*vx + b);
%  最优分离直线
plot(vx, vy, 'k', 'LineWidth', 2);
vx = [0: 0.1: 6];
vy = (slop*vx + b + 1);
%  类别1的边界线
plot(vx, vy, 'r', 'LineWidth', 2);
vy = (slop*vx + b - 1);
%  类别2的边界线
plot(vx, vy, 'b', 'LineWidth', 2);
