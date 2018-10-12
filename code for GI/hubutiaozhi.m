%使用计算机生成的散斑图样作为参考探测器测量值
clear all;    %  清除变量
clc;    %  清除屏幕
close all;    %  关闭图片

%o=imread('C:\Users\123456\Desktop\lena256.jpg');
o=imread('C:\Users\Administrator\Desktop\20150623\仿真图片\a256.bmp');
% o=rgb2gray(o);
% o=zeros(256);%产生双缝
% o(:,70:100)=1;
% o(:,150:180)=1;
% b=ones(2)

num =2000;  %图片文件数
% num1=6500;
% num2=2000;
% num3=3500;
 
h=256;j=256;
 
ImageSum1 = 0;                       %  用于计算<R>  
ImageSum2 = 0;                        %  用于计算<S>  
ImageSum22 = zeros(h,j);  %  用于计算<I2(x2)>
g= zeros(h,j);
G= zeros(h,j);
ImageAvep1 = zeros(h,j);
ImageAvep2 = zeros(h,j);
ImageAvep22 = zeros(h,j);
 
Image1Sum1 = 0;                       %  用于计算<R>  
Image1Sum2 = 0;                        %  用于计算<S>  
Image1Sum22 = zeros(h,j);  %  用于计算<I2(x2)>
g1= zeros(h,j);
G1= zeros(h,j);
Image1Avep1 = zeros(h,j);
Image1Avep2 = zeros(h,j);
Image1Avep22 = zeros(h,j);
 
Image2Sum1 = 0;                       %  用于计算<R>  
Image2Sum2 = 0;                        %  用于计算<S>  
Image2Sum22 = zeros(h,j);  %  用于计算<I2(x2)>
g2= zeros(h,j);
G2= zeros(h,j);
Image2Avep1 = zeros(h,j);
Image2Avep2 = zeros(h,j);
Image2Avep22 = zeros(h,j);
 
Image3Sum1 = 0;                       %  用于计算<R>  
Image3Sum2 = 0;                        %  用于计算<S>  
Image3Sum22 = zeros(h,j);  %  用于计算<I2(x2)>
g3= zeros(h,j);
G3= zeros(h,j);
Image3Avep1 = zeros(h,j);
Image3Avep2 = zeros(h,j);
Image3Avep22 = zeros(h,j);

Dir1= 'E:\随机图片\哈达玛\随机\';    %  文件夹路径

tic
for I = 1 : num    %  循环将NUM幅图像累加 
    Imagei=2*I-1; %图片标号，用于读取
    Imagej=2*I;
    FileName1 =['1_1_',int2str(Imagei), '.bmp'];    %  形成文件名称，如Image1.jpg  
    FileName2 =['1_1_',int2str(Imagej), '.bmp'];
    %Image1 = imread([Dir1 FileName1],'bmp');%参考探测器光场分布
%     a=imread([Dir1 FileName1],'jpg');%参考探测器光场分布

    Image1=imread([Dir1 FileName1],'bmp');%参考探测器光场分布
    Image11=imread([Dir1 FileName2],'bmp');
    Image2 = double(Image1).*double(o);%桶探测器光场分布,处理灰度图像时注意最后的输出类型
    Image22 = double(Image11).*double(o);
    
    Ima1=sum(sum(Image2));          %桶探测器总光强S
    Ima2=sum(sum(Image22)); 
    Ima=Ima1-Ima2;
    
    Imb=sum(sum(Image1));          %参考探测器总光强R
   
    ImageSum1 = ImageSum1 + double(Ima);      %S总光强
% ImageSum1 = ImageSum1 + double(Ima1)+ double(Ima2); 
    ImageSum2 = ImageSum2 + double(Imb);      %R总光强
    ImageSum22 = ImageSum22 + double(Image1);     %计算I2(x2)
    
    G = G + Ima.*double(Image1);              %关联计算S*I2(x2)
% 	G = G + Ima1.*double(Image1)+ Ima2.*double(Image1); 
    g  = g + Imb.*double(Image1);                %计算R*I2(x2)
    
    ImageAvep1 = ImageSum1./num;         %计算S的平均值
    ImageAvep2 = ImageSum2./num;         %计算R的平均值 
    ImageAvep22 = ImageSum22./num;        %计算R的平均图像

    if mod(I,10)==0  %mod取模运算，结果与除数同号
    I/num 
    toc  %tic toc 用于显示时间
    end  %显示已计算的进度和时间   
  

end

% Gt = G./num;                             %传统鬼成像
% Gg = G./num./(ImageAvep1.*ImageAvep22); %归一化鬼成像
% Gf = G./num - ImageAvep1.*ImageAvep22;    %涨落关联图像
Gd = G./num - ImageAvep1./ImageAvep2 .* g./num; %差分鬼成像


% CGt=uint8(round(255 * ((Gt-min(min(Gt)))./(max(max(Gt))-min(min(Gt))))));
% % CGg=uint8(round(255 * ((Gg-min(min(Gg)))./(max(max(Gg))-min(min(Gg))))));
% CGf=uint8(round(255 * ((Gf-min(min(Gf)))./(max(max(Gf))-min(min(Gf))))));
CGd=uint8(round(255 * ((Gd-min(min(Gd)))./(max(max(Gd))-min(min(Gd))))));
 
% figure;
% imshow(CGt)
% % figure;
% % imshow(CGg)
% figure;
% imshow(CGf)
figure;
imshow(CGd)
% imwrite(CGt,'C:\Users\Administrator\Desktop\t.bmp');
% % imwrite(CGg,'C:\Users\Administrator\Desktop\g.bmp');
% imwrite(CGf,'C:\Users\Administrator\Desktop\f.bmp');
imwrite(CGd,'C:\Users\Administrator\Desktop\d400.bmp');
