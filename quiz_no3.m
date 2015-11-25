clear all;
%% Andika Nugraha - 1412409712
% Quiz 03

k = 2;
sim_qty = 2;

%% Get Query Image

I_1 = [[0,0,0];[5,5,5];[0,0,0]];
I_2 = [[0,5,0];[0,5,0];[0,5,0]];
I_test = [[0,7,3];[0,5,5];[0,5,0]];

%% Reshape into 1-d vertical
I_1_reshape = reshape(I_1,[9,1]);
I_2_reshape = reshape(I_2,[9,1]);
I_test_reshape = reshape(I_test,[9,1]);

A = [I_1_reshape I_2_reshape];
Q = I_test_reshape;

%% Calculate SVD
A_double = double(A);
[U,S,V] = svd(A_double);
V_t = V';

%% Use K on U S V
U_k = U(:,1:k);
S_k = S(1:k,1:k);
V_k = V(:,1:k);
V_tk = V_t(1:k,:);

%% Get Image query and calculate new result 
Q_double = double(Q);
Q_t = Q_double';
S_1k = S_k.^-1;
S_1k(S_1k==Inf) = 0;

Q_result = Q_t * U_k * S_1k;

%% Calculate similarity within image collections
sim = zeros(size(A,2),1);
for i=1:size(A,2)
    D = V_k(i,:);
    Q_r_norm = norm(Q_result);
    D_norm = norm(D);
    sim_upper = dot(Q_result, D);
    sim_lower = Q_r_norm * D_norm;
    sim(i,:) = sim_upper / sim_lower;
end


%% Sort the best similarity value and its index
[sim_sortval,sim_sortidx] = sort(sim,'descend');

disp('Best similar image index: ');
disp('Similarity    Index');
disp([sim_sortval sim_sortidx]);

%% Save LSI result into mat

R.A = A;
R.A_double = A_double;
R.U = U;
R.S = S;
R.V = V;
R.sim_sortidx = sim_sortidx;

% save('quiz_no3.mat', 'R');
