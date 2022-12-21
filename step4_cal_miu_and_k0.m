%% 计算miu和k0
%%miu >1+delta/(2*Re(lamda(Lf)_min))
%%k0=inv(P)*c0_bar' P满足riccati方程
clc
%% 系统设置  模型：假设在X,Y两轴方向的模型是相同的
% leaders
A01 = [0 1; 0 0];   B01 = [0 1]';  C01 = [1 0];  %小组1-leader 01
% A02 = [0 1; -4 -4]; B02 = [0 1]';  C02 = [1 0];  %小组2-leader 02
A02 = [0 1; -0.01 -0.01]; B02 = [0 1]';  C02 = [1 0];  %小组2-leader 02

%%% follower --二阶         跟随者均为二阶系统--后续试验方便 group 1: 1-2-3-4 gourp 2: 5-6-7
% followers        
% group 1
A1 = [0 1; -3 -3];  B1 = [0; 1]; C1 = [1 0];
A2 = [0 1; -3 -3];  B2 = [0; 1]; C2 = [1 0];
A3 = [0];  B3 = [1]; C3 = [1];
A4 = [0];  B4 = [1]; C4 = [1];

% group 2
A5 = [0 1;-1 -1];  B5 = [0; 1]; C5 = [1 0];
A6 = [0 1;-1 -1];  B6 = [0; 1]; C6 = [1 0];
A7 = [0 1;-2 -2];  B7 = [0; 1]; C7 = [1 0];  

%% 拉普拉斯矩阵
L1 = [3 0 0 -1;
     -1 1 0 0;
     0 -1 2 0;
     0 0 -1 1];  % 组1-跟随者L    
L2 = [2 0 -1;
     -1 2 0;
     0 -1 1]; % 组2- 跟随者L

% 领导者与跟随者之间的拉普拉斯矩阵
L1EF = [-1 -1; 
         0 0;
        -1 0; 
         0 0];   %interaction group 1 follower-leader
L2EF = [0 -1 
        0 -1 
        0 0];     % group 2 follower-leader

% 两个小组之间的通信矩阵 
L21 = [0 0 0 0;
       0 0 0 0;
       1 -1 0 0]; %% group 1--group 2

%%numbers of the whole systems
num_Fg1 = 4; % 组1跟随者个数
num_Fg2 = 3; % 组2跟随者个数
num_F = 7; %跟随者总数 4+3
num_L1 = 1; % g1 L
num_L2 = 1; % g2 L

% 整个系统的拉普拉斯矩阵
L = [L1   zeros(num_Fg1,num_Fg2)    L1EF;
     L21  L2                        L2EF;
     zeros(num_L1+num_L2, num_Fg1+num_Fg2+num_L1+num_L2)]; 

% follower之间的矩阵
LF=[L1   zeros(num_Fg1,num_Fg2);
    L21  L2]; 

% follower-leader 之间的矩阵
LEF=[L1EF;
     L2EF];   
       
%% 计算 mu
% delta = 0.1; %给定的任意常数
E = sort(eig(LF)); %% sort后求最小特征值
lambda_min = real(E(1));
mu_min = 1/(2*lambda_min) % mu>= mu_min

mu = 2;

%% K0 care函数有可能算不出来, matlab精度的问题
Q = eye(8);
A0 = blkdiag(kron(eye(2),A01),kron(eye(2),A02));
B0 = blkdiag(kron(eye(2),B01),kron(eye(2),B02));
C0 = blkdiag(kron(eye(2),C01),kron(eye(2),C02));

[P0,m,n] = care(A0',C0',Q);

K0 = P0*C0'
P0

% The results of P0 and K0
% P0 = blkdiag(kron(eye(2), [1.7321 1; 1 1.7321]), kron(eye(2), [0.5265   -0.3614; -0.3614    0.4701]))
% K0 = blkdiag(kron(eye(2), [1.7321; 1]), kron(eye(2), [1.5822; 0.7517]));


