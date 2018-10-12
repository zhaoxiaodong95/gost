% 时间对应差分关联成像
% 使用计算机生成的散斑图样作为参考探测器测量值
clear all;    %  清除变量
clc;    %  清除屏幕
close all;    %  关闭图片

%o=imread('C:\Users\123456\Desktop\lena256.jpg');
o=imread('C:\Users\Administrator\Desktop\仿真图片\lena256.bmp');
num=500;  %图片文件数

h=256;j=256;
i1=0;
i2=0;
S=0;
ImageSum1 = 0;                       %  用于计算<R>  
ImageSum2 = 0;                        %  用于计算<S>  
ImageSum22 = zeros(h,j);  %  用于计算<I2(x2)>
g1= zeros(h,j);
g2= zeros(h,j);
G= zeros(h,j);
ImageAvep1 = zeros(h,j);
ImageAvep2 = zeros(h,j);
ImageAvep22 = zeros(h,j);

Dir1= 'E:\仿真\伯努利\64\';    %  文件夹路径

tic
for I = 1 : num    %  循环将NUM幅图像累加 
    ImageI=I; %图片标号，用于读取
    FileName1 =['1_1_',int2str(ImageI), '.bmp'];    %  形成文件名称，如Image1.jpg  
    Image1 = imread([Dir1 FileName1],'bmp');%参考探测器光场分布
 
    Image2 = double(Image1).*double(o);  %桶探测器光场分布
    Ima=sum(sum(Image2));          %桶探测器总光强S
    Imb=sum(sum(Image1));          %参考探测器总光强R
   
    ImageSum1 = ImageSum1 + double(Ima);      %S总光强
    ImageSum2 = ImageSum2 + double(Imb);      %R总光强
   
    ImageAvep1 = ImageSum1./num;         %计算S的平均值
    ImageAvep2 = ImageSum2./num;         %计算R的平均值 

    ImageSum22 = ImageSum22 + double(Image1);      %<I2(x2)>分布，相当于背景噪声
    ImageAvep22 = ImageSum22./num;         %计算<I2(x2)>的平均值

    if mod(I,10)==0  %mod取模运算，结果与除数同号
    I/num 
    toc  %tic toc 用于显示时间
    end  %显示已计算的进度和时间
    
end

    fid1=['C:\Users\Administrator\Desktop\S','.txt'];
    c=fopen(fid1,'w');
    
for I = 1 : num    %  循环将NUM幅图像累加 
    ImageI=I; %图片标号，用于读取
    FileName1 =['1_1_',int2str(ImageI), '.bmp'];    %  形成文件名称，如Image1.jpg  
    Image1 = imread([Dir1 FileName1],'bmp');%参考探测器光场分布
    Image2 = double(Image1).*double(o);
    
    Ima=sum(sum(Image2));          %桶探测器总光强S
    Imb=sum(sum(Image1));          %参考探测器总光强R   
%     S=Ima-ImageAvep1/ImageAvep2*Imb;% 时间对应差分关联成像
    S=Ima./Imb-ImageAvep1/ImageAvep2;%双阈值时间对应成像桶探测器选择信号
    
    fprintf(c,'%f\n',S);        %%%q为你要写入的数据，“'%f”为数据格式
    
  if S>0.6897

      i1=i1+1;
      g1=g1+double(Image1);   
        else if S<-0.6897

          i2=i2+1;
          g2=g2+double(Image1);   
            end
  end
  
     if mod(I,10)==0  %mod取模运算，结果与除数同号
    I/num 
    toc  %tic toc 用于显示时间
    end  %显示已计算的进度和时间    
end
fclose(c);

G1=g1/i1;%对应正像
G2=g2/i2;%对应负像
G3=g1/i1-ImageAvep22;%对应正像减去背景噪声
G4=g2/i2-ImageAvep22;%对应负像减去背景噪声
G5=G1-G2;%对应正像减去负像
% CG1=uint8(round(255 * ((G1-min(min(G1)))./(max(max(G1))-min(min(G1))))));
% CG2=uint8(round(255 * ((G2-min(min(G2)))./(max(max(G2))-min(min(G2))))));
% CG3=uint8(round(255 * ((G3-min(min(G3)))./(max(max(G3))-min(min(G3))))));
% CG4=uint8(round(255 * ((G4-min(min(G4)))./(max(max(G4))-min(min(G4))))));
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
% figure;
% imshow(CG1);
% figure;
% imshow(CG2);
% figure;
% imshow(CG3);
% figure;
% imshow(CG4);
figure;
imshow(CG5);
imwrite(CG5,'C:\Users\Administrator\Desktop\DTTCI.bmp');

