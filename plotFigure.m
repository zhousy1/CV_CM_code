%% 仿真数据的处理
xL = zout(:,1:8); %领导者状态

% plot(xL(:,1),xL(:,3))
% hold on
% plot(xL(:,5),xL(:,7))


xF = zout(:,9:32); %跟随者状态
xhat = zout(:,33:56);
elta_hat = zout(:,57:end); %各跟随者对多领导者状态的分布式估计


x01=xL(:,1:4); x02=xL(:,5:8);  %leaders 状态
yout01= x01(:,[1 3]); yout02=x02(:,[1 3]);  %leaders 输出 X轴、Y轴

%所有跟随者的状态; 
xout1 = xF(:,1:4); xout2 = xF(:,5:8); 
xout3 = xF(:,9:10); xout4 = xF(:,11:12); 
xout5 = xF(:,13:16); xout6 = xF(:,17:20);    
xout7 = xF(:,21:24); 

% 跟随者的输出
yout1 = xout1(:,[1 3]); yout2 = xout2(:,[1 3]); yout3 = xout3; yout4 = xout4; 
yout5 = xout5(:,[1 3]); yout6 = xout6(:,[1 3]); yout7 = xout7(:,[1 3]); 

% 指定时刻的截图
t_g = 50; %绘图时刻
t = tout;
n = length(t(t<t_g))+1;
%编队向量
h1= [15*sin(tout+(1-1)*pi/2)  15*cos(tout+(1-1)*pi/2)];
h2= [15*sin(tout+(2-1)*pi/2)  15*cos(tout+(2-1)*pi/2)];
h3= [15*sin(tout+(3-1)*pi/2)  15*cos(tout+(3-1)*pi/2)];
h4= [15*sin(tout+(4-1)*pi/2)  15*cos(tout+(4-1)*pi/2)];

h5= [5*sin(tout+(1-1)*2*pi/3)  5*cos(tout+(1-1)*2*pi/3)];
h6= [5*sin(tout+(2-1)*2*pi/3)  5*cos(tout+(2-1)*2*pi/3)];
h7= [5*sin(tout+(3-1)*2*pi/3)  5*cos(tout+(3-1)*2*pi/3)];

%%势场函数参数
D_cv_min=0.60;
D_cm_max=42;
%% 系统的状态，三维图，二维图
figure(5)
tt=[1,n];
t_p=length(tt);
color_g1 = ['r','g'];
color_g2 = ['b','y'];
% 各个集群Z轴的高度: 单位米
zout01 = 5;
zout02 = 5;
zout1 = 10;
zout2 = 10;
zout3 = 0;
zout4 = 0;
zout5 = 20;
zout6 = 20;
zout7 = 20;

for i=1:t_p
    plot3(yout01(tt(i),1),yout01(tt(i),2),zout01,'*r','MarkerSize',8,'LineWidth',1.5); %leader 1
    hold on;
    plot3(yout02(tt(i),1),yout02(tt(i),2),zout02,'*b','MarkerSize',8,'LineWidth',1.5); %leader 2
    plot3(yout1(tt(i),1),yout1(tt(i),2),zout1,'sr','MarkerSize',8,'LineWidth',1.5); %follower 1
    plot3(yout2(tt(i),1),yout2(tt(i),2),zout2,'sr','MarkerSize',8,'LineWidth',1.5); %follower 2
    plot3(yout3(tt(i),1),yout3(tt(i),2),zout3,'sr','MarkerSize',8,'LineWidth',1.5); %follower 3
    plot3(yout4(tt(i),1),yout4(tt(i),2),zout4,'sr','MarkerSize',8,'LineWidth',1.5); %follower 4
    
    plot3(yout5(tt(i),1),yout5(tt(i),2),zout5,'ob','MarkerSize',8,'LineWidth',1.5); %follower 5
    plot3(yout6(tt(i),1),yout6(tt(i),2),zout6,'ob','MarkerSize',8,'LineWidth',1.5); %follower 6
    plot3(yout7(tt(i),1),yout7(tt(i),2),zout7,'ob','MarkerSize',8,'LineWidth',1.5); %follower 7

    yfg1 = [yout1(tt(i),:) zout1; yout2(tt(i),:) zout2; yout3(tt(i),:) zout3; yout4(tt(i),:) zout4; yout1(tt(i),:) zout1];
    yfg2 = [yout5(tt(i),:) zout5;yout6(tt(i),:) zout6;yout7(tt(i),:) zout7;yout5(tt(i),:) zout5];
    
    plot3(yfg1(:,1),yfg1(:,2),yfg1(:,3),'-r','LineWidth',1); %画出各Follower之间的连线
    plot3(yfg2(:,1),yfg2(:,2),yfg2(:,3),'-b','LineWidth',1); %画出各Follower之间的连线
    grid on;   
    xlabel('$X/m$','interpreter','latex','FontName','Times New Roman','FontSize',14);
    ylabel('$Y/m$','interpreter','latex','FontName','Times New Roman','FontSize',14);
    zlabel('$Z/m$','interpreter','latex','FontName','Times New Roman','FontSize',14);

end


%%绘制整个运动轨迹

plot3(yout01(:,1),yout01(:,2),zout01*ones(n,1), '--r','LineWidth',1.5); %leader 1  
hold on;
plot3(yout02(:,1),yout02(:,2),zout02*ones(n,1),'--b','LineWidth',1.5); %leader 2

plot3(yout1(:,1),yout1(:,2),zout1*ones(n,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 1
plot3(yout2(:,1),yout2(:,2),zout2*ones(n,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 2
plot3(yout3(:,1),yout3(:,2),zout3*ones(n,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 3
plot3(yout4(:,1),yout4(:,2),zout4*ones(n,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 4

plot3(yout5(:,1),yout5(:,2),zout5*ones(n,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 5
plot3(yout6(:,1),yout6(:,2),zout6*ones(n,1),'--g','color',[0.6,0.6,0.6],'LineWidth',1); %follower 6
plot3(yout7(:,1),yout7(:,2),zout7*ones(n,1),'--g','color',[0.6,0.6,0.6],'LineWidth',1); %follower 7
grid on;  

view(2) 
axis equal

%% 

% %% 集群个体之间的距离--测试人工势场函数的有效性
% %%i-j之间的距离计算 

%%%组1
% dist12 = yout1-yout2; dist13 = yout1-yout3 ;dist14 = yout1-yout4;
% dist23 = yout2-yout3;  dist24 = yout2-yout4 ;
% dist34 = yout3-yout4;
% 
% dist12_norm = zeros(length(tout),1); 
% dist13_norm = zeros(length(tout),1); 
% dist14_norm = zeros(length(tout),1); 
% dist23_norm = zeros(length(tout),1); 
% dist24_norm = zeros(length(tout),1); 
% dist34_norm = zeros(length(tout),1); 
% 
% %%%组2
% dist56 = yout5-yout6;  dist57 = yout5-yout7 ;
% dist67 = yout6-yout7;
% 
% dist56_norm = zeros(length(tout),1); 
% dist57_norm = zeros(length(tout),1); 
% dist67_norm = zeros(length(tout),1); 
% 
% for i=1:length(tout)
%     dist12_norm(i) = norm(dist12(i,:));
%     dist13_norm(i) = norm(dist13(i,:));
%     dist14_norm(i) = norm(dist14(i,:));
%     dist23_norm(i) = norm(dist23(i,:));
%     dist24_norm(i) = norm(dist24(i,:));
%     dist34_norm(i) = norm(dist34(i,:));
%     dist56_norm(i) = norm(dist56(i,:));
%     dist57_norm(i) = norm(dist57(i,:));
%     dist67_norm(i) = norm(dist67(i,:));
% end
% 
% figure
% plot(tout,D_cv_min*ones(n,1),'--k', tout, D_cm_max*ones(n,1),'--r','LineWidth',1.2); % 画出上下界
% hold on
% 
% plot(tout,dist12_norm,'b',tout,dist13_norm,'c',tout,dist14_norm,'g',...
%     tout,dist23_norm,'k',tout,dist24_norm,'m',tout,dist34_norm,'r','LineWidth',1);  % 画出个体之间的距离
% 
% legend('$d_{ca,min}$','$d_{cm,max}$','$d_{12}$','$d_{13}$','$d_{14}$','$d_{23}$','$d_{24}$','$d_{34}$','interpreter','latex','Location','northeast');
% grid on
% xlabel('$t/s$','interpreter','latex','FontName','Times New Roman','FontSize',14);
% ylabel('$\left\| {{d_{ij}}\left( t \right)} \right\|$', 'interpreter','latex','FontName','Times New Roman','FontSize',14);
% max(dist13_norm)
% 
% min(dist57_norm)
% % min(dist56_norm)
% figure
% plot(tout,D_cv_min*ones(n,1),'--k','LineWidth',1); % 因为没达到上界，画出下界
% hold on
% 
% plot(tout,dist56_norm,'b',tout,dist57_norm,'c',tout,dist67_norm,'g',...
%     'LineWidth',1);  % 画出个体之间的距离
% 
% legend('$d_{cv,min}$','$d_{56}$','$d_{57}$','$d_{67}$','interpreter','latex','Location','northeast');
% xlabel('$t/s$','interpreter','latex','FontName','Times New Roman','FontSize',14);
% ylabel('$\left\| {{d_{ij}}\left( t \right)} \right\|$', 'interpreter','latex','FontName','Times New Roman','FontSize',14);
% grid on

% %% 领导者状态观测器误差，x01,x02的估计误差
eltag1_hat = elta_hat(:,1:32);
eltag2_hat = elta_hat(:,33:end);
%组1 group 1
elta1_hat = eltag1_hat(:,1:8); 
elta2_hat = eltag1_hat(:,9:16); 
elta3_hat = eltag1_hat(:,17:24); 
elta4_hat = eltag1_hat(:,25:32); 
%组2
elta5_hat = eltag2_hat(:,1:8); 
elta6_hat = eltag2_hat(:,9:16);   
elta7_hat = eltag2_hat(:,17:24);

elta1_e = elta1_hat(:,1:4) - x01; %对领导者状态的估计误差
elta2_e = elta2_hat(:,1:4) - x01;
elta3_e = elta3_hat(:,1:4) - x01;
elta4_e = elta4_hat(:,1:4) - x01;

elta5_e = elta5_hat(:,5:end) - x02;
elta6_e = elta6_hat(:,5:end) - x02;
elta7_e = elta7_hat(:,5:end) - x02;

elta1_norm = zeros(length(tout),1); elta2_norm = zeros(length(tout),1); elta3_norm = zeros(length(tout),1); elta4_norm = zeros(length(tout),1); 
elta5_norm = zeros(length(tout),1); elta6_norm = zeros(length(tout),1); elta7_norm = zeros(length(tout),1); 
for i=1:length(tout)
    elta1_norm(i) = norm(elta1_e(i,:));
    elta2_norm(i) = norm(elta2_e(i,:));
    elta3_norm(i) = norm(elta3_e(i,:));
    elta4_norm(i) = norm(elta4_e(i,:));
    elta5_norm(i) = norm(elta5_e(i,:));
    elta6_norm(i) = norm(elta6_e(i,:));
    elta7_norm(i) = norm(elta7_e(i,:));
end

figure(2) %状态观测器误差
plot(tout,elta1_norm,'b',tout,elta2_norm,'--c',tout,elta3_norm,':r',tout,elta4_norm,'-.b',tout,elta5_norm,'m-.',...
    tout,elta6_norm,'k', tout,elta7_norm,'--g','LineWidth',1);
legend('follower 1','follower 2','follower 3','follower 4','follower 5','follower 6','follower 7','Location','northeast');
%legend('follower 1','跟随者 2','跟随者 3','跟随者 4','跟随者 5','跟随者 6','跟随者 7','Location','northeast');
xlabel('$t/s$','interpreter','latex','FontName','Times New Roman','FontSize',14);
ylabel('$\left\| {{{\hat \eta }_i}} \right\|$', 'interpreter','latex','FontName','Times New Roman','FontSize',14);
grid on;



%% Figure 2:输出编队跟踪误差
eout1 = yout1-yout01-h1;
eout2 = yout2-yout01-h2;
eout3 = yout3-yout01-h3;
eout4 = yout4-yout01-h4;

eout5 = yout5-yout02-h5;
eout6 = yout6-yout02-h6;
eout7 = yout7-yout02-h7;

eout1_norm = zeros(length(tout),1); eout2_norm = zeros(length(tout),1); eout3_norm = zeros(length(tout),1); eout4_norm = zeros(length(tout),1); 
eout5_norm = zeros(length(tout),1); eout6_norm = zeros(length(tout),1); eout7_norm = zeros(length(tout),1); 

for i=1:length(tout)
    eout1_norm(i) = norm(eout1(i,:));
    eout2_norm(i) = norm(eout2(i,:));
    eout3_norm(i) = norm(eout3(i,:));
    eout4_norm(i) = norm(eout4(i,:));
    eout5_norm(i) = norm(eout5(i,:));
    eout6_norm(i) = norm(eout6(i,:));
    eout7_norm(i) = norm(eout7(i,:));
end

figure(3) %输出编队跟踪误差
plot(tout,eout1_norm,'b',tout,eout2_norm,'--c',tout,eout3_norm,':r',tout,eout4_norm,'-.b',tout,eout5_norm,'m-.',...
    tout,eout6_norm,'k', tout,eout7_norm,'--g','LineWidth',1.5);
legend('follower 1','follower 2','follower 3','follower 4','follower 5','follower 6','follower 7','Location','northeast');
%legend('跟随者 1','跟随者 2','跟随者 3','跟随者 4','跟随者 5','跟随者 6','跟随者 7','Location','northeast');
xlabel('$t/s$','interpreter','latex','FontName','Times New Roman','FontSize',14);
ylabel('$\left\| {{{\tilde y}_{Ci}}(t)} \right\|$','interpreter','latex','FontName','Times New Roman','FontSize',14);
grid on;


    
%% 对自身状态xj的估计误差

x1_hat = xhat(:,1:4); 
x2_hat = xhat(:,5:8); 
x3_hat = xhat(:,9:10); 
x4_hat = xhat(:,11:12); 
x5_hat = xhat(:,13:16); 
x6_hat = xhat(:,17:20);   
x7_hat = xhat(:,21:24);

x1_e = x1_hat - xout1; %对领导者状态的估计误差
x2_e = x2_hat - xout2;
x3_e = x3_hat - xout3;
x4_e = x4_hat - xout4;
x5_e = x5_hat - xout5;
x6_e = x6_hat - xout6;
x7_e = x7_hat - xout7;

x1e_norm = zeros(length(tout),1); x2e_norm = zeros(length(tout),1); x3e_norm = zeros(length(tout),1); x4e_norm = zeros(length(tout),1); 
x5e_norm = zeros(length(tout),1); x6e_norm = zeros(length(tout),1); x7e_norm = zeros(length(tout),1); 
for i=1:length(tout)
    x1e_norm(i) = norm(x1_e(i,:));
    x2e_norm(i) = norm(x2_e(i,:));
    x3e_norm(i) = norm(x3_e(i,:));
    x4e_norm(i) = norm(x4_e(i,:));
    x5e_norm(i) = norm(x5_e(i,:));
    x6e_norm(i) = norm(x6_e(i,:));
    x7e_norm(i) = norm(x7_e(i,:));
end

figure(6) 
plot(tout,x1e_norm,'b',tout,x2e_norm,'--c',tout,x3e_norm,':r',tout,x4e_norm,'-.b',tout,x5e_norm,'m-.',...
    tout,x6e_norm,'k', tout,x7e_norm,'--g','LineWidth',1);
legend('follower 1','follower 2','follower 3','follower 4','follower 5','follower 6','follower 7','Location','northeast');
%legend('跟随者 1','跟随者 2','跟随者 3','跟随者 4','跟随者 5','跟随者 6','跟随者 7','Location','northeast');
xlabel('$t/s$','interpreter','latex','FontName','Times New Roman','FontSize',14);
ylabel('$\left\| {{e_{xi}}} \right\|$', 'interpreter','latex','FontName','Times New Roman','FontSize',14);
grid on;
