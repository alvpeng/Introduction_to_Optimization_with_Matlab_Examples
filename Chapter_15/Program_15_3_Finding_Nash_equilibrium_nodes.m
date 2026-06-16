% 例程 15.3  寻找纳什均衡点
%  寻找纳什均衡点，两名参与者
%  收益矩阵（两个矩阵），示例（斗鸡博弈）
P1 = [0, -1; 1, -10];
P2 = [0, 1; -1, -10];
%  初始化
C1 = P1(:, 1);  D1 = P1(:, 2);  %  提取参与者1的策略列
C2 = P2(1, :);  D2 = P2(2, :);  %  提取参与者2的策略列
%  最优反应函数
[br11, h11] = max(C1);  [br12, h12] = max(D1);  %  计算参与者1的最优反应
[br21, h21] = max(C2);  [br22, h22] = max(D2);  %  计算参与者2的最优反应
%  寻找纳什均衡点
if (h11 == h12)  %  参与者1存在严格占优策略
    if (h21 == h22)  %  参与者2存在严格占优策略
        nash = [h11, h21];
        %  参与者2不存在严格占优策略
    elseif  (h21 ~= h22)
        if (h11 == 1)
            nash = [h11, h21];
        elseif (h11 == 2)
            nash = [h11, h22];
        end
    end
    %  参与者1不存在严格占优策略
elseif  (h11 ~= h12)
    if (h21 == h22)  %  参与者2存在严格占优策略
        if (h21 == 1)
            nash = [h11, h21];
        elseif (h21 == 2)
            nash = [h12, h21];
        end;
        % 参与者2不存在严格占优策略
    elseif  (h21 ~= h22)
        if ( h11 == h21)
            if ( h11 == 1)
                nash1 = [h11, h21];
            elseif (h11 == 2)
                if (h12 == 1)
                    nash1 = [h12, h21];
                elseif (h12 == 2)
                    nash1 = [0, 0];
                end
            end
        elseif (h11 ~= h21)
            nash1 = [0, 0];
        end
        if (h12 == h22)
            if (h12 == 2)
                nash2 = [h12, h22];
            elseif (h12 == 1)
                if (h11 == 2)
                    nash2 = [h11, h22]
                elseif (h11 == 1)
                    nash2 = [0, 0];
                end
            end
        elseif (h12 ~= h22)
            nash2 = [0, 0];
        end
        if (nash1 == nash2)
            nash = nash1;
        elseif (nash1 ~= nash2)
            nash = [nash1; nash2];
        end
    end
end
%  显示结果
nash
