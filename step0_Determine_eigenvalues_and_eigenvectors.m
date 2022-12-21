%% 目的：计算拉普拉斯矩阵的特征值对角阵和特征向量 J_F 于 U_F
%  J_F = U_F^(-1)*lambda_F*U_F;

%% state function
% leaders
A01 = [0 1; 0 0];   B01 = [0 1]';    C01 = [1 0];  %小组1-leader 01
A02 = [0 1; -4 -4]; B02 = [0 1]';  C02 = [1 0];  %小组2-leader 02

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
num_Fg1 = 4; % 组1跟随者个数
num_Fg2 = 3; % 组2跟随者个数
num_F = 7; %跟随者总数 4+3
num_L1 = 1; % g1 L
num_L2 = 1; % g2 L

% 跟随者组内拉普拉斯矩阵
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

[U_F,J_F] = eig(LF);



