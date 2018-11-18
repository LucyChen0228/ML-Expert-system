% ============================================================================
% Problem: Current practice of cholesterol measurements is based on separating 
%          cholesterol into fractions. However, it was suggested that the 
%          cholesterol levels could be measured directly from measurements of
%          the spectral content of a blood serum sample. In this case study, 
%          we can use measurements of 21 wavelengths of the spectrum for 264 
%          patients, and reference measurements of cholesterol in lipoprotein
%          fractions for the same patients. 
%          We are required to select a data mining tool to solve this problem. 
% ============================================================================
%
% Hit any key to continue.
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1: The ANN application
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% It appears that a back-propagation neural network can be trained to predict 
% cholesterol levels in HDL (high density), LDL (low density) and VLDL (very 
% low density) fractions given the measurements of 21 wavelengths.
%
% Hit any key to load the cholesterol data.
pause

[p,t] = Cholesterol_data;

echo off

for i=1:21
    for j=1:263
        p(j,i)=p(j,i)-mean(p(:,i));
    end
end

p=p'; t=t';

rand('seed',2336);

echo on

% Hit any key to randomly divide the data into training (60%), validation (20%)
% and test (20%) sets. A validation set is used to stop training early -  
% the network is trained on the training data until its performance on the 
% validation data fails to improve for a number of consecutive epochs.
pause

[trainP,valP,testV,trainInd,valInd,testInd] = dividerand(p,0.6,0.2,0.2);
[trainT,valT,testT] = divideind(t,trainInd,valInd,testInd);

% Hit any key to define the network architecture. 
pause 

s1=7; % Five neurons in the hidden layer

% Hit any key to create the network, initialise its weights and biases, 
% and set up training parameters.
pause 

net = newff(p,t,s1);

net.trainParam.show = 20;      % Number of epochs between showing the progress
net.trainParam.epochs = 1000;  % Maximum number of epochs
net.trainParam.goal = 0.01;    % Performance goal
net.trainParam.lr=0.1;         % Learning rate

% Hit any key to train the back-propagation network. 
pause 

[net,tr] = train(net,p,t);
plotperform(tr);

% Hit any key to perform regression analysis between the desired outputs 
% and the actual outputs of the network.  
pause

test_p=p(:,tr.testInd);
test_t=t(:,tr.testInd);
a=sim(net,test_p);

figure
h=plot(a(1,:),test_t(1,:),'bo','markersize',3);
lsline;
set(refline([1 1]),'Color','r'); 
R1 = corrcoef(a(1,:),test_t(1,:)); R1=R1(1,2);
axis('image');
title(['r = ',num2str(R1)]);
xlabel('HDL Desired output');
ylabel('HDL Actual output');

% Hit any key to continue.
pause

figure
plot(a(2,:),test_t(2,:),'bo','markersize',3);
lsline;
set(refline([1 1]),'Color','r'); 
R2 = corrcoef(a(2,:),test_t(2,:)); R2=R2(1,2);
axis('image');
title(['r = ',num2str(R2)]);
xlabel('LDL Desired output');
ylabel('LDL Actual output');

% Hit any key to continue.
pause

figure
plot(a(3,:),test_t(3,:),'bo','markersize',3);
lsline;
set(refline([1 1]),'Color','r'); 
R3 = corrcoef(a(3,:),test_t(3,:)); R3=R3(1,2);
axis('image');
title(['r = ',num2str(R3)]);
xlabel('VLDL Desired output');
ylabel('VLDL Actual output');

% To improve the accuracy of the cholesterol level prediction, we can use 
% an ANFIS model. However, before we can apply it, we need to reduce the 
% number of inputs.  This task can be accomplished by PCA. 
%
% Hit any key to continue.
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2: The PCA & ANFIS application
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Hit any key to load the cholesterol data.
pause

[p,t] = Cholesterol_data;

echo off

for i=1:21
    for j=1:263
        x(j,i)=p(j,i)-mean(p(:,i));
    end
end

echo on

% Hit any key to perform PCA.
pause

C=cov(x);
lambda=eig(C);     % The eigenvalues
lambda=sort(lambda,'descend');
variance=lambda*100/sum(lambda);

% Hit any key to display the scree plot for the 21-dimensional spectrum data set.
pause

figure
plot(variance); axis([1 21 0 100]);
title('Scree plot for the 21-dimensional spectrum data set');
xlabel('Eigenvalue number');
ylabel('Variance, %');

[V,D] = eig(C);    % V is the matrix with the eigenvectors
V=V(:,21:-1:1);

echo off

fin=x*V;
data=fin*V';
for i=1:21
    for j=1:263
        data(j,i)=data(j,i)+mean(p(:,i));
    end
end

V1=[V(:,1) V(:,2) V(:,3) V(:,4)];
fin1=x*V1;
data1=fin1*V1';
for i=1:21
    for j=1:263
        data1(j,i)=data1(j,i)+mean(p(:,i));
    end
end

echo on

% Hit any key to continue.
pause

% Hit any key to randomly select inputs and outputs to be used in ANFIS training. 
% For this study, we randomly split the transformed data into two sets: training
% (80%) and test (20%).
pause

echo off

tr_p=[]; tr_t=[]; test_p=[]; test_t=[];

[a b]=size(fin1);
for n=1:a
   if rand(1)>1/3
      tr_p=[tr_p; fin1(n,:)];
      tr_t=[tr_t; t(n,:)];
   else
      test_p=[test_p; fin1(n,:)];
      test_t=[test_t; t(n,:)];
   end
end

[m n]=size(test_p);

disp(' ')
fprintf(1,' The training data set contains %.0f elements.\n',(a-m));
fprintf(1,' The test data set contains %.0f elements.\n',m);
disp(' ')

echo on


% Hit any key to define the number of membership functions to be assigned to
% input variable, type of the membership function, and the number of 
% training epochs.
pause 

numMFs = 2;         % Number of membership functions assigned to each input variable
mfType = 'gbellmf'; % Type of the membership function
epoch_n = 10;       % Number of training epochs

% As an ANFIS architecture permits only one output, we will use three identical
% models, each predicting cholesterol in a single lipoprotein fraction.
%
% Hit any key to generate the ANFIS model for HDL prediction.
pause

trnData1 = [tr_p tr_t(:,1)];
in_fismat1 = genfis1(trnData1,numMFs,mfType);

% Hit any key to train the ANFIS to predict HDL. 
pause

out_fismat1 = anfis(trnData1,in_fismat1,epoch_n);

% Hit any key to generate the ANFIS model for LDL prediction.
pause

trnData2 = [tr_p tr_t(:,2)];
in_fismat2 = genfis1(trnData2,numMFs,mfType);

% Hit any key to train the ANFIS to predict LDL. 
pause

out_fismat2 = anfis(trnData2,in_fismat2,epoch_n);

% Hit any key to generate the ANFIS model for VLDL prediction.
pause

trnData3 = [tr_p tr_t(:,3)];
in_fismat3 = genfis1(trnData3,numMFs,mfType);

% Hit any key to train the ANFIS to predict VLDL. 
pause

out_fismat3 = anfis(trnData3,in_fismat3,epoch_n);

% Hit any key to perform regression analysis between the desired outputs 
% and the actual outputs of the ANFIS models.  
pause

echo off 

t_p=test_p; t_t=test_t; test_p=[]; test_t=[]; num=0;
[a b]=size(t_p);
for nrow=1:a
    for ncol=1:b
        if t_p(nrow,ncol)>=min(tr_p(:,b))& t_p(nrow,ncol)<=max(tr_p(:,b));
           num=num+1;
        end
        if num==b;
           test_p=[test_p; t_p(nrow,:)];
           test_t=[test_t; t_t(nrow,:)]; 
        end
    end
    num=0;
end

test_p=[test_p(:,:); tr_p(:,:)]; test_t=[test_t(:,:);tr_t(:,:)];

a1=evalfis(test_p,out_fismat1);
a2=evalfis(test_p,out_fismat2);
a3=evalfis(test_p,out_fismat3);

echo on

figure
plot(a1,test_t(:,1),'bo','markersize',3);
lsline;
set(refline([1 1]),'Color','r'); 
R1 = corrcoef(a1,test_t(:,1)); R1=R1(1,2);
axis('image');
title(['r = ',num2str(R1)]);
xlabel('HDL Desired output');
ylabel('HDL Actual output');

% Hit any key to continue.
pause

figure
plot(a2,test_t(:,2),'bo','markersize',3);
lsline;
set(refline([1 1]),'Color','r'); 
R2 = corrcoef(a2,test_t(:,2)); R2=R2(1,2);
axis('image');
title(['r = ',num2str(R2)]);
xlabel('LDL Desired output');
ylabel('LDL Actual output');

% Hit any key to continue.
pause

figure
plot(a3,test_t(:,3),'bo','markersize',3);
lsline;
set(refline([1 1]),'Color','r'); 
R3 = corrcoef(a3,test_t(:,3)); R3=R3(1,2);
axis('image');
title(['r = ',num2str(R3)]);
xlabel('VLDL Desired output');
ylabel('VLDL Actual output');

echo off
disp('end of Cholesterol_predict')
