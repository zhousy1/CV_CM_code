function [ dx ] = dEqu( t,x )
%   UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N1 = 4; % 组1跟随者个数
N2 = 3; % 组2跟随者个数



%% 模型：假设各智能体在X,Y两轴方向的模型是相同的
% leaders
A01 = [1];
C01 = [1];  %小组1-leader 01

A02 = [1];
C02 = [1];  %小组2-leader 02

%%% follower --二阶         跟随者均为二阶系统--后续试验方便 group 1: 1-2-3-4 gourp 2: 5-6-7
% group 1
A1 = [0 1;-3 -3];  B1 = [0;1];
C1 = [1 0];
X1 = [ 1,1]';   U1 = [7];   % 调节器参数
K11 = [2.5 1.5];   % A1+B1*K1 是Hurwitz
K12 = [3];             
L01 = [0; 1];   % luenberger 观测器求解

A2 = [0 1;-3 -3];  B2 = [0;1];
C2 = [1 0];
X2 = [ 1,1]';   U2 = [7];  % 调节器参数
K21 = [2.5 1.5];   % A1+B1*K1 是Hurwitz
K22 = [3];             
L02 = [0; 1];   % luenberger 观测器求解

A3 = [0 1;-1 -1.2];  B3 = [0;1];
C3 = [1 0];
X3 = [ 1,1]';   U3 = [3.2];
K31 = [0.5 -0.3];   % A1+B1*K1 是Hurwitz
K32 = [3];             
L03 = [-1.8; 1.16];   % luenberger 观测器求解

A4 = [0 1;-1 -1.2];  B4 = [0;1];
C4 = [1 0];    
X4 = [ 1,1]';   U4 = [3.2];
K41 = [0.5 -0.3];   % A1+B1*K1 是Hurwitz
K42 = [3];             
L04 = [-1.8; 1.16];   % luenberger 观测器求解

% group 2
A5 = [0 1;-3 -3];  B5 = [0;1];
C5 = [1 0];
X5 = [ 1,1]';   U5 = [7];
K51 = [2.5 1.5];   % A1+B1*K1 是Hurwitz
K52 = [3];             
L05 = [0; 1];   % luenberger 观测器求解

A6 = [0 1;-3 -3];  B6 = [0;1];
C6 = [1 0];
X6 = [ 1,1]';   U6 = [7];
K61 = [2.5 1.5];   % A1+B1*K1 是Hurwitz
K62 = [3];             
L06 = [0; 1];   % luenberger 观测器求解

A7 = [0 1;-1 -1.2];  B7 = [0;1];
C7 = [1 0];   
X7 = [ 1,1]';   U7 = [3.2];  
K71 = [0.5 -0.3];   % A1+B1*K1 是Hurwitz
K72 = [3];             
L07 = [-1.8; 1.16];   % luenberger 观测器求解

%%---各变量的意义
xL = x(1:4);            %leader的状态
xLg1 = xL(1:2);         %组1领导者状态
xLg2 = xL(3:end);    %组2领导者状态

xi_hat = x(5:18);       %状态观测器的状态
xi_hatg1 = xi_hat(1:8);  %组1
xi_hatg2 = xi_hat(9:end);    %组2

xF = x(19:46);        %follower的状态 
xFg1 = xF(1:16);    % g1 follower
xFg2 = xF(17:end);  % g2 follower

xhat = x(47:end);       % 状态观测器
xhatg1 = x(1:16);       %g1 自身 观测器
xhatg2 = x(17:end);  %g2 自身 观测器

%% 分布式观测器设计: 对领导者状态z_bar的估计

z_bar = xL; %Leaders的状态
xi1_hat = xi_hatg1(1:2); xi2_hat = xi_hatg1(3:4); xi3_hat = xi_hatg1(5:6); xi4_hat = xi_hatg1(7:8);     %组1

xi5_hat = xi_hatg2(1:2); xi6_hat = xi_hatg2(3:4); xi7_hat = xi_hatg2(5:6); %各跟随者对多领导者状态的估计


S_bar = blkdiag(kron(eye(2),S1),kron(eye(2),S2),kron(eye(2),S3));

% 切换时刻
tw1 = 10; tw2 = 20; tw3 = 30; 

if t<tw1  %G3    
    % follower 4
    W4_hat = blkdiag(alpha41*eye(4),alpha42*eye(4),zeros(4,4));
    dxi4_hat = S_bar*xi4_hat-W4_hat*(xi4_hat-z_bar)-beta48*(xi4_hat-xi8_hat);

    % follower 5
    dxi5_hat = S_bar*xi5_hat-beta56*(xi5_hat-xi6_hat)-beta58*(xi5_hat-xi8_hat);
    dbeta56 = norm(xi5_hat-xi6_hat)^2;
    dbeta58 = norm(xi5_hat-xi8_hat)^2;
    
    % follower 6
    W6_hat = blkdiag(zeros(4,4),zeros(4,4),alpha63*eye(4));
    dxi6_hat = S_bar*xi6_hat-W6_hat*(xi6_hat-z_bar)-beta56*(xi6_hat-xi5_hat)-beta68*(xi6_hat-xi8_hat)-beta69*(xi6_hat-xi9_hat);
    dalpha63 = norm(xi6_hat(9:12)-z_bar(9:12))^2;
    dbeta68 = norm(xi6_hat-xi8_hat)^2;
    dbeta69 = norm(xi6_hat-xi9_hat)^2;
    
    % follower 7
    dxi7_hat = S_bar*xi7_hat-beta78*(xi7_hat-xi8_hat);
    dbeta78 = norm(xi7_hat-xi8_hat)^2;
    
    % follower 8
    dxi8_hat = S_bar*xi8_hat-beta48*(xi8_hat-xi4_hat)-beta58*(xi8_hat-xi5_hat)-beta68*(xi8_hat-xi6_hat)-beta78*(xi8_hat-xi7_hat);
    
    % follower 9
    dxi9_hat = S_bar*xi9_hat-beta69*(xi9_hat-xi6_hat);
    
    dxi_hat = [dxi4_hat;dxi5_hat;dxi6_hat;dxi7_hat;dxi8_hat;dxi9_hat];
    dalpha52 = 0; dalpha51 = 0; dalpha62 = 0;
    dalpha = [dalpha41;dalpha52;dalpha63;dalpha51;dalpha62;dalpha42];
    dbeta45 = 0; dbeta47 = 0; dbeta89 = 0;dbeta57 = 0; dbeta59 = 0;
    dbeta = [dbeta45;dbeta47;dbeta56;dbeta69;dbeta78;dbeta89;dbeta57;dbeta59;dbeta48;dbeta58;dbeta68];
       
elseif t<tw2 %G1    
    % follower 4
    W4_hat = blkdiag(alpha41*eye(4),zeros(4,4),zeros(4,4));
    dxi4_hat = S_bar*xi4_hat-W4_hat*(xi4_hat-z_bar)-beta45*(xi4_hat-xi5_hat)-beta47*(xi4_hat-xi7_hat);
    dalpha41 = norm(xi4_hat(1:4)-z_bar(1:4))^2;
    dbeta45 = norm(xi4_hat-xi5_hat)^2;
    dbeta47 = norm(xi4_hat-xi7_hat)^2;
    
    % follower 5
    W5_hat = blkdiag(zeros(4,4),alpha52*eye(4),zeros(4,4));    
    dxi5_hat = S_bar*xi5_hat-W5_hat*(xi5_hat-z_bar)-beta45*(xi5_hat-xi4_hat)-beta56*(xi5_hat-xi6_hat);
    dalpha52 = norm(xi5_hat(5:8)-z_bar(5:8))^2;    
    dbeta56 = norm(xi5_hat-xi6_hat)^2;
    
    % follower 6
    W6_hat = blkdiag(zeros(4,4),zeros(4,4),alpha63*eye(4));
    dxi6_hat = S_bar*xi6_hat-W6_hat*(xi6_hat-z_bar)-beta56*(xi6_hat-xi5_hat)-beta69*(xi6_hat-xi9_hat);
    dalpha63 = norm(xi6_hat(9:12)-z_bar(9:12))^2;
    dbeta69 = norm(xi6_hat-xi9_hat)^2;
    
    % follower 7
    dxi7_hat = S_bar*xi7_hat-beta47*(xi7_hat-xi4_hat)-beta78*(xi7_hat-xi8_hat);
    dbeta78 = norm(xi7_hat-xi8_hat)^2;
    
    % follower 8
    dxi8_hat = S_bar*xi8_hat-beta78*(xi8_hat-xi7_hat)-beta89*(xi8_hat-xi9_hat);
    dbeta89 = norm(xi8_hat-xi9_hat)^2;
    
    % follower 9
    dxi9_hat = S_bar*xi9_hat-beta69*(xi9_hat-xi6_hat)-beta89*(xi9_hat-xi8_hat);
    
    dxi_hat = [dxi4_hat;dxi5_hat;dxi6_hat;dxi7_hat;dxi8_hat;dxi9_hat];
    dalpha51 = 0; dalpha62 = 0; dalpha42 = 0;
    dalpha = [dalpha41;dalpha52;dalpha63;dalpha51;dalpha62;dalpha42];
    dbeta57 = 0; dbeta59 = 0; dbeta48 = 0; dbeta58 = 0; dbeta68 = 0;
    dbeta = [dbeta45;dbeta47;dbeta56;dbeta69;dbeta78;dbeta89;dbeta57;dbeta59;dbeta48;dbeta58;dbeta68];
    
elseif t<tw3 %G2   
    % follower 4
    dxi4_hat = S_bar*xi4_hat-beta45*(xi4_hat-xi5_hat)-beta47*(xi4_hat-xi7_hat);
    dbeta45 = norm(xi4_hat-xi5_hat)^2;
    dbeta47 = norm(xi4_hat-xi7_hat)^2;
    
    % follower 5
    W5_hat = blkdiag(alpha51*eye(4),zeros(4,4),zeros(4,4));    
    dxi5_hat = S_bar*xi5_hat-W5_hat*(xi5_hat-z_bar)-beta45*(xi5_hat-xi4_hat)-beta57*(xi5_hat-xi7_hat)-beta59*(xi5_hat-xi9_hat);
    dalpha51 = norm(xi5_hat(1:4)-z_bar(1:4))^2;    
    dbeta57 = norm(xi5_hat-xi7_hat)^2;
    dbeta59 = norm(xi5_hat-xi9_hat)^2;
    
    % follower 6
    W6_hat = blkdiag(zeros(4,4),alpha62*eye(4),alpha63*eye(4));
    dxi6_hat = S_bar*xi6_hat-W6_hat*(xi6_hat-z_bar)-beta69*(xi6_hat-xi9_hat);
    dalpha62 = norm(xi6_hat(5:8)-z_bar(5:8))^2;
    dalpha63 = norm(xi6_hat(9:12)-z_bar(9:12))^2;
    dbeta69 = norm(xi6_hat-xi9_hat)^2;
    
    % follower 7
    dxi7_hat = S_bar*xi7_hat-beta47*(xi7_hat-xi4_hat)-beta57*(xi7_hat-xi5_hat);
    
    % follower 8
    dxi8_hat = S_bar*xi8_hat-beta89*(xi8_hat-xi9_hat);
    dbeta89 = norm(xi8_hat-xi9_hat)^2;
    
    % follower 9
    dxi9_hat = S_bar*xi9_hat-beta59*(xi9_hat-xi5_hat)-beta69*(xi9_hat-xi6_hat)-beta89*(xi9_hat-xi8_hat);
    
    dxi_hat = [dxi4_hat;dxi5_hat;dxi6_hat;dxi7_hat;dxi8_hat;dxi9_hat];
    dalpha41=0; dalpha52=0; dalpha42=0;
    dalpha = [dalpha41;dalpha52;dalpha63;dalpha51;dalpha62;dalpha42];
    dbeta56=0; dbeta78=0; dbeta48=0; dbeta58=0; dbeta68=0;
    dbeta = [dbeta45;dbeta47;dbeta56;dbeta69;dbeta78;dbeta89;dbeta57;dbeta59;dbeta48;dbeta58;dbeta68];
        
else %G1
    % follower 4
    W4_hat = blkdiag(alpha41*eye(4),zeros(4,4),zeros(4,4));
    dxi4_hat = S_bar*xi4_hat-W4_hat*(xi4_hat-z_bar)-beta45*(xi4_hat-xi5_hat)-beta47*(xi4_hat-xi7_hat);
    dalpha41 = norm(xi4_hat(1:4)-z_bar(1:4))^2;
    dbeta45 = norm(xi4_hat-xi5_hat)^2;
    dbeta47 = norm(xi4_hat-xi7_hat)^2;
    
    % follower 5
    W5_hat = blkdiag(zeros(4,4),alpha52*eye(4),zeros(4,4));    
    dxi5_hat = S_bar*xi5_hat-W5_hat*(xi5_hat-z_bar)-beta45*(xi5_hat-xi4_hat)-beta56*(xi5_hat-xi6_hat);
    dalpha52 = norm(xi5_hat(5:8)-z_bar(5:8))^2;    
    dbeta56 = norm(xi5_hat-xi6_hat)^2;
    
    % follower 6
    W6_hat = blkdiag(zeros(4,4),zeros(4,4),alpha63*eye(4));
    dxi6_hat = S_bar*xi6_hat-W6_hat*(xi6_hat-z_bar)-beta56*(xi6_hat-xi5_hat)-beta69*(xi6_hat-xi9_hat);
    dalpha63 = norm(xi6_hat(9:12)-z_bar(9:12))^2;
    dbeta69 = norm(xi6_hat-xi9_hat)^2;
    
    % follower 7
    dxi7_hat = S_bar*xi7_hat-beta47*(xi7_hat-xi4_hat)-beta78*(xi7_hat-xi8_hat);
    dbeta78 = norm(xi7_hat-xi8_hat)^2;
    
    % follower 8
    dxi8_hat = S_bar*xi8_hat-beta78*(xi8_hat-xi7_hat)-beta89*(xi8_hat-xi9_hat);
    dbeta89 = norm(xi8_hat-xi9_hat)^2;
    
    % follower 9
    dxi9_hat = S_bar*xi9_hat-beta69*(xi9_hat-xi6_hat)-beta89*(xi9_hat-xi8_hat);
    
    dxi_hat = [dxi4_hat;dxi5_hat;dxi6_hat;dxi7_hat;dxi8_hat;dxi9_hat];
    dalpha51 = 0; dalpha62 = 0; dalpha42 = 0;
    dalpha = [dalpha41;dalpha52;dalpha63;dalpha51;dalpha62;dalpha42];
    dbeta57 = 0; dbeta59 = 0; dbeta48 = 0; dbeta58 = 0; dbeta68 = 0;
    dbeta = [dbeta45;dbeta47;dbeta56;dbeta69;dbeta78;dbeta89;dbeta57;dbeta59;dbeta48;dbeta58;dbeta68];    
    
end


%% 各智能体微分方程
x1=xL(1:4); x2=xL(5:8); x3=xL(9:12); %leaders

% 领导者动力学
dx1 = kron(eye(2),S1)*x1;
dx2 = kron(eye(2),S2)*x2;
dx3 = kron(eye(2),S3)*x3;

dxL = [dx1;dx2;dx3];

% 跟随者状态：4*3+6*3；以及估计状态
x4 = xF(1:4); x5 = xF(5:8); x6 = xF(9:12); %二阶
x7 = xF(13:18); x8 = xF(19:24); x9 = xF(25:30); %三阶
% 估计状态x_hat
xhat_4 = xhat(1:4); xhat_5 = xhat(5:8); xhat_6 = xhat(9:12);
xhat_7 = xhat(13:18); xhat_8 = xhat(19:24); xhat_9 = xhat(25:30);

% 期望的合围定义
rho41 = 1/6; rho42 = 1/3; rho43 = 1/2;
rho51 = 1/3; rho52 = 1/2; rho53 = 1/6;
rho61 = 1/2; rho62 = 1/6; rho63 = 1/3;
rho71 = 1/3; rho72 = 1/3; rho73 = 1/3;
rho81 = 1/5; rho82 = 2/5; rho83 = 2/5;
rho91 = 2/3; rho92 = 1/4; rho93 = 1/12;

% follower 4
K2_41 = U41-K1_4*X41;
K2_42 = U42-K1_4*X42;
K2_43 = U43-K1_4*X43;
u4 = kron(eye(2),K1_4)*xhat_4+rho41*kron(eye(2),K2_41)*xi4_hat(1:4)...
    +rho42*kron(eye(2),K2_42)*xi4_hat(5:8)+rho43*kron(eye(2),K2_43)*xi4_hat(9:12);

% follower 5
K2_51 = U51-K1_5*X51;
K2_52 = U52-K1_5*X52;
K2_53 = U53-K1_5*X53;
u5 = kron(eye(2),K1_5)*xhat_5+rho51*kron(eye(2),K2_51)*xi5_hat(1:4)...
    +rho52*kron(eye(2),K2_52)*xi5_hat(5:8)+rho53*kron(eye(2),K2_53)*xi5_hat(9:12);

% follower 6
K2_61 = U61-K1_6*X61;
K2_62 = U62-K1_6*X62;
K2_63 = U63-K1_6*X63;
u6 = kron(eye(2),K1_6)*xhat_6+rho61*kron(eye(2),K2_61)*xi6_hat(1:4)...
    +rho62*kron(eye(2),K2_62)*xi6_hat(5:8)+rho63*kron(eye(2),K2_63)*xi6_hat(9:12);

% follower 7
K2_71 = U71-K1_7*X71;
K2_72 = U72-K1_7*X72;
K2_73 = U73-K1_7*X73;
u7 = kron(eye(2),K1_7)*xhat_7+rho71*kron(eye(2),K2_71)*xi7_hat(1:4)...
    +rho72*kron(eye(2),K2_72)*xi7_hat(5:8)+rho73*kron(eye(2),K2_73)*xi7_hat(9:12);

% follower 8
K2_81 = U81-K1_8*X81;
K2_82 = U82-K1_8*X82;
K2_83 = U83-K1_8*X83;
u8 = kron(eye(2),K1_8)*xhat_8+rho81*kron(eye(2),K2_81)*xi8_hat(1:4)...
    +rho82*kron(eye(2),K2_82)*xi8_hat(5:8)+rho83*kron(eye(2),K2_83)*xi8_hat(9:12);

% follower 9
K2_91 = U91-K1_9*X91;
K2_92 = U92-K1_9*X92;
K2_93 = U93-K1_9*X93;
u9 = kron(eye(2),K1_9)*xhat_9+rho91*kron(eye(2),K2_91)*xi9_hat(1:4)...
    +rho92*kron(eye(2),K2_92)*xi9_hat(5:8)+rho93*kron(eye(2),K2_93)*xi9_hat(9:12);

% 跟随者状态方程
dx4 = kron(eye(2),A4)*x4 + kron(eye(2),B4)*u4;
dx5 = kron(eye(2),A5)*x5 + kron(eye(2),B5)*u5;
dx6 = kron(eye(2),A6)*x6 + kron(eye(2),B6)*u6;
dx7 = kron(eye(2),A7)*x7 + kron(eye(2),B7)*u7;
dx8 = kron(eye(2),A8)*x8 + kron(eye(2),B8)*u8;
dx9 = kron(eye(2),A9)*x9 + kron(eye(2),B9)*u9;

dxF = [dx4;dx5;dx6;dx7;dx8;dx9];

%%  设计跟随者对自身状态的Luenberger observer
y4 = x4(1:2:3); y5 = x5(1:2:3); y6 = x6(1:2:3);
y7 = x7(1:3:4); y8 = x8(1:3:4); y9 = x9(1:3:4);

dxhat_4 = kron(eye(2),A4)*xhat_4 + kron(eye(2),B4)*u4 + kron(eye(2),Lo_4)*(kron(eye(2),C4)*xhat_4-y4);
dxhat_5 = kron(eye(2),A5)*xhat_5 + kron(eye(2),B5)*u5 + kron(eye(2),Lo_5)*(kron(eye(2),C5)*xhat_5-y5);
dxhat_6 = kron(eye(2),A6)*xhat_6 + kron(eye(2),B6)*u6 + kron(eye(2),Lo_6)*(kron(eye(2),C6)*xhat_6-y6);
dxhat_7 = kron(eye(2),A7)*xhat_7 + kron(eye(2),B7)*u7 + kron(eye(2),Lo_7)*(kron(eye(2),C7)*xhat_7-y7);
dxhat_8 = kron(eye(2),A8)*xhat_8 + kron(eye(2),B8)*u8 + kron(eye(2),Lo_8)*(kron(eye(2),C8)*xhat_8-y8);
dxhat_9 = kron(eye(2),A9)*xhat_9 + kron(eye(2),B9)*u9 + kron(eye(2),Lo_9)*(kron(eye(2),C9)*xhat_9-y9);

dxhatF = [dxhat_4;dxhat_5;dxhat_6;dxhat_7;dxhat_8;dxhat_9];

dx=[dxL;dxi_hat;dalpha;dbeta;dxF;dxhatF];


end

