% 例程 16.6  基于露西-理查森算法的图像去模糊
%  读取图像
ip = imread('APtrenBlur1.jpg');
op = im2double(ip);  %  转换为浮点型
%  创建点扩散函数（PSF）
[oL, oC] = size(op);
L = oL - 1;  C = oC - 1;  %  行数和列数减1
sigma = 1.2;
[x, y] = meshgrid(-C/2: C/2, -L/2: L/2);
argm = -((x.^2) + (y.^2))/(2*sigma*sigma);
d= exp(argm);
md = sum(d(:));
d = d/md;  %  归一化后的点扩散函数
%  退化的光学传递函数（OTF）
D = fft2(d);
%  露西-理查森算法（LRA）准备工作
mp = medfilt2(op);  %  中值滤波
ep = mp;  %  初始估计图像
%  露西-理查森算法迭代过程
for nn =1:5
    %  分母（基于傅里叶变换的卷积运算）
    EP = fft2(ep);
    BEP = D.*EP;
    bep = abs(ifftshift(ifft2(BEP)));
    %  分子/分母
    r = ep./(0.0001 + bep);  %  简单正则化
    %  修正向量（基于傅里叶变换的卷积运算）
    R = fft2(r);
    CV = D.*R;
    cv = abs(ifftshift(ifft2(CV)));
    %  下一次估计
    ep = cv.*ep ;
end
%  显示图像
figure(1)
subplot(2, 1, 1)
imshow(op);
title ('原始图像');
subplot(2, 1, 2)
imshow(ep);
title('复原结果');
