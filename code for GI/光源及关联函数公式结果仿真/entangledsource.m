%中科大博士论文《基于纠缠光源的量子成像理论与实验研究》，模拟纠缠光源处的一阶关联函数

%P30 式（2.21）光源高斯型描述
clear
a1=5;%光源大小，单位为毫米
a2=0.01;%光源处光场的横向相干长度
[x1,x2]=meshgrid(-0.1:0.001:0.1);
g=(exp(-(x1+x2).^2./(2.*a1.^2))).*(exp(-(x1-x2).^2./(2.*a2.*a2)));%赝热光源处的一阶关联函数，式（3.28），光源为有限大小且横向相干长度不为零
mesh(x1,x2,g);zlabel('纠缠光源（高斯型）处光场的一阶关联函数')

% P30 式（2.24）光源sinc型描述
% clear
% a1=5;%光源大小，单位为毫米
% a2=0.01;%光源处光场的横向相干长度
% [x1,x2]=meshgrid(-0.1:0.001:0.1);
% g=(exp(-(x1+x2).^2./(2.*a1.^2))).*(sinc(-(x1-x2).^2./(2.*a2.*a2)));%赝热光源处的一阶关联函数，式（3.28），光源为有限大小且横向相干长度不为零
% mesh(x1,x2,g);zlabel('纠缠光源（sinc型）处光场的一阶关联函数')