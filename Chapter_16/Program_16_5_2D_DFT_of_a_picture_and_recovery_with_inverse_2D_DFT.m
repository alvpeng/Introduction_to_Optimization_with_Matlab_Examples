% 例程 16.5  图像的二维离散傅里叶变换及恢复
%  将图像文件读取到矩阵中
cpic = imread('kukoo.jpg');
Fcpic = fftshift(fft2(cpic));  %  傅里叶变换
M = max(max(Fcpic));  %  求取变换结果的最大值
sFcpic = (256*Fcpic/M);  %  归一化处理
IFc = ifft2(Fcpic);  %  逆傅里叶变换
uIFc = uint8(abs(IFc));  %  转换为无符号8位整数
figure(1)
subplot(1, 3, 1)
imshow(cpic);  %  显示原始图片
title('原始图像');
subplot(1, 3, 2);
imshow(abs(sFcpic));  %  显示图片的傅里叶变换结果
title('二维离散傅里叶变换');
subplot(1, 3, 3);
imshow(uIFc);  %  显示傅里叶逆变换结果
title('二维傅里叶逆变换结果');
