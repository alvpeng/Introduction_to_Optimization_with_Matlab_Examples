% A.4	(P2.25) 信赖域折线法
%  信赖域方法示例（通过折线法实现）
%  目标函数： y=(exp(-(x1-3)/2))+(exp((x1+4*x2)/10))+(exp((x1-4* x2)/10));
[vx1, vx2] = meshgrid(0: 0.1: 10, -4:0.1: 4);
y =(exp(-(vx1 - 3)/2)) + (exp((vx1 + 4*vx2)/10)) + (exp((vx1 - 4*vx2)/10));
%  函数可视化
figure(1)
contour(vx1, vx2, y, 20);
hold on;
xlabel('x1');  ylabel('x2');
%  初始点
x1i = 9;  x2i = 3.5;
%  初始信赖域半径
rr = 0.4;
%  迭代步骤
for nn = 1:20
    a = (exp(-(x1i - 3)/2));
    b = (exp((x1i + 4*x2i)/10));
    c = (exp((x1i - 4*x2i)/10));
    yi = a + b + c;
    %  计算梯度
    aux1 = (-0.5*a) + (0.1*b) + (0.1*c);
    aux2 = (0.4*b) - (0.4*c);
    g = [aux1; aux2];
    %  计算海森矩阵
    qH11 = (0.25*a) + (0.01*b) + (0.01*c);
    qH12 = (0.04*b) - (0.04*c);
    qH21 = (0.04*b) - (0.04*c);
    qH22 = (0.16*b) + (0.16*c);
    H = [qH11, qH12; qH21, qH22];
    %  求解牛顿全步长
    fus = -H\g;
    aux = (g'*fus) + 0.5*(fus'*H*fus);
    Rn = -aux;  %  牛顿步对应的预测下降量
    Ln = norm(fus, 2);  %  牛顿全步长的2-范数
    if Rn > 0  %  牛顿步能使函数值下降
        %  若牛顿步在信赖域内，直接使用该步长
        if Ln <= rr
            delta = fus;
        else
            %  求解柯西点
            aux1 = g'*H*g;
            if aux1 >0
                aux2 = ((norm(g, 2))^3)/(rr*aux1);
                if aux2 > 1
                    tau = 1;
                else
                    tau = aux2;
                end
            else
                tau = 1;
            end
            %  柯西点对应的步长
            delta = -((tau*rr)/norm(g, 2))*g;
            aux = norm(delta, 2);
            %  若柯西点超出信赖域
            if aux >= rr
                %  取梯度方向与信赖域边界的交点
                delta = -rr*(g/norm(g, 2));
            else  %  采用折线法（dog-leg）
                %  柯西点到牛顿点的线段
                sgm = fus - delta;
                M = sgm'*sgm;
                %  求解该线段与信赖域边界的交点
                b = 2*sgm'*delta;
                c = (delta'*delta) - rr^2;
                q = (-b + sqrt(b^2 - 4*M*c))/2/M;
                delta = delta +(q*sgm);
            end
        end
    end
    x1f = x1i + delta(1);
    x2f = x2i + delta(2);
    plot([x1i, x1f], [x2i, x2f], 'k');
    x1i = x1f;
    x2i = x2f;
    %  程序循环结束
end
