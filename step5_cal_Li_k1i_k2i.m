%% 系统设置  模型：假设在X,Y两轴方向的模型是相同的
%% state function
% leaders
A01 = [0 1; 0 0];   B01 = [0 1]';    C01 = [1 0];  %小组1-leader 01
A02 = [0 1; -0.01 -0.01]; B02 = [0 1]';  C02 = [1 0];  %小组2-leader 02

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
%% 计算B_bar 与B_hat
% group 1
B1_bar=[0 1]; B1_hat=[1 0];
B2_bar=[0 1]; B2_hat=[1 0];
B3_bar=[1]; B3_hat=[0]; 
B4_bar=[1]; B4_hat=[0];

% group 2
B5_bar=[0 1]; B5_hat=[1 0];
B6_bar=[0 1]; B6_hat=[1 0];
B7_bar=[0 1]; B7_hat=[1 0];

%% 调节器参数
X1 = [1 0;0 1]; U1=[3 3]; R1 = [1];
X2 = [1 0;0 1]; U2=[3 3]; R2 = [1];
X3 = [1 0]; U3=[0 1]; R3 = [0];
X4 = [1 0]; U4=[0 1]; R4 = [0];

X5 = [1 0;0 1]; U5=[0.999 0.999]; R5 = [1];
X6 = [1 0;0 1]; U6=[0.999 0.999]; R6 = [1];
X7 = [1 0;0 1]; U7=[1.999 1.999]; R7 = [1];

%% Luenberger 观测器
L01 = -place(A1', C1', [-1; -2])';
L02 =  -place(A2', C2', [-1; -2])';
L03 =  -place(A3', C3', [-1])';
L04 =  -place(A4', C4', [-1])';

L05 =  -place(A5', C5', [-1; -2])';
L06 =  -place(A6', C6', [-1; -2])';
L07 =  -place(A7', C7', [-1; -2])';

%% 控制率中反馈增益 K1i  K2i  
K11 = -place(A1,B1, [-0.5  -1]);    K21 = U1-K11*X1;
K12 = -place(A2,B2, [-0.5  -1]);    K22 = U2-K12*X2;
K13 = -place(A3,B3, [-1]);          K23 = U3-K13*X3;
K14 = -place(A4,B4, [-1]);          K24 = U4-K14*X4;

K15 = -place(A5,B5, [-0.5  -1]);    K25 = U5-K15*X5;
K16 = -place(A6,B6, [-0.5  -1]);    K26 = U6-K16*X6;
K17 = -place(A7,B7, [-0.5  -1]);    K27 = U7-K17*X7;

%% 求解 K3i
P1 = 2*eye(2);
M1 = lyap((A1+B1*K11)', P1);
K31 = B1_bar*inv(M1)*(A1+B1*K11)'

P2 = 2*eye(2);
M2 = lyap((A2+B2*K12)', P2);
K32 = B2_bar*inv(M2)*(A2+B2*K12)'
 
P3 = 2*eye(1);
M3 = lyap((A3+B3*K13)', P3);
K33 = B3_bar*inv(M3)*(A3+B3*K13)'

P4 = 2*eye(1);
M4 = lyap((A4+B4*K14)', P4);
K34 = B4_bar*inv(M4)*(A4+B4*K14)'

P5 = 2*eye(2);
M5 = lyap((A5+B5*K15)', P5);
K35 = B5_bar*inv(M5)*(A5+B5*K15)'

P6 = 2*eye(2);
M6 = lyap((A6+B6*K16)', P6);
K36 = B6_bar*inv(M6)*(A6+B6*K16)'

P7 = 2*eye(2);
M7 = lyap((A7+B7*K17)', P7);
K37 = B7_bar*inv(M7)*(A7+B7*K17)'

K
