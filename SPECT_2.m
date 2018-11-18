
disp(' ============================================================')
disp(' Cardiac SPECT diagnosis: Mark 2 (Neuro-fuzzy classification)')
disp(' ============================================================')

disp(' =============================================================================')
disp(' Problem: The Single Proton Emission Computed Tomography (SPECT) data set     ')
disp('          contains two classes, normal and abnormal, according to physician   ')
disp('          interpretation. A neuro-fuzzy system is required to classify patient')
disp('          SPECT images.                                                       ')
disp(' =============================================================================')

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

normal=find([1 0]');
abnormal=find([0 1]');

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

% Hit any key to load the fuzzy system.
pause

fuz_s1=readfis('SPECT.fis');

% Hit any key to display the whole system as a block diagram.
pause

figure('name','Block diagram of the fuzzy system');
plotfis(fuz_s1);

% Hit any key to display fuzzy sets for the linguistic variable "nn_output1".
pause

figure('name','NN output 1');
plotmf(fuz_s1,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "nn_output2".
pause

figure('name','NN output 2');
plotmf(fuz_s1,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "Risk".
pause

figure('name','Risk');
plotmf(fuz_s1,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(fuz_s1);

% Hit any key to generate a three-dimensional plot for Rule Base.
pause

figure('name','Three-dimensional surface (fuz_s1)');
gensurf(fuz_s1,[1 2],1); view([43.5 34])

% Hit any key to bring up the Rule Viewer.
pause

ruleview(fuz_s1);

echo off

disp(' ')
disp(' Hit any key to test the neuro-fuzzy system using the test data set.')
disp(' ')
pause 

n_normal=0; n_abnormal=0; n_neg=0; n_pos=0;
nn_normal=0;  nn_abnormal=0;  nn_total=0;
fuz_normal=0; fuz_abnormal=0; fuz_total=0;
normal_moderate=0; abnormal_moderate=0;

[m n]=size(test_p);

fprintf(' Desired output   Neural outputs   Neural diagnosis   Error   Fuzzy output   Risk\n');
fprintf(' ================================================================================\n');

nn_output=[];
for i=1:n
   nn_output(:,i)=(sim(net,test_p(:,i)));
end

nn_output=(nn_output-min(min((nn_output)')))/...
   (max(max((nn_output)'))-min(min((nn_output)')));

for i=1:n
   a=compet(sim(net,test_p(:,i))); a=find(a);
   b=compet(test_t(:,i)); b=find(b);
   c=nn_output(:,i)';
   fuz_out1=(evalfis([c],fuz_s1));
   if fuz_out1>30&fuz_out1<50
      for k=1:2:m
         if (test_p((k+1),i)-test_p(k,i))<0
            fuz_out1=fuz_out1*1.01;
            n_neg=n_neg+1;
         else
            fuz_out1=fuz_out1*0.99;
            n_pos=n_pos+1;
         end
      end
   end
   if b==1
      n_normal=n_normal+1;   
      fprintf(' [1 0]   normal  [%.4f  %.4f]',c(1,1),c(1,2));
      if abs(a-b)~=0
         nn_normal=nn_normal+1;   
         fprintf('      abnormal        Yes');
      else
         fprintf('        normal         No');
      end
      if fuz_out1>=50
         fuz_normal=fuz_normal+1;
      elseif fuz_out1>30
         normal_moderate=normal_moderate+1;
      end
   else
      n_abnormal=n_abnormal+1;   
      fprintf(' [0 1] abnormal  [%.4f  %.4f]',c(1,1),c(1,2));
      if abs(a-b)~=0
         nn_abnormal=nn_abnormal+1; 
         fprintf('        normal        Yes');
      else
         fprintf('      abnormal         No');
      end
      if fuz_out1<30
         fuz_abnormal=fuz_abnormal+1;
      elseif fuz_out1<50
         abnormal_moderate=abnormal_moderate+1;
      end
   end
   fprintf('        %.0f',fuz_out1);
   if fuz_out1>=50
      fprintf('        high\n');
   elseif fuz_out1>=30
      fprintf('        moderate\n');
   else
      fprintf('        low\n');
   end
end

nn_total=(nn_normal+nn_abnormal)/n*100;
nn_normal=nn_normal/n_normal*100;
nn_abnormal=nn_abnormal/n_abnormal*100;

fuz_total=(fuz_normal+fuz_abnormal)/n*100;
fuz_normal=fuz_normal/n_normal*100;
fuz_normal_m=normal_moderate/n_normal*100;
fuz_abnormal=fuz_abnormal/n_abnormal*100;
fuz_abnormal_m=abnormal_moderate/n_abnormal*100;

fprintf(1,' \n')
fprintf(1,' Neural classification:\n');
fprintf(1,' The recognition error for normal diagnostic cases:     %.1f%% \n',nn_normal);
fprintf(1,' The recognition error for abnormal diagnostic cases:   %.1f%% \n',nn_abnormal);
fprintf(1,' \n')
fprintf(1,' The total recognition error of the neural network:     %.1f%% \n',nn_total);
fprintf(1,' \n')

fprintf(1,' Neuro-fuzzy classification:\n');
fprintf(1,' The recognition error for normal diagnostic cases:     %.1f%% ',fuz_normal);
fprintf(1,'(moderate risk: %.1f%%) \n',fuz_normal_m);
fprintf(1,' The recognition error for abnormal diagnostic cases:   %.1f%% ',fuz_abnormal);
fprintf(1,'(moderate risk: %.1f%%) \n',fuz_abnormal_m);
fprintf(1,' \n')
fprintf(1,' The total recognition error of the neuro-fuzzy system: %.1f%% \n',fuz_total);
fprintf(1,' \n')

disp('end of SPECT_2.m');