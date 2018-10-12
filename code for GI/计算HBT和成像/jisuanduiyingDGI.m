% 计算时间对应差分关联成像
clear all;    %  清除变量
clc;    %  清除屏幕
close all;    %  关闭图片

num =2000;  %图片文件数
num1 =500;
num2 =1000;
 
h=64;j=64;
i1=0;
i2=0;
S=0;

m=1024;
n=768;

h=256;
j=256;

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
 
Dir1= 'G:\image_save\20150506\1\';    %  文件夹路径
fid2=fopen('G:\image_save\20150506\2000_64_256.dat','r');

tic
for I = 5 : num    %  循环将NUM幅图像累加 
    
    FileName1=['1_1_',int2str(I), '.bmp'];%桶探测器测量值
    Im1 = imread([Dir1 FileName1],'bmp');
    Image1=Im1(430:550,520:630);
    Ima=sum(sum(Image1));
    
    status=fseek(fid2,(I-1)*m*n+1,'bof');%参考探测器读取值
    o=fread(fid2,[m,n],'uint8');
    Image2=o(300:555,300:555);
    Imb=sum(sum(Image2));

    ImageSum1 = ImageSum1 + double(Ima);      %S总光强
    ImageSum2 = ImageSum2 + double(Imb);      %R总光强
   
    ImageAvep1 = ImageSum1./num;         %计算S的平均值
    ImageAvep2 = ImageSum2./num;         %计算R的平均值 

    ImageSum22 = ImageSum22 + double(Image2);      %<I2(x2)>分布，相当于背景噪声
    ImageAvep22 = ImageSum22./num;         %计算<I2(x2)>的平均值

    if mod(I,10)==0  %mod取模运算，结果与除数同号
    I/num 
    toc  %tic toc 用于显示时间
    end  %显示已计算的进度和时间
    
end

for I = 5 : num    %  循环将NUM幅图像累加 
    
    FileName1=['1_1_',int2str(I), '.bmp'];%桶探测器测量值
    Im1 = imread([Dir1 FileName1],'bmp');
    Image1=Im1(480:540,520:640);
    Ima=sum(sum(Image1));
    
    status=fseek(fid2,(I-1)*m*n+1,'bof');%参考探测器读取值
    o=fread(fid2,[m,n],'uint8');
    Image2=o(300:555,300:555);
    Imb=sum(sum(Image2));
    
    %S=Ima-ImageAvep1/ImageAvep2*Imb;% 时间对应差分关联成像
    S=Ima./Imb-ImageAvep1/ImageAvep2;%双阈值时间对应成像桶探测器选择信号
    
  if S>0
      i1=i1+1;
      g1=g1+double(Image2);   
        else if S<0
          i2=i2+1;
          g2=g2+double(Image2);   
            end
  end
  
     if mod(I,10)==0  %mod取模运算，结果与除数同号
    I/num 
    toc  %tic toc 用于显示时间
    end  %显示已计算的进度和时间    
end

G1=g1/i1;%对应正像
G2=g2/i2;%对应负像
G3=g1/i1-ImageAvep22;%对应正像减去背景噪声
G4=g2/i2-ImageAvep22;%对应负像减去背景噪声
G5=G1-G2;%对应正像减去负像
CG1=uint8(round(255 * ((G1-min(min(G1)))./(max(max(G1))-min(min(G1))))));
CG2=uint8(round(255 * ((G2-min(min(G2)))./(max(max(G2))-min(min(G2))))));
CG3=uint8(round(255 * ((G3-min(min(G3)))./(max(max(G3))-min(min(G3))))));
CG4=uint8(round(255 * ((G4-min(min(G4)))./(max(max(G4))-min(min(G4))))));
CG5=uint8(round(255 * ((G5-min(min(G5)))./(max(max(G5))-min(min(G5))))));
% figure;
% imshow(G1);
% figure;
% imshow(G2);
% figure;
% imshow(G3);
% figure;
% imshow(G4);
% figure;
% imshow(G5);
figure;
imshow(CG1);
figure;
imshow(CG2);
figure;
imshow(CG3);
figure;
imshow(CG4);
figure;
imshow(CG5);


% %峰值信噪比PSNR计算方法
% O=uint8(round(255 * ((o-min(min(o)'))./(max(max(o)')-min(min(o)')))));
% sub1 = CG5-o; %用于存储像与原图的差
% MSE1 = sum(sum(sub1 .* sub1)')/(256*256);
% SNR1 = 10*log10(255*255/MSE1)

% %下面计算信噪比
% %李明飞师兄计算方法
% O=uint8(round(255 * ((o-min(min(o)'))./(max(max(o)')-min(min(o)')))));
% Avehuidu = sum(sum(O))./(256*256);
% sub1= O-Avehuidu;
% sub2= CGd-O;
% SNR1=sum(sum(sub1.*sub1))./sum(sum(sub2.*sub2))