% ============================================================================
% Problem: An ANFIS is required to predict an aircraft's trajectory during its 
%          landing aboard an aircraft carrier.
% ============================================================================

% Hit any key to plot an example of the aircraft trajectory. 
pause

[trajectory1_data, trajectory2_data, trajectory3_data, trajectory4_data,...
      trajectory5_data, trajectory6_data, trajectory7_data, trajectory8_data,...
      trajectory9_data, trajectory10_data] = ANFIS_data;
time=0:120; time=time'; time=time/2;
figure
plot(time, trajectory1_data);
xlabel('Time, sec'); ylabel('Lineup, ft');
title('Example of the aircraft trajectory');

echo off;

% Training data set
trn_data=[];
for i=0:106
   trn_data=[trn_data; trajectory1_data(i+1) trajectory1_data(i+3)...
         trajectory1_data(i+5) trajectory1_data(i+7) trajectory1_data(i+9)...
         trajectory1_data(i+11) trajectory1_data(i+15)];
   trn_data=[trn_data; trajectory3_data(i+1) trajectory3_data(i+3)...
         trajectory3_data(i+5) trajectory3_data(i+7) trajectory3_data(i+9)...
         trajectory3_data(i+11) trajectory3_data(i+15)];
   trn_data=[trn_data; trajectory5_data(i+1) trajectory5_data(i+3)...
         trajectory5_data(i+5) trajectory5_data(i+7) trajectory5_data(i+9)...
         trajectory5_data(i+11) trajectory5_data(i+15)];
   trn_data=[trn_data; trajectory7_data(i+1) trajectory7_data(i+3)...
         trajectory7_data(i+5) trajectory7_data(i+7) trajectory7_data(i+9)...
         trajectory7_data(i+11) trajectory7_data(i+15)];
   trn_data=[trn_data; trajectory9_data(i+1) trajectory9_data(i+3)...
         trajectory9_data(i+5) trajectory9_data(i+7) trajectory9_data(i+9)...
         trajectory9_data(i+11) trajectory9_data(i+15)];
end

% Test data set
test_trajectory2=[];
for i=0:106
   test_trajectory2=[test_trajectory2; trajectory2_data(i+1) trajectory2_data(i+3)...
         trajectory2_data(i+5) trajectory2_data(i+7) trajectory2_data(i+9)...
         trajectory2_data(i+11) trajectory2_data(i+15)];
end
test_trajectory4=[];
for i=0:106
   test_trajectory4=[test_trajectory4; trajectory4_data(i+1) trajectory4_data(i+3)...
         trajectory4_data(i+5) trajectory4_data(i+7) trajectory4_data(i+9)...
         trajectory4_data(i+11) trajectory4_data(i+15)];
end
test_trajectory6=[];
for i=0:106
   test_trajectory6=[test_trajectory6; trajectory6_data(i+1) trajectory6_data(i+3)...
         trajectory6_data(i+5) trajectory6_data(i+7) trajectory6_data(i+9)...
         trajectory6_data(i+11) trajectory6_data(i+15)];
end
test_trajectory8=[];
for i=0:106
   test_trajectory8=[test_trajectory8; trajectory8_data(i+1) trajectory8_data(i+3)...
         trajectory8_data(i+5) trajectory8_data(i+7) trajectory8_data(i+9)...
         trajectory8_data(i+11) trajectory8_data(i+15)];
end
test_trajectory10=[];
for i=0:106
   test_trajectory10=[test_trajectory10; trajectory10_data(i+1) trajectory10_data(i+3)...
         trajectory10_data(i+5) trajectory10_data(i+7) trajectory10_data(i+9)...
         trajectory10_data(i+11) trajectory10_data(i+15)];
end

echo on;

% Hit any key to define the number of membership functions to be assigned to
% each input variable, type of the membership function, and the number of 
% training epochs.
pause 

numMFs = 2;         % Number of membership functions assigned to an input variable
mfType = 'gbellmf'; % Type of the membership function
epoch_n = 1;        % Number of training epochs

% Hit any key to generate the ANFIS.
pause

in_fismat = genfis1(trn_data,numMFs,mfType);

% Hit any key to plot initial membership functions of the ANFIS. 
pause 

[a1,mf1] = plotmf(in_fismat,'input',1);
figure('name','Initial membership functions of the input variables')
subplot(2,2,1), plot(a1,mf1);
title('Input variable 1: time (t - 5) sec');
ylabel('Degree of membership');

[a2,mf2] = plotmf(in_fismat,'input',2);
subplot(2,2,2), plot(a2,mf2);
title('Input variable 2: time (t - 4) sec');
ylabel('Degree of membership');

[a3,mf3] = plotmf(in_fismat,'input',3);
subplot(2,2,3), plot(a3,mf3);
title('Input variable 3: time (t - 3) sec');
xlabel('Lineup, ft');
ylabel('Degree of membership');

[a4,mf4] = plotmf(in_fismat,'input',4);
subplot(2,2,4), plot(a4,mf4);
title('Input variable 4: time (t - 2) sec');
xlabel('Lineup, ft');
ylabel('Degree of membership');

% Hit any key to continue.
pause

[a5,mf5] = plotmf(in_fismat,'input',5);
figure('name','Initial membership functions of the input variables')
subplot(2,2,1), plot(a5,mf5);
title('Input variable 5: time (t - 1) sec');
xlabel('Lineup, ft');
ylabel('Degree of membership');

[a6,mf6] = plotmf(in_fismat,'input',6);
subplot(2,2,2), plot(a6,mf6);
title('Input variable 6: time t');
xlabel('Lineup, ft');
ylabel('Degree of membership');

% Hit any key to train the ANFIS. 
pause

out_fismat = anfis(trn_data,in_fismat,epoch_n);

% Hit any key to plot the ANFIS membership functions after training. 
pause 

[a1,mf1] = plotmf(out_fismat,'input',1);
figure('name','Final membership functions of the input variables')
subplot(2,2,1), plot(a1,mf1);
title('Input variable 1: time (t - 5) sec');
ylabel('Degree of membership');

[a2,mf2] = plotmf(in_fismat,'input',2);
subplot(2,2,2), plot(a2,mf2);
title('Input variable 2: time (t - 4) sec');
ylabel('Degree of membership');

[a3,mf3] = plotmf(in_fismat,'input',3);
subplot(2,2,3), plot(a3,mf3);
title('Input variable 3: time (t - 3) sec');
xlabel('Lineup, ft');
ylabel('Degree of membership');

[a4,mf4] = plotmf(in_fismat,'input',4);
subplot(2,2,4), plot(a4,mf4);
title('Input variable 4: time (t - 2) sec');
xlabel('Lineup, ft');
ylabel('Degree of membership');

% Hit any key to continue.
pause

[a5,mf5] = plotmf(in_fismat,'input',5);
figure('name','Final membership functions of the input variables')
subplot(2,2,1), plot(a5,mf5);
title('Input variable 5: time (t - 1) sec');
xlabel('Lineup, ft');
ylabel('Degree of membership');

[a6,mf6] = plotmf(in_fismat,'input',6);
subplot(2,2,2), plot(a6,mf6);
title('Input variable 6: time t');
xlabel('Lineup, ft');
ylabel('Degree of membership');

% Hit any key to plot an actual trajectory of the aircraft and ANFIS predictions.
pause

figure('name','Aircraft trajectory and ANFIS predictions')
plot(time, trajectory8_data,'b-');
xlabel('Time, sec'); ylabel('Lineup, ft');
hold on
plot(time(15:121), evalfis([test_trajectory8(:,1:6)],out_fismat),'r-');
plot(time(15:121), evalfis([test_trajectory8(:,1:6)],out_fismat),'r.');
hold off
legend('Actual aircraft trajectory','ANFIS prediction',1);

% Hit any key to plot the ANFIS prediction errors.
pause

figure('name','Prediction errors')
plot(time(15:121),trajectory8_data(15:121)-evalfis([test_trajectory8(:,1:6)],out_fismat));
xlabel('Time, sec'); ylabel('Prediction error, ft');

echo off
disp('end of ANFIS_trajectory2')