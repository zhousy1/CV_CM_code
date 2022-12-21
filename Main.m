%%%  异构系统-分组编队跟踪-存在防碰撞-领导者具有未知输入
%%%  User: Josie 
%%%  Date: 2022/02/17

%%
clc
clear all; close all;
%% 初始条件设置
%%% 两个小组 
%%% g1 1个leader,4个follower 
%%% g2 1个leader 3个follower
 

%%leaders的初始状态: 4(x+y轴) 无人机
x0_1 = [10,1,10,1]';
x0_2 = [15,1,15,1]';

xL0 = [x0_1;x0_2];
% xL0 = [x0_1;x0_22];

% followers的初始状态：2*4+2*2+3*4 = 8+4+12 = 24
r1 =5;
r2 =5;
x1_0 = [r1*(rand-0.5),rand-0.5,r1*(rand-0.5),rand-0.5]'; %follower 1,2 二阶 无人机
x2_0 = [r1*(rand-0.5),rand-0.5,r1*(rand-0.5),rand-0.5]';
x3_0 = [r1*(rand-0.5),r1*(rand-0.5)]';                   %follower 3,4 一阶 无人车
x4_0 = [r1*(rand-0.5),r1*(rand-0.5)]'; 

x5_0 = [r2*(rand-0.5),rand-0.5,r2*(rand-0.5),rand-0.5]'; %follower 5,6,7 二阶 无人机
x6_0 = [r2*(rand-0.5),rand-0.5,r2*(rand-0.5),rand-0.5]';
x7_0 = [r2*(rand-0.5),rand-0.5,r2*(rand-0.5),rand-0.5]';
xF0 = [x1_0;x2_0;x3_0;x4_0;x5_0;x6_0;x7_0];                           

%follower 对自身状态的估计:状态观测器  28
xhat_0 = xF0+2*(rand(24,1)-0.5);

%分布式领导者观测器初始状态: 4*2*7 = 56 7个跟随者都设计观测器观测2领导者的状态 
elta_hat01 = [x0_1; x0_2];
elta_hat0 = kron(ones(7,1),elta_hat01) + 2*(rand(56,1)-0.5);

 
z0 = [xL0; xF0; xhat_0; elta_hat0];   % 112*1 
% z0 = [xL0];   % 112*1 
% load ini1.mat
% z0 = z0_ini;
%% 微分方程求解
t0 = 0;
tf = 50;
h = 0.01;
len_z = size(z0,1);
n=round(tf/h+1);
zout = zeros(n,len_z); tout=zeros(n,1);
i=0;
for t=t0:h:tf
    k1=h*dEqu( t,z0 );
    k2=h*dEqu( t+0.5*h,z0+0.5*k1 );
    k3=h*dEqu( t+0.5*h,z0+0.5*k2 );
    k4=h*dEqu( t+h,z0+k3 );
    z0=z0+1/6*(k1+2*k2+2*k3+k4); %四阶定步长龙格库塔法
    i=i+1;
    zout(i,:) = z0';tout(i)=t;
end
