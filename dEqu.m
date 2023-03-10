function [ dx ] = dEqu( t,x )
%   UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_Fg1 = 4; % 组1跟随者个数
num_Fg2 = 3; % 组2跟随者个数
num_F = 7; %跟随者总数 4+3
num_L1 = 1; % g1 L
num_L2 = 1; % g2 L

% 维度
nL=4;  % xy轴 领导者
nF=2;   %xy轴 跟随者

%% 模型：假设各智能体在X,Y两轴方向的模型是相同的
% leaders
A01 = [0 1; 0 0];   B01 = [0 1]';  C01 = [1 0];  %小组1-leader 01
A02 = [0 1; -0.001 -0.001]; B02 = [0 1]';  C02 = [1 0];  %小组2-leader 02

%%% follower --二阶         跟随者均为二阶系统--后续试验方便 group 1: 1-2-3-4 gourp 2: 5-6-7      
% group 1
A1 = [0 1; -3 -3];  B1 = [0; 1]; C1 = [1 0];
A2 = [0 1; -3 -3];  B2 = [0; 1]; C2 = [1 0];
A3 = [0];  B3 = [1]; C3 = [1];
A4 = [0];  B4 = [1]; C4 = [1];

% group 2
A5 = [0 1;-1 -1];  B5 = [0; 1]; C5 = [1 0];
A6 = [0 1;-1 -1];  B6 = [0; 1]; C6 = [1 0];
A7 = [0 1;-2 -2];  B7 = [0; 1]; C7 = [1 0];  
%% 调节器参数计算
X1 = [1 0;0 1]; U1=[3 3]; R1 = [1];
X2 = [1 0;0 1]; U2=[3 3]; R2 = [1];
X3 = [1 0]; U3=[0 1]; R3 = [0];
X4 = [1 0]; U4=[0 1]; R4 = [0];

X5 = [1 0;0 1]; U5=[0.999 0.999]; R5 = [1];
X6 = [1 0;0 1]; U6=[0.999 0.999]; R6 = [1];
X7 = [1 0;0 1]; U7=[1.999 1.999]; R7 = [1];

%% B_bar 与B_hat
% group 1
B1_bar=[0 1]; B1_hat=[1 0];
B2_bar=[0 1]; B2_hat=[1 0];
B3_bar=[1]; B3_hat=[0]; 
B4_bar=[1]; B4_hat=[0];

% group 2
B5_bar=[0 1]; B5_hat=[1 0];
B6_bar=[0 1]; B6_hat=[1 0];
B7_bar=[0 1]; B7_hat=[1 0];

%% 反馈参数 K0 p0 Li K1i K2i K3i P Mi
% mu 和LF相关 // K0与P0 和A02相关
mu = 2;
K0 = blkdiag(kron(eye(2), [1.7321; 1]), kron(eye(2), [1.7305; 0.9973]));
P0 = blkdiag(kron(eye(2), [1.7321 1; 1 1.7321]), kron(eye(2), [1.7305    0.9973; 0.9973    1.7285]));

% K1i 和 follower的状态方程相关
K11 = [2.5  1.5]; K12 = [2.5 1.5]; K13 = [-1]; K14 = [-1];
K15 = [0.5 -0.5]; K16 = [0.5 -0.5]; K17 = [1.5 0.5];

% L0i 和follower的状态方程相关
L01 = [0; 1]; L02 = [0; 1]; L03 = [-1]; L04 = [-1];
L05 = [-2;1]; L06 = [-2;1]; L07 = [-1;2];

% 和Ui相关，也就和A0i 相关
K21 = [0.5 1.5]; K22 = [0.5 1.5]; K23 = [1 1]; K24 = [1 1];
K25 = [0.499 1.499]; K26 = [0.499 1.499]; K27 = [0.499 1.499];

K31 = [1.0000   -1.2500]; K32 = [1.0000   -1.2500]; K33 = [-1]; K34 = [-1]; 
K35 = [1.0000   -1.2500]; K36 = [1.0000   -1.2500]; K37 = [1.0000   -1.2500];

M1 = [4 2;2 2]; M2 = [4 2; 2 2]; M3 = [1]; M4 = [1];
M5 = [4 2; 2 2]; M6 = [4 2; 2 2]; M7 = [4 2; 2 2];
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
    
%% =======获取各个变量==========

%领导者状态 the state of leaders
xL = x(1:8); 
x01 = xL(1:4); x02 = xL(5:end); 

% 跟随者状态 the state of followers
xF = x(9:32);         
xFg1 = xF(1:12);    
xFg2 = xF(13:end);  
x1 = xF(1:4); x2 = xF(5:8); x3 = xF(9:10); x4 = xF(11:12); 
x5 = xF(13:16); x6 = xF(17:20); x7 = xF(21:24);

% 跟随者自身状态观测器 state observer of the follower itself
xhat = x(33:56);       
xhatg1 = xhat(1:12);    % 4+4+2+2   
xhatg2 = xhat(13:end);  % 4+4+4
% 组1
x1_hat = xhatg1(1:4); x2_hat = xhatg1(5:8); x3_hat = xhatg1(9:10); x4_hat = xhatg1(11:12); 
% 组2
x5_hat = xhatg2(1:4); x6_hat = xhatg2(5:8); x7_hat = xhatg2(9:12);

%领导者状态观测器的状态 the state observer of all leaders
elta_hat = x(57:end);       
elta_hatg1 = elta_hat(1:32);    
elta_hatg2 = elta_hat(33:end); 
%组1
elta1_hat = elta_hatg1(1:8);    elta2_hat = elta_hatg1(9:16);
elta3_hat = elta_hatg1(17:24);  elta4_hat = elta_hatg1(25:32);  

%组2
elta5_hat = elta_hatg2(1:8);    elta6_hat = elta_hatg2(9:16); 
elta7_hat = elta_hatg2(17:24); 

%% 外部输入 可得 gamma = 5
% u0 = [0.5*sin(t);0.5*cos(t)];  

u01 = [-0.05;0.05]; 
u02 = [0.05; 0.05];
% u02 = [1*cos(t);1*sin(t)];
%% 编队状态
r1 = 3;
r2 = 5;
h1 = [15*sin(t+(1-1)*pi/2);     15*cos(t+(1-1)*pi/2);  15*cos(t+(1-1)*pi/2);    -15*sin(t+(1-1)*pi/2)];
h2 = [15*sin(t+(2-1)*pi/2);     15*cos(t+(2-1)*pi/2);  15*cos(t+(2-1)*pi/2);    -15*sin(t+(2-1)*pi/2)];
h3 = [15*sin(t+(3-1)*pi/2);     15*cos(t+(3-1)*pi/2);  15*cos(t+(3-1)*pi/2);    -15*sin(t+(3-1)*pi/2)];
h4 = [15*sin(t+(4-1)*pi/2);     15*cos(t+(4-1)*pi/2);  15*cos(t+(4-1)*pi/2);    -15*sin(t+(4-1)*pi/2)];

h5 = [5*sin(t+(1-1)*2*pi/3);     5*cos(t+(1-1)*2*pi/3);  5*cos(t+(1-1)*2*pi/3);    -5*sin(t+(1-1)*2*pi/3)];
h6 = [5*sin(t+(2-1)*2*pi/3);     5*cos(t+(2-1)*2*pi/3);  5*cos(t+(2-1)*2*pi/3);    -5*sin(t+(2-1)*2*pi/3)];
h7 = [5*sin(t+(3-1)*2*pi/3);     5*cos(t+(3-1)*2*pi/3);  5*cos(t+(3-1)*2*pi/3);    -5*sin(t+(3-1)*2*pi/3)];

%编队微分
dh1 = [15*cos(t+(1-1)*pi/2);     -15*sin(t+(1-1)*pi/2);  -15*sin(t+(1-1)*pi/2);    -15*cos(t+(1-1)*pi/2)];
dh2 = [15*cos(t+(2-1)*pi/2);     -15*sin(t+(2-1)*pi/2);  -15*sin(t+(2-1)*pi/2);    -15*cos(t+(2-1)*pi/2)];
dh3 = [15*cos(t+(3-1)*pi/2);     -15*sin(t+(3-1)*pi/2);  -15*sin(t+(3-1)*pi/2);    -15*cos(t+(3-1)*pi/2)];
dh4 = [15*cos(t+(4-1)*pi/2);     -15*sin(t+(4-1)*pi/2);  -15*sin(t+(4-1)*pi/2);    -15*cos(t+(4-1)*pi/2)];

dh5 = [5*cos(t+(1-1)*2*pi/3);     -5*sin(t+(1-1)*2*pi/3);  -5*sin(t+(1-1)*2*pi/3);    -5*cos(t+(1-1)*2*pi/3)];
dh6 = [5*cos(t+(2-1)*2*pi/3);     -5*sin(t+(2-1)*2*pi/3);  -5*sin(t+(2-1)*2*pi/3);    -5*cos(t+(2-1)*2*pi/3)];
dh7 = [5*cos(t+(3-1)*2*pi/3);     -5*sin(t+(3-1)*2*pi/3);  -5*sin(t+(3-1)*2*pi/3);    -5*cos(t+(3-1)*2*pi/3)];

%编队补偿
r1 = -kron(eye(2),B1_bar*X1)*(kron(eye(2),A01)*h1-dh1);
r2 = -kron(eye(2),B2_bar*X2)*(kron(eye(2),A01)*h2-dh2);
r3 = -kron(eye(2),B3_bar*X3)*(kron(eye(2),A01)*h3-dh3);
r4 = -kron(eye(2),B4_bar*X4)*(kron(eye(2),A01)*h4-dh4);

r5 = -kron(eye(2),B5_bar*X5)*(kron(eye(2),A02)*h5-dh5);
r6 = -kron(eye(2),B6_bar*X6)*(kron(eye(2),A02)*h6-dh6);
r7 = -kron(eye(2),B7_bar*X7)*(kron(eye(2),A02)*h7-dh7);

%% 计算fi与gi 外部输入补偿项（非线性函数）
x0 = [x01; x02];
elta1_tlide = elta1_hat - x0; elta2_tlide = elta2_hat - x0; elta3_tlide = elta3_hat - x0; elta4_tlide = elta4_hat - x0;
elta5_tlide = elta5_hat - x0; elta6_tlide = elta6_hat - x0; elta7_tlide = elta7_hat - x0;
elta_tlide = [elta1_tlide; elta2_tlide; elta3_tlide; elta4_tlide; elta5_tlide; elta6_tlide; elta7_tlide];
B0 = blkdiag(kron(eye(2),B01),kron(eye(2),B02));

f=[];
for i = 1:7
%     if norm(B0'*inv(P0)*elta_tlide((8*i-7):8*i)) == 0
%         f = [f; 0];
%     else
%         f = [f; B0'*inv(P0)*elta_tlide((8*i-7):8*i)/(norm(B0'*inv(P0)*elta_tlide((8*i-7):8*i))+0.02)];
%     end
    if norm(B0'*inv(P0)*elta_tlide((8*i-7):8*i)) == 0
        f = [f; 0];
    else
        f = [f; B0'*inv(P0)*elta_tlide((8*i-7):8*i)/(norm(B0'*inv(P0)*elta_tlide((8*i-7):8*i)))];
    end
end

% 计算gi calculate gi
H1 = x1 - kron(eye(2),X1)*(x01+h1); 
H2 = x2 - kron(eye(2),X2)*(x01+h2); 
H3 = x3 - kron(eye(2),X3)*(x01+h3); 
H4 = x4 - kron(eye(2),X4)*(x01+h4);
H5 = x5 - kron(eye(2),X5)*(x02+h5); 
H6 = x6 - kron(eye(2),X6)*(x02+h6); 
H7 = x7 - kron(eye(2),X7)*(x02+h7);
 
N1 = M1*B1*R1; N2 = M2*B2*R2; N3 = M3*B3*R3; N4 = M4*B4*R4;
N5 = M5*B5*R5; N6 = M6*B6*R6; N7 = M7*B7*R7;

if norm(kron(eye(2),N1')*H1) ==0
    g1 = 0;
else
    g1 = kron(eye(2),N1')*H1/(norm(kron(eye(2),N1')*H1)); 
end

if norm(kron(eye(2),N2')*H2) ==0
    g2 = 0;
else
    g2 = kron(eye(2),N2')*H2/(norm(kron(eye(2),N2')*H2));  
end

if norm(kron(eye(2),N3')*H3) ==0
    g3 = 0;
else
    g3 = kron(eye(2),N3')*H3/(norm(kron(eye(2),N3')*H3)); 
end

if norm(kron(eye(2),N4')*H4) ==0
    g4 = 0;
else
    g4 = kron(eye(2),N4')*H4/(norm(kron(eye(2),N4')*H4));  
end

if norm(kron(eye(2),N5')*H5) ==0
    g5 = 0;
else
    g5 = kron(eye(2),N5')*H5/(norm(kron(eye(2),N5')*H5)); 
end

if norm(kron(eye(2),N6')*H6) ==0
    g6 = 0;
else
    g6 = kron(eye(2),N6')*H6/(norm(kron(eye(2),N6')*H6));  
end

if norm(kron(eye(2),N7')*H7) ==0
    g7 = 0;
else
    g7 = kron(eye(2),N7')*H7/(norm(kron(eye(2),N7')*H7)); 
end

% g1 = kron(eye(2),N1')*H1/(norm(kron(eye(2),N1')*H1)+0.01); 
% g2 = kron(eye(2),N2')*H2/(norm(kron(eye(2),N2')*H2)+0.01);  
% g3 = kron(eye(2),N3')*H3/(norm(kron(eye(2),N3')*H3)+0.01); 
% g4 = kron(eye(2),N4')*H4/(norm(kron(eye(2),N4')*H4)+0.01);  
% g5 = kron(eye(2),N5')*H5/(norm(kron(eye(2),N5')*H5)+0.01); 
% g6 = kron(eye(2),N6')*H6/(norm(kron(eye(2),N6')*H6)+0.01);  
% g7 = kron(eye(2),N7')*H7/(norm(kron(eye(2),N7')*H7)+0.01); 

delta1 = R1*g1;
delta2 = R2*g2;
delta3 = R3*g3;
delta4 = R4*g4;
delta5 = R5*g5;
delta6 = R6*g6;
delta7 = R7*g7;
%% 分布式观测器: Revised 修改成每个观测器，观测所有领导者的状态
rho = 2; % 要求rho > gamma 

x0 = [x01; x02];
elta1_tlide = elta1_hat - x0; elta2_tlide = elta2_hat - x0; elta3_tlide = elta3_hat - x0; elta4_tlide = elta4_hat - x0;
elta5_tlide = elta5_hat - x0; elta6_tlide = elta6_hat - x0; elta7_tlide = elta7_hat - x0;
elta_tlide = [elta1_tlide; elta2_tlide; elta3_tlide; elta4_tlide; elta5_tlide; elta6_tlide; elta7_tlide];

A0 =  blkdiag(kron(eye(2),A01),kron(eye(2),A02)); B0 =  blkdiag(kron(eye(2),B01),kron(eye(2),B02));
C0 = blkdiag(kron(eye(2),C01),kron(eye(2),C02));

% 领导者观测器的微分方程：the differential equation of the leader's observer  
d_elta_hat = kron(eye(num_F), A0)*elta_hat - rho*kron(eye(num_F),B0)*f...
             -mu*kron(LF,K0*C0)*elta_tlide;  % 考虑存在外部输入补偿项 

%% 领导者动力学方程
xLg1 = xL(1:4);     xLg2 = xL(5:end);    %领导者状态

dx01 = kron(eye(2),A01)*xLg1+kron(eye(2),B01)*u01;
dx02 = kron(eye(2),A02)*xLg2+kron(eye(2),B02)*u02;
dxL = [dx01; dx02];

%%  跟随者状态方程--控制输入
theta_bar = 2; % theta_bar >= gamma 这个数字需要跟随gamma值修改，略大于就行，不然会造成误差系统轻微震荡
% theta = gamma + rho;

u1 = kron(eye(2),K11)*x1_hat + kron(eye(2),K21)*(elta1_hat(1:4)+h1) - theta_bar*delta1+r1;
u2 = kron(eye(2),K12)*x2_hat + kron(eye(2),K22)*(elta2_hat(1:4)+h2) - theta_bar*delta2+r2;
u3 = kron(eye(2),K13)*x3_hat + kron(eye(2),K23)*(elta3_hat(1:4)+h3) - theta_bar*delta3+r3;
u4 = kron(eye(2),K14)*x4_hat + kron(eye(2),K24)*(elta4_hat(1:4)+h4) - theta_bar*delta4+r4;
u5 = kron(eye(2),K15)*x5_hat + kron(eye(2),K25)*(elta5_hat(5:end)+h5) - theta_bar*delta5+r5;
u6 = kron(eye(2),K16)*x6_hat + kron(eye(2),K26)*(elta6_hat(5:end)+h6) - theta_bar*delta6+r6;
u7 = kron(eye(2),K17)*x7_hat + kron(eye(2),K27)*(elta7_hat(5:end)+h7) - theta_bar*delta7+r7;

%% 跟随者状态方程
dx1 = kron(eye(2),A1)*x1 + kron(eye(2),B1)*u1; dx2 = kron(eye(2),A2)*x2 + kron(eye(2),B2)*u2;
dx3 = kron(eye(2),A3)*x3 + kron(eye(2),B3)*u3; dx4 = kron(eye(2),A4)*x4 + kron(eye(2),B4)*u4;

dx5 = kron(eye(2),A5)*x5 + kron(eye(2),B5)*u5; dx6 = kron(eye(2),A6)*x6 + kron(eye(2),B6)*u6;
dx7 = kron(eye(2),A7)*x7 + kron(eye(2),B7)*u7;

dxF = [dx1;dx2;dx3;dx4;dx5;dx6;dx7];

%%  设计跟随者对自身状态的Luenberger observer
y1 = kron(eye(2),C1)*x1;    y2 = kron(eye(2),C2)*x2;    y3 = kron(eye(2),C3)*x3;    y4 = kron(eye(2),C4)*x4;
y5 = kron(eye(2),C5)*x5;    y6 = kron(eye(2),C6)*x6; 	y7 = kron(eye(2),C7)*x7;

dxhat_1 = kron(eye(2),A1)*x1_hat + kron(eye(2),B1)*u1 + kron(eye(2),L01)*(kron(eye(2),C1)*x1_hat-y1);
dxhat_2 = kron(eye(2),A2)*x2_hat + kron(eye(2),B2)*u2 + kron(eye(2),L02)*(kron(eye(2),C2)*x2_hat-y2);
dxhat_3 = kron(eye(2),A3)*x3_hat + kron(eye(2),B3)*u3 + kron(eye(2),L03)*(kron(eye(2),C3)*x3_hat-y3);
dxhat_4 = kron(eye(2),A4)*x4_hat + kron(eye(2),B4)*u4 + kron(eye(2),L04)*(kron(eye(2),C4)*x4_hat-y4);
dxhat_5 = kron(eye(2),A5)*x5_hat + kron(eye(2),B5)*u5 + kron(eye(2),L05)*(kron(eye(2),C5)*x5_hat-y5);
dxhat_6 = kron(eye(2),A6)*x6_hat + kron(eye(2),B6)*u6 + kron(eye(2),L06)*(kron(eye(2),C6)*x6_hat-y6);
dxhat_7 = kron(eye(2),A7)*x7_hat + kron(eye(2),B7)*u7 + kron(eye(2),L07)*(kron(eye(2),C7)*x7_hat-y7);

dxhatF = [dxhat_1;dxhat_2;dxhat_3;dxhat_4;dxhat_5;dxhat_6;dxhat_7];

dx=[dxL;dxF;dxhatF;d_elta_hat];

% dx=[dxL];

end

