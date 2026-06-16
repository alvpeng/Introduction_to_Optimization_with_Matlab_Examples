% 例程 15.9  线性近端支持向量机（LPSVM）示例
% 鸢尾花（IRIS）数据集， x=萼片宽度, y=花瓣长度
% 读取鸢尾花数据集
DAT = dlmread('iris.data');  %  读取数据列
%  类别A有50个样本点，类别B有100个样本点
A = [DAT(:, 2), DAT(:, 3)];  %  取两列数据（x,y）
Y = ones(150, 1);  Y(1: 50) = -Y(1: 50);  %  标签：1 或 -1
D = diag(Y);
nu = 0.05;
%  论文中的核心代码
[m, n] = size(A);
e = ones(m, 1);
H = D*[A, -e];
r = sum(H)';  %  等价于 r = H'*e
r = (speye(n + 1)/nu + H'*H)\r;  %  求解线性方程组
u = nu*(1 - H*r);
s = D*u;
w = (s'*A)';  %  等价于 w = A'*D*u
gamma = sum(s);  %  等价于 gamma = -e'*D*u
%  结果可视化
figure(1)
%  绘制数据集
scatter(A(1:50, 1), A(1:50, 2), 32, 'k');
hold  on;
scatter(A(51:150, 1), A(51:150, 2), 32, 'r');
%  绘制分类线
slop = -w(1)/w(2);
b = gamma;
vx = [0: 0.1: 6];
vy = (slop*vx + b +1);
%  类别1的边界线
plot(vx, vy, 'r', 'LineWidth', 2);
vx = [0: 0.1: 6];
vy = (slop*vx + b);
%  最优分类线
plot(vx, vy, 'k--', 'LineWidth', 2);
vy = (slop*vx +b - 1);
%  类别2的边界线
plot(vx, vy, 'b', 'LineWidth', 2);
