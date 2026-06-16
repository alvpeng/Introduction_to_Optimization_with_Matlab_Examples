% 例程 16.2  灰度图像的低通滤波
%  显示经过滤波的灰度图像
%  均值滤波器
%  将图像文件读取到矩阵中
cpic = imread('APnewyork.jpg');
fil = fspecial('average', [10, 10]);  %  滤波器模板
fc = filter2(fil, cpic);
bfc = uint8(round(fc));  %  转换为无符号8位整数
figure(1)
imshow(bfc);
