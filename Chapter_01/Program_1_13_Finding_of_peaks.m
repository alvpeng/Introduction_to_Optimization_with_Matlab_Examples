% 例程 1.13  峰值求解
%  findpeaks函数示例
fer = 0;  %  地震次数
while fer == 0 ,
fid2 = fopen('Num_of_quakes.txt', 'r');
if fid2 == -1
disp( 'read error ');
else
dat = fscanf(fid2, '%f \r\n');
fer = 1;
end;
end;
fclose('all');
T = 1900: 1: 1998;  %  年份
[yp, ix] = findpeaks(dat);
%  画图
figure(1)
plot(T, dat, 'k');
hold on;
plot(T(ix ), yp, 'r*');
xlabel('年份');  ylabel('震级>7的地震次数');
