% A.10(P7.5) 投影梯度示例
%  投影梯度法示例
Q = [0.30, 0.08; 0.08, 0.7];
b = [-1.2; -0.5];
x0 = [-0.3; 0.9];  %  初始点
%  等高线数据
[vx1, vx2] = meshgrid(-1.5: 0.05: 2, -2: 0.05: 2);
y = Q(1, 1)*(vx1.^2) +(Q(2, 1) + ...
    Q(1, 2))*vx1.*vx2 + Q(2, 2)*(vx2.^2) + b(1)*vx1 + b(2)*vx2;
%  定义多边形可行域(Ax ≤ c)
%  多边形边数
nply = 5;
A = zeros(nply, 2);
c = zeros(nply, 1);
%  求解顶点（圆内生成）
theta_ply =(0:(2*pi)/nply: 2*pi);
xply = cos(theta_ply);
yply = 1.5*sin(theta_ply - pi/10);
for i = 1: nply
    %  计算边的方向向量 p = x2 - x1
    p = [xply(i + 1) - xply(i), yply(i + 1) - yply(i)];
    %  求解法向量
    %  逆时针旋转90度
    a = [p(2), -p(1)];
    a = a/norm(a);
    A(i, :) = a;
    %  边的偏移量
    c(i) = a*[xply(i); yply(i)];
end
%  算法核心
%  初始化
maxiter = 50;
miner = 0.005;
mina = 1e-6;
cc = 0.5;  %  Armijo准则参数
alphak = 1;  %  Armijo初始步长
rx = zeros(maxiter, 2);
rd = zeros(maxiter, 2);  %  存储搜索方向
rg = zeros(maxiter, 2);  %  存储梯度值
%  迭代开始
xk = PG_proj(x0, A, c);  %  初始点投影到可行域F上
for  k = 1:maxiter
    Jk = 0.5*xk'*Q*xk + b'*xk;
    dJk = Q*xk + b;  %  目标函数梯度
    dk = PG_proj(xk - dJk, A, c) - xk;  %  检查是否为下降方向
    if (dJk'*dk > 0)
        disp('终止：非下降方向');
        break;
    end
    %  Armijo线搜索（回溯法）
    xk1 = xk + alphak*dk;
    Jk1 = 0.5*xk1'*Q*xk1 + b'*xk1;
    while(Jk1 > Jk + cc*alphak*dJk'*dk) &&(alphak > mina)
        %  步长减半
        alphak = 0.5*alphak;
        %  计算新步长下的迭代点和函数值
        xk1 = xk + alphak*dk;
        Jk1 = 0.5*xk1'*Q*xk1 + b'*xk1;
    end
    %  保存迭代数据
    rx(k, :) = xk;
    rd(k, :) = dk;
    rg(k, :) = dJk;
    %  更新迭代点
    xk = xk1;
    %  终止条件判断
    if(norm(dk, 2) < miner)
        disp('步长方向过小');
        break;
    end
    if(alphak < mina)
        disp('步长过小');
        break;
    end
end
%  最优解输出
x = xk
k
figure(1)
plot(xply, yply, 'k', 'LineWidth', 2);
hold  on;
patch(xply, yply, [0.8, 0.95, 0.95]);
contour(vx1, vx2, y, 35);
plot(rx(1:k, 1), rx(1:k, 2), 'ko', 'MarkerFaceColor', 'k');
plot(rx(1:k, 1) - rg(1:k, 1), rx(1:k, 2) - rg(1:k, 2), 'ro', 'MarkerFaceColor', 'r');
quiver(rx(1:k, 1), rx(1:k, 2), -rg(1:k, 1), -rg(1:k, 2), 0);

%  投影函数定义
function  x = PG_proj(y, A, c)
n = length(y);
H = eye(n);
x0 = y;
options = optimset('Display', 'off');
x = quadprog(H, -y, A, c, [], [], [], [], x0, options);
return
end
