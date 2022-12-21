%% 拉普拉斯矩阵

num_Fg1 = 4; % 组1跟随者个数
num_Fg2 = 3; % 组2跟随者个数
num_F = 7; %跟随者总数 4+3
num_L1 = 1; % g1 L
num_L2 = 1; % g2 L

L1 = [3 0 0 -1;
     -1 1 0 0;
      0 -1 2 0;
     -1 0 -1 2];  % 组1-跟随者F的拉普拉斯矩阵
    
L2 = [3 -1 -1;
     -1 3 -1;
      0 -1 1]; % 组2- 跟随者的拉普拉斯矩阵
 
L1EF = [-1 -1;
        0   0;
        -1  0;
        0   0];  %interaction group 1 follower-leader
L2EF = [0 -1;
        0  -1;
        0   0];     % group 2 follower-leader

% 组1和组2的相对矩阵
L21 = [0 0 0 0;
       0 0 0 0;
       1 -1 0 0]; %% group 1--group 2

LF=[L1   zeros(num_Fg1,num_Fg2);
    L21  L2];                     % follower之间的矩阵

[U_F,J_F] = eig(LF);