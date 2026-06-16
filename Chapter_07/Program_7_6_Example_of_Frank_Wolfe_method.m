% 例程 7.6  弗兰克‑沃尔夫算法示例
Q = [0.30, 0.08; 0.08, 0.7];
b = [-1.2; -0.5];
x0 = [-0.3; 0.9];  %  初始迭代点
%  生成等值线数据
[vx1, vx2] = meshgrid(-1.5: 0.05: 2, -2: 0.05: 2);
y = Q(1, 1)*(vx1.^2) + (Q(2, 1) + Q(1, 2))*vx1.*vx2 + ...
    Q(2, 2)*(vx2.^2) + b(1)*vx1 + b(2)*vx2;
%  定义多边形可行域（约束形式：Ax ≤ c）
%  多边形边数
nply = 5;
A = zeros(nply, 2);
c = zeros(nply, 1);
%  生成多边形顶点（在圆内）
theta_ply = (0:(2*pi)/nply:2*pi);
xply = cos(theta_ply);
yply = 1.5*sin(theta_ply - pi/10);
for i = 1:nply
    %  计算边的方向向量 p = 终点 - 起点
    p = [xply(i + 1) - xply(i), yply(i + 1) - yply(i)];
    %  求解边的法向量
    %  逆时针旋转90度得到法向量
    a = [p(2), -p(1)];
    a = a/norm(a);
    A(i, :) = a;
    %  计算边的偏移量
    c(i) = a*[xply(i); yply(i)];
end
%  算法核心逻辑
%  初始化参数
mingap = 0.01 ;
rx = zeros(50, 2);
figure(1)
plot(xply, yply, 'k', 'LineWidth', 2);
hold  on;
patch(xply, yply, [0.8, 0.95, 0.95]);
contour(vx1, vx2, y, 35);
%  开始
xk = x0;
niter = 1;
rx(1, :) = xk;
while  true
    dJk = Q*xk + b;  %  计算当前点的梯度
    yk = linprog(dJk, A, c, [], [], [], [], [], optimset('Display', 'off'));
    d = yk - xk;
    gap = -dJk'*d;
    if gap < mingap
        break;
    else
        t = 1/(niter + 1);  %  设定步长
        niter = niter + 1;
        xk = xk + (t*d);
        rx(niter, :) = xk;
    end
end
plot(rx(:, 1), rx(:, 2), 'r-', 'LineWidth', 2);
