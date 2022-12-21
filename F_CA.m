function [F_ca_vector] = F_CA(Xi,Xj)
% 防碰撞函数计算 只算一个轴 ---排斥力 collision avoidance
%
D_ca_min=0.60;
D_ca_max=0.65;
D_ca_max_exp=1;   % 防碰撞对应的参数

dist = norm(Xi-Xj);
Kca = 15;     % 先改这个参数，改变最小值
v_ca = 1;     % 再改这个值，改变最大值
f_ca_tlide = 1/2*Kca*(D_ca_max-D_ca_min)^v_ca;
w_ca = pi/(D_ca_max_exp-D_ca_max);

if (D_ca_min<dist<=D_ca_max)
    F_ca=Kca*dist/((dist-D_ca_min)^v_ca);
    
else if (D_ca_max<dist<=D_ca_max_exp)
        F_ca = f_ca_tlide*cos(w_ca*(dist-D_ca_max)) + f_ca_tlide;
    else
        F_ca = 0;
    end  
end

F_ca_vector = (Xi-Xj)/dist*F_ca;   % 矢量输出-带正负号 (排斥力)
end


