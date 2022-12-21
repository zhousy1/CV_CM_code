function [X_i,U_i] = Regulator_fun(A_i,B_i,C_i, A0,C0)
% 调节器方程 （Xi,Ui）
% 满足 Xi*A0=Ai*Xi+Bi*Ui
%         0=Ci*Xi-C0                         (A0,C0) leader的方程

% X_i = pinv(C_i)*C0;
X_i = [1 0;
          0 1];
U_i =pinv(B_i)*(X_i*A0-A_i*X_i);
end

