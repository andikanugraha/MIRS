clear all;
% Andika Nugraha
% MATLAB Quiz no. 2
% 1: +
% 0: -
D = 30; % top 30 document per query
R = 12; % relevant documents

% search engine result
A = [1 1 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1];
B = [0 1 1 0 0 0 1 0 0 1 1 0 1 0 0 0 1 0 0 1 0 0 1 0 1 0 0 0 0 0];


A_1 = length(A(A==1));
A_0 = length(A(A==0));

B_1 = length(B(B==1));
B_0 = length(B(B==0));

A_M = 0;
B_M = 0;
for i=1:D
    % match document
    A_M = A_M + A(i); 
    % precision
    A_P(i) = A_M / i; 
    % recall
    A_R(i) = A_M / R;
    
    % match document
    B_M = B_M + B(i); 
    % precision
    B_P(i) = B_M / i; 
    % recall
    B_R(i) = B_M / R;
end

%% Plot result
figure;
plot(A_R,A_P, 'r-s','LineWidth',1,'MarkerSize',3);
hold on;
plot(B_R,B_P, 'b-s','LineWidth',1,'MarkerSize',3);
legend('A','B','Location','NW');
title('A vs B Precision Recall');
hold off;

