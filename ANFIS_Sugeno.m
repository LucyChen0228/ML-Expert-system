
% ===================================================================
% Problem: An ANFIS is required to approximate a non-linear function.
% ===================================================================

% Hit any key to define and plot a non-linear function to be approximated. 
pause

x1=(0:0.1:10)';
x2=sin(x1);
y=cos(2*x1)./exp(x2);

figure('name','Trajectory of the function');
plot3(x1,x2,y);
set(gca,'box','on');
xlabel('Input variable x1');
ylabel('Input variable x2');
zlabel('Output variable y');
hold on;

% Hit any key to define the number of membership functions to be assigned to
% each input variable, type of the membership function, and the number of 
% training epochs.
pause 

numMFs = 2;         % Number of membership functions assigned to an input variable
mfType = 'gbellmf'; % Type of the membership function
epoch_n = 100;      % Number of training epochs

% Hit any key to generate the ANFIS.
pause

trnData = [x1 x2 y];
in_fismat = genfis1(trnData,numMFs,mfType);

% Hit any key to plot initial membership functions of the ANFIS. 
pause 

[a1,mf1] = plotmf(in_fismat,'input',1);
figure('name','Initial membership functions of the input variables')
subplot(2,1,1), plot(a1,mf1);
xlabel('Input variable x1');
ylabel('Degree of membership');

% Hit any key to continue.
pause

[a2,mf2] = plotmf(in_fismat,'input',2);
subplot(2,1,2), plot(a2,mf2);
xlabel('Input variable x2');
ylabel('Degree of membership');

% Hit any key to train the ANFIS. 
pause

out_fismat = anfis(trnData,in_fismat,epoch_n);

% Hit any key to plot the ANFIS membership functions after training. 
pause 

[a1,mf1] = plotmf(out_fismat,'input',1);
figure('name','Final membership functions of the input variables')
subplot(2,1,1), plot(a1,mf1); 
xlabel('Input variable x1');
ylabel('Degree of membership');

% Hit any key to continue.
pause

[a2,mf2] = plotmf(out_fismat,'input',2);
subplot(2,1,2), plot(a2,mf2);
xlabel('Input variable x2');
ylabel('Degree of membership');

% Hit any key to plot the ANFIS output after training.
pause

figure('name','The ANFIS otput after training')
plot3(x1,x2,y,'b-',x1,x2,evalfis([x1 x2],out_fismat),'r.');
set(gca,'box','on');
xlabel('Input variable x1');
ylabel('Input variable x2');
zlabel('Output variable y');
legend('Training data','ANFIS output',2);

echo off
disp('end of ANFIS_Sugeno')
