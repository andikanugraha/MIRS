clear all;
%% Andika Nugraha - 1412409712
% Quiz01 - Multimedia Indexing and Retrieval
% Question: find best matching document based on query
% D1: 'banking on banks to raise the interest rate'
% D2: 'jogging along the river bank to look at the sailboats'
% D3: 'jogging to the bank to look at the interest rate'
% D4: 'buzzer-beating shot banked in !'
% D5: 'scenic outlooks on the banks of the Potomac River'
% Query: bank river



%% T: term, Q: query, D: documents (manual stemming)
T = {'bank', 'raise', 'interest', 'rate', 'jog', 'river', 'look', 'sailboat',...
    'buzzer-beating', 'shot', 'scenic', 'outlook', 'potomac'};

Q = 'bank river';

D = {                                           %index:
    'bank bank raise interest rate',...         %1
    'jog river bank look sailboat',...          %2
    'jog bank look interest rate',...           %3
    'buzzer-beating shot bank',...              %4
    'scenic outlook bank potomac river',...     %5
    Q};                                         %6

%% find term frequency for each document

num_term = length(T);
num_doc = length(D);
idx_query = num_doc;

df = zeros(num_doc,num_term);
for n=1:num_doc
    for i=1:num_term
        count = strmatch(T{i}, strsplit(D{n}), 'exact'); 
        df(n,i) = length(count);
    end
end

%% count term on document
df1 = df;
df1(df1>1) = 1;
tn = sum(df1); 

%% calculate weight
idf = zeros(num_doc,num_term);
w = zeros(num_doc,num_term);
for n=1:num_doc
    for i=1:num_term
        idf(n,i) = log10(num_doc / tn(1,i));
        w(n,i) = times( df(n,i), idf(n,i) );
    end
end

%% calculate weight with normalize
idf2 = power(idf,2);
df2 = power(df,2);
idf_tf = times(df2,idf2);
idf_sum = sum(idf_tf,2);

wn = zeros(num_doc,num_term);
for n=1:num_doc
    for i=1:num_term
        wn(n,i) = w(n,i) / sqrt(idf_sum(n));
    end
end
 
%% calculate similarity
wn_sum = sum(wn);
sim = zeros(num_doc);
for n=1:num_doc
   for m=1:num_doc
       a = 0;
       for i=1:num_term
           a = a + wn(n,i) * wn(m,i);
       end
       sim(n,m) = a;
   end
end

%% create ranking based on query similarity
[sim_sort,rank] = sort(sim(idx_query,:),'descend');
disp('Rank index:');
disp(rank);

%% save result and write to XLS
R.term = T;
R.documents = D;
R.query = Q;
R.df = df;
R.idf = idf;
R.weight = w;
R.weight_normalize = wn;
R.similarity = sim;
R.rank = rank;

filename = 'result.xlsx';
save('result.mat', 'R');

xlswrite(filename, R.documents, 'Documents');
xlswrite(filename, R.df, 'DF');
xlswrite(filename, R.idf, 'IDF');
xlswrite(filename, R.weight, 'Weight');
xlswrite(filename, R.weight_normalize, 'Weight Normalize');
xlswrite(filename, R.similarity, 'Similarity');
xlswrite(filename, R.rank, 'Rank');
