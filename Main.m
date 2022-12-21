%%%  �칹ϵͳ-�����Ӹ���-���ڷ���ײ-�쵼�߾���δ֪����
%%%  User: Josie 
%%%  Date: 2022/02/17

%%
clc
clear all; close all;
%% ��ʼ��������
%%% ����С�� 
%%% g1 1��leader,4��follower 
%%% g2 1��leader 3��follower
 

%%leaders�ĳ�ʼ״̬: 4(x+y��) ���˻�
x0_1 = [10,1,10,1]';
x0_2 = [15,1,15,1]';

xL0 = [x0_1;x0_2];
% xL0 = [x0_1;x0_22];

% followers�ĳ�ʼ״̬��2*4+2*2+3*4 = 8+4+12 = 24
r1 =5;
r2 =5;
x1_0 = [r1*(rand-0.5),rand-0.5,r1*(rand-0.5),rand-0.5]'; %follower 1,2 ���� ���˻�
x2_0 = [r1*(rand-0.5),rand-0.5,r1*(rand-0.5),rand-0.5]';
x3_0 = [r1*(rand-0.5),r1*(rand-0.5)]';                   %follower 3,4 һ�� ���˳�
x4_0 = [r1*(rand-0.5),r1*(rand-0.5)]'; 

x5_0 = [r2*(rand-0.5),rand-0.5,r2*(rand-0.5),rand-0.5]'; %follower 5,6,7 ���� ���˻�
x6_0 = [r2*(rand-0.5),rand-0.5,r2*(rand-0.5),rand-0.5]';
x7_0 = [r2*(rand-0.5),rand-0.5,r2*(rand-0.5),rand-0.5]';
xF0 = [x1_0;x2_0;x3_0;x4_0;x5_0;x6_0;x7_0];                           

%follower ������״̬�Ĺ���:״̬�۲���  28
xhat_0 = xF0+2*(rand(24,1)-0.5);

%�ֲ�ʽ�쵼�߹۲�����ʼ״̬: 4*2*7 = 56 7�������߶���ƹ۲����۲�2�쵼�ߵ�״̬ 
elta_hat01 = [x0_1; x0_2];
elta_hat0 = kron(ones(7,1),elta_hat01) + 2*(rand(56,1)-0.5);

 
z0 = [xL0; xF0; xhat_0; elta_hat0];   % 112*1 
% z0 = [xL0];   % 112*1 
% load ini1.mat
% z0 = z0_ini;
%% ΢�ַ������
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
    z0=z0+1/6*(k1+2*k2+2*k3+k4); %�Ľ׶��������������
    i=i+1;
    zout(i,:) = z0';tout(i)=t;
end
