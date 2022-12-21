%% 编队可行性条件-编队补偿项 r的计算
%   Bhat_i*Xi*(A0*hix-dhix)=0
%   XiAihix-Xidhix+Biri=0
%   Bhat_i*Bi=0; Bbar_i*Bi=ones(mi)

%% 系统设置  模型：假设在X,Y两轴方向的模型是相同的
%% 系统设置  模型：假设在X,Y两轴方向的模型是相同的
% leaders
A01 = [0 1; 0 0];   B01 = [0 1]';  C01 = [1 0];  %小组1-leader 01
A02 = [0 1; -0.1 -0.1]; B02 = [0 1]';  C02 = [1 0];  %小组2-leader 02

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

X5 = [1 0;0 1]; U5=[0.9 0.9]; R5 = [1];
X6 = [1 0;0 1]; U6=[0.9 0.9]; R6 = [1];
X7 = [1 0;0 1]; U7=[1.9 1.9]; R7 = [1];

%% 给出编队项
syms t

h1 = [15*sin(t+(1-1)*pi/2);     15*cos(t+(1-1)*pi/2);  15*cos(t+(1-1)*pi/2);    -15*sin(t+(1-1)*pi/2)];
h2 = [15*sin(t+(2-1)*pi/2);     15*cos(t+(2-1)*pi/2);  15*cos(t+(2-1)*pi/2);    -15*sin(t+(2-1)*pi/2)];
h3 = [15*sin(t+(3-1)*pi/2);     15*cos(t+(3-1)*pi/2);  15*cos(t+(3-1)*pi/2);    -15*sin(t+(3-1)*pi/2)];
h4 = [15*sin(t+(4-1)*pi/2);     15*cos(t+(4-1)*pi/2);  15*cos(t+(4-1)*pi/2);    -15*sin(t+(4-1)*pi/2)];

h5 = [5*sin(t+(1-1)*2*pi/3);     5*cos(t+(1-1)*2*pi/3);  5*cos(t+(1-1)*2*pi/3);    -5*sin(t+(1-1)*2*pi/3)];
h6 = [5*sin(t+(2-1)*2*pi/3);     5*cos(t+(2-1)*2*pi/3);  5*cos(t+(2-1)*2*pi/3);    -5*sin(t+(2-1)*2*pi/3)];
h7 = [5*sin(t+(3-1)*2*pi/3);     5*cos(t+(3-1)*2*pi/3);  5*cos(t+(3-1)*2*pi/3);    -5*sin(t+(3-1)*2*pi/3)];

h = [h1;h2;h3;h4;h5;h6;h7];
dh1 = diff(h1); dh2 = diff(h2); dh3 = diff(h3); dh4 = diff(h4);
dh5 = diff(h5); dh6 = diff(h6); dh7 = diff(h7);

%% 编队可行性条件
kron(eye(2), B1_hat*X1)*(kron(eye(2),A01)*h1-dh1) == 0
kron(eye(2), B2_hat*X2)*(kron(eye(2),A01)*h2-dh2) == 0
kron(eye(2), B3_hat*X3)*(kron(eye(2),A01)*h3-dh3) == 0
kron(eye(2), B4_hat*X4)*(kron(eye(2),A01)*h4-dh4) == 0
kron(eye(2), B5_hat*X5)*(kron(eye(2),A02)*h5-dh5) == 0
kron(eye(2), B6_hat*X6)*(kron(eye(2),A02)*h6-dh6) == 0
kron(eye(2), B7_hat*X7)*(kron(eye(2),A02)*h7-dh7) == 0
%%
r1 = -kron(eye(2),B1_bar*X1)*(kron(eye(2),A01)*h1-dh1)
r2 = -kron(eye(2),B2_bar*X2)*(kron(eye(2),A01)*h2-dh2)
r3 = -kron(eye(2),B3_bar*X3)*(kron(eye(2),A01)*h3-dh3)
r4 = -kron(eye(2),B4_bar*X4)*(kron(eye(2),A01)*h4-dh4)
r5 = -kron(eye(2),B5_bar*X5)*(kron(eye(2),A02)*h5-dh5)
r6 = -kron(eye(2),B6_bar*X6)*(kron(eye(2),A02)*h6-dh6)
r7 = -kron(eye(2),B7_bar*X7)*(kron(eye(2),A02)*h7-dh7)


% r1=[-15*sin(t);-15*cos(t)
% r2 = [-15*sin(t + pi/2); -15*cos(t + pi/2)];
% r3 = [0; 0];
% r4 = [0; 0];
% r5 = [-5*sin(t); -5*cos(t)];
% r6 = [-5*sin(t + (2*pi)/3); -5*cos(t + (2*pi)/3)]
% r7 = [-5*sin(t + (4*pi)/3); -5*cos(t + (4*pi)/3)]





