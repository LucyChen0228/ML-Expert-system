disp(' ============================================================================')
disp(' Problem: The Single Proton Emission Computed Tomography (SPECT) data set    ')
disp('          contains two classes, normal and abnormal, according to physician  ')
disp('          interpretation. A three-layer back-propagation network is required ')
disp('          to classify patient SPECT images.                                  ') 
disp(' ============================================================================')

% rand('seed',1352);

% SPECT training and testing data sets 

[spect_train] = SPECT_train;
spect_p = (spect_train(:,[2:45]))';
spect_t = (spect_train(:,1))';

[spect_test] = SPECT_test;
spect_test_p = (spect_test(:,[2:45]))';
spect_test_t = (spect_test(:,1))';

% Massaged values for the SPECT training and testing data sets

p=spect_p/100;
test_p=spect_test_p/100;

[m n]=size(spect_t); t=[];

for i=1:n
   if spect_train(i,1)==0
      spect_target=[1 0]';
   else
      spect_target=[0 1]';
   end
   t = [t spect_target];
end

[m n]=size(spect_test_t); test_t=[];

for i=1:n
   if spect_test(i,1)==0
      spect_target=[1 0]';
   else
      spect_target=[0 1]';
   end
   test_t = [test_t spect_target];
end

[m n]=size(p);  [m test_n]=size(test_p); 

disp(' ')
fprintf(1,' The training data set contains %.0f elements.\n',n);
fprintf(1,' The test data set contains %.0f elements.\n',test_n);
disp(' ')

disp('Hit any key to continue.') 
disp(' ')
pause

echo on

% Hit any key to define the network architecture. 
pause 

s1=7;  % Seven neurons in the hidden layer
s2=2;  % Two neurons in the output layer

% Hit any key to create the network, initialise its weights and biases, 
% and set up training parameters.
pause 

net = newff(minmax(p),[s1 s2],{'tansig' 'purelin'},'trainlm');

net.trainParam.show=1;       % Number of epochs between showing the progress
net.trainParam.epochs=100;   % Maximum number of epochs
net.trainParam.goal=0.01;    % Performance goal
net.trainParam.lr=0.1;       % Learning rate

% Hit any key to train the back-propagation network. 
pause 

[net,tr]=train(net,p,t);

echo off

disp(' ')
disp(' Hit any key to test the network using the test data set.')
disp(' ')
pause 

n_normal=0; n_abnormal=0;
error_normal=0; error_abnormal=0; error=0;

[m n]=size(test_p);

for i=1:n
   a=compet(sim(net,test_p(:,i))); a=find(a);
   b=compet(test_t(:,i)); b=find(b);
   if b==1
      n_normal=n_normal+1;
      if abs(a-b)~=0
         error_normal=error_normal+1;
      end
   else
      n_abnormal=n_abnormal+1;
      if abs(a-b)~=0
         error_abnormal=error_abnormal+1;
      end
   end
end

error=(error_normal+error_abnormal)/n*100;
error_normal=error_normal/n_normal*100;
error_abnormal=error_abnormal/n_abnormal*100;

fprintf(1,' \n')
fprintf(1,' The normal diagnosis recognition error:   %.2f \n',error_normal);
fprintf(1,' The abnormal diagnosis recognition error: %.2f \n',error_abnormal);
fprintf(1,' \n')
fprintf(1,' The overall diagnosis recognition error:  %.2f \n',error);
fprintf(1,' \n')

disp('end of SPECT_1.m')


