%%  Processing simulation data
xL = zout(:,1:8); %领导者状态
elta_hat = zout(:,9:36); %各跟随者对多领导者状态的分布式估计
xF = zout(:,37:60); %跟随者状态
xhat = zout(:,61:84);
gamma_hat = zout(:,85:end);

x01=xL(:,1:4); x02=xL(:,5:8);  %leaders 状态
yout01= x01(:,[1 3]); yout02=x02(:,[1 3]);  %leaders 输出 X轴、Y轴

%所有跟随者的状态; 
xout1 = xF(:,1:4); xout2 = xF(:,5:8); xout3 = xF(:,9:10); xout4 = xF(:,11:12); %二阶 
xout5 = xF(:,13:16); xout6 = xF(:,17:20);    xout7 = xF(:,21:24); %三阶
% 跟随者的输出
yout1 = xout1(:,[1 3]); yout2 = xout2(:,[1 3]); yout3 = xout3; yout4 = xout4; 
yout5 = xout5(:,[1 3]); yout6 = xout6(:,[1 3]); yout7 = xout7(:,[1 3]); 



%%  Dynamic figure painting

figure();
k = 1;
length_t = length(tout);

for nn =1: 5: length_t
    
    % height
    zout01 = 5;
    zout02 = 5;
    zout1 = 10;
    zout2 = 10;
    zout3 = 0;
    zout4 = 0;
    zout5 = 20;
    zout6 = 20;
    zout7 = 20;
    
    plot3(yout01(nn,1),yout01(nn,2),zout01,'*r','MarkerSize',8,'LineWidth',1.5); %leader 1
    hold on;
    plot3(yout02(nn,1),yout02(nn,2),zout02,'*b','MarkerSize',8,'LineWidth',1.5); %leader 2
    plot3(yout1(nn,1),yout1(nn,2),zout1,'sr','MarkerSize',8,'LineWidth',1.5); %follower 1
    plot3(yout2(nn,1),yout2(nn,2),zout2,'sr','MarkerSize',8,'LineWidth',1.5); %follower 2
    plot3(yout3(nn,1),yout3(nn,2),zout3,'sr','MarkerSize',8,'LineWidth',1.5); %follower 3
    plot3(yout4(nn,1),yout4(nn,2),zout4,'sr','MarkerSize',8,'LineWidth',1.5); %follower 4
    
    plot3(yout5(nn,1),yout5(nn,2),zout5,'ob','MarkerSize',8,'LineWidth',1.5); %follower 5
    plot3(yout6(nn,1),yout6(nn,2),zout6,'ob','MarkerSize',8,'LineWidth',1.5); %follower 6
    plot3(yout7(nn,1),yout7(nn,2),zout7,'ob','MarkerSize',8,'LineWidth',1.5); %follower 7
    
    yfg1 = [yout1(nn,:) zout1; yout2(nn,:) zout2; yout3(nn,:) zout3; yout4(nn,:) zout4; yout1(nn,:) zout1];
    yfg2 = [yout5(nn,:) zout5;yout6(nn,:) zout6;yout7(nn,:) zout7;yout5(nn,:) zout5];
    
    plot3(yfg1(:,1),yfg1(:,2),yfg1(:,3),'-r','LineWidth',1); %画出各Follower之间的连线
    plot3(yfg2(:,1),yfg2(:,2),yfg2(:,3),'-b','LineWidth',1); %画出各Follower之间的连线
    grid on;
    xlabel('$X/m$','interpreter','latex','FontName','Times New Roman','FontSize',14);
    ylabel('$Y/m$','interpreter','latex','FontName','Times New Roman','FontSize',14);
    zlabel('$Z/m$','interpreter','latex','FontName','Times New Roman','FontSize',14);
    
    % trajectory of the systems
    
    plot3(yout01(1:nn,1),yout01(1:nn,2),zout01*ones(nn,1), '--r','LineWidth',1.5); %leader 1
    hold on;
    plot3(yout02(1:nn,1),yout02(1:nn,2),zout02*ones(nn,1),'--b','LineWidth',1.5); %leader 2
    
    plot3(yout1(1:nn,1),yout1(1:nn,2),zout1*ones(nn,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 1
    plot3(yout2(1:nn,1),yout2(1:nn,2),zout2*ones(nn,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 2
    plot3(yout3(1:nn,1),yout3(1:nn,2),zout3*ones(nn,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 3
    plot3(yout4(1:nn,1),yout4(1:nn,2),zout4*ones(nn,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 4
    
    plot3(yout5(1:nn,1),yout5(1:nn,2),zout5*ones(nn,1),'--k','color',[0.6,0.6,0.6],'LineWidth',1); %follower 5
    plot3(yout6(1:nn,1),yout6(1:nn,2),zout6*ones(nn,1),'--g','color',[0.6,0.6,0.6],'LineWidth',1); %follower 6
    plot3(yout7(1:nn,1),yout7(1:nn,2),zout7*ones(nn,1),'--g','color',[0.6,0.6,0.6],'LineWidth',1); %follower 7
    grid on;
    
    view(2)
    axis equal
    drawnow;
    im(k)=getframe(1);
    k=k+1;
    hold off
   
end


% save image

% filename = 'collision_avoid_and_input_dy.gif'; % Specify the output file name

filename = 'collision_avoid_and_input_dy_view2D.gif'; % Specify the output file name
for idx = 1:size(im, 2)
    [A,map] = rgb2ind(frame2im(im(idx)),256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1e-1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1e-1);
    end
end