% A.3	(P2.24) 基于柯西点的信赖域方法
%  目标函数： y=(exp(-(x1-3)/2))+%(exp((x1+4* x2)/10))+(exp((x1-4* x2)/10));
[vx1, vx2] = meshgrid(0: 0.1: 10, -4: 0.1: 4);
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
%  信赖域规则参数
LaL = 0.25;
LaH = 0.75;
%  终止标志
EF = 0;
%  步长接受标志
SF = 0;
%  迭代步骤
while EF == 0
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
    %  求解柯西点
    aux1 = g'*H*g;
    if aux1 > 0
        aux2 = ((norm(g, 2))^3)/(rr*aux1);
        if aux2 > 1
            tau = 1;
        else
            tau = aux2;
        end;
    else
        tau = 1;
    end;
    %  柯西点对应的步长
    delta = -((tau*rr)/norm(g, 2))*g;
    x1a = x1i + delta(1);
    x2a = x2i + delta(2);
    %  评估函数值下降量
    %  实际函数值
    a = (exp(-(x1a - 3)/2));
    b = (exp((x1a + 4*x2a)/10));
    c = (exp((x1a - 4*x2a)/10));
    yia = a + b + c;
    Ra = yi - yia;
    %  模型预测下降量
    aux = (g'*delta) + 0.5*(delta'*H*delta);
    Rp = -aux;
    rho = Ra/Rp;
    %  信赖域规则
    if rho < LaL
        rr = rr/2;  %  半径减半
    else
        SF = 1;  %  步长接受标志置1
        if rho > LaH
            aux = norm(delta, 2);
            if(2*aux > rr)
                rr = 2*aux;  %  半径扩大为步长的2倍
            end
        end
    end
    %  迭代决策
    if SF == 1  %  接受当前步长
        SF = 0;
        x1f = x1i + delta(1);
        x2f = x2i + delta(2);
        plot([x1i, x1f], [x2i, x2f], 'k');
        x1i = x1f;
        x2i = x2f;
    end
    %  当下降量可忽略时终止迭代
    if Ra < 0.0001
        EF = 1;  %  终止标志置1
    end
    %  程序循环结束
end
