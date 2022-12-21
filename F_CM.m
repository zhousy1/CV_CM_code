function [F_cm_vector] = F_CM(Xi,Xj)
% 连通性保持函数计算 只算一个轴 --------吸引力 Connectivity Maintenance
%
D_cm_max=42;      % 需要保持的最小距离
D_cm_min=35;      %
D_cm_min_exp=30;   % 连通性保持--对应的参数

Kcm=0.1;   % 先改这个参数，对极值影响大
v = 10;    % 斥力函数对应的倍数(可以修改)

dist = norm(Xi-Xj);
f_cm_bar = 1/2*Kcm*(D_cm_min-D_cm_max)^v;
w_cm = pi/(D_cm_min-D_cm_min_exp);

if (D_cm_min< dist <= D_cm_max)
    F_cm=-Kcm*dist/((dist-D_cm_max)^v);
    
else if (D_cm_min_exp< dist <=D_cm_min)
        F_cm = -f_cm_bar*cos(w_cm*(dist-D_cm_min_exp)) + f_cm_bar;
    else
        F_cm = 0;
    end  
end

F_cm_vector = (Xi-Xj)/dist*F_cm;   % 矢量输出-带正负号
end


